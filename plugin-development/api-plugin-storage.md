# How to Write Storage Plugin

Fluentd supports [pluggable storage](../storage/) which lets a plugin keep its internal state as key-value pairs. The plugin filenames prefixed `storage_` are registered as Storage Plugins.

See [Plugin Base Class API](api-plugin-base.md) for details on the common APIs for all the plugin types.

Here is an example of a custom storage plugin that keeps the pairs in memory and saves them into a YAML file. It takes a required parameter called `path`, which is the pathname of that file.

```ruby
require 'fileutils'
require 'yaml'

require 'fluent/plugin/storage'

module Fluent::Plugin
  class MyYamlStorage < Storage
    # Register MyYamlStorage as 'my_yaml'.
    Fluent::Plugin.register_storage('my_yaml', self)

    config_param :path, :string

    def initialize
      super
      @store = {}
    end

    def configure(conf)
      super

      FileUtils.mkdir_p(File.dirname(@path))
    end

    # Restores the saved pairs. Keeps the pairs in memory on a broken file,
    # instead of throwing away what the owner plugin has stored so far.
    def load
      return unless File.exist?(@path)

      data = YAML.safe_load(File.read(@path))
      unless data.is_a?(Hash)
        log.error "broken content in the storage file", path: @path
        return
      end
      @store = data
    rescue => e
      log.error "failed to load the storage file", path: @path, error: e
    end

    # Writes the pairs out. Renames a temporary file so that a crash in the
    # middle of the write does not leave a half-written file behind.
    def save
      tmp_path = "#{@path}.tmp"
      File.write(tmp_path, YAML.dump(@store))
      File.rename(tmp_path, @path)
    rescue => e
      log.error "failed to save the storage file", path: @path, error: e
    end

    def get(key)
      @store[key.to_s]
    end

    def fetch(key, defval)
      @store.fetch(key.to_s, defval)
    end

    def put(key, value)
      @store[key.to_s] = value
    end

    def delete(key)
      @store.delete(key.to_s)
    end

    def update(key, &block)
      @store[key.to_s] = block.call(@store[key.to_s])
    end
  end
end
```

Save this as `storage_my_yaml.rb` in a loadable plugin path.

With `in_sample` input plugin:

```text
<source>
  @type sample
  tag test
  auto_increment_key count
  <storage awesome_path>
    @type my_yaml
    path /path/to/storage.yaml
  </storage>
</source>
```

`in_sample` keeps its counters through this plugin, so `/path/to/storage.yaml` looks like this:

```text
---
increment_value: 0
dummy_index: 0
auto_increment_value: 18
```

Restarting Fluentd resumes `count` from the saved `auto_increment_value`.

NOTE: The argument of the `<storage>` section is the name of the storage. The plugin helper creates one instance per `<storage>` section, and hands the owner plugin the instance whose name matches the one it asks for. `in_sample` asks for a named one, so dropping the argument here leaves the helper with one more instance which writes to the same file without ever being used.

The example above is kept short. A storage plugin for real use should also check in `#configure` that `path` is readable and writable, and raise `Fluent::ConfigError` if it is not, so that a misconfiguration stops Fluentd at startup instead of showing up later as a lost state. It also has to decide what to do under [multiple workers](../deployment/multi-process-workers.md): the example writes to a single file, so every worker overwrites the pairs of the others, and Fluentd does not warn about it because `#multi_workers_ready?` returns `true` by default. See [`storage_local`](https://github.com/fluent/fluentd/blob/master/lib/fluent/plugin/storage_local.rb), the built-in implementation, for both.

## How To Use Storages From Plugins

Storage plugins are designed to be used from other plugins, like Input, Filter and Output. The storage plugin helper is there for this purpose:

```ruby
# in class definition
helpers :storage

# in #configure
@storage = storage_create(usage: 'my_state', conf: conf.elements(name: 'storage').first, default_type: 'local')

# in #start, or wherever the state is read and written
@storage.put(:count, 0) unless @storage.get(:count)
```

The helper owns the lifecycle of the created storage. It calls `#load` on start, calls `#save` on the schedule the `<storage>` section asks for, and shuts the storage down with the owner plugin.

See [Storage Plugin Helper API](../plugin-helper-overview/api-plugin-helper-storage.md) for details.

## Methods

Storage plugins implement the methods to read and write key-value pairs. `Fluent::Plugin::Storage` raises `NotImplementedError` for all of them, so a plugin must implement every one.

A key is given either as a `String` or as a `Symbol`, and both must point to the same value. The example above normalizes it with `to_s`. `Fluent::Plugin::Storage.validate_key` does the same with a type check: it returns the key as a `String`, and raises `ArgumentError` for anything else.

#### `#get(key)`

It returns the stored value for `key`, or `nil` if there is no value for it.

#### `#fetch(key, defval)`

It returns the stored value for `key`, or `defval` if there is no value for it.

#### `#put(key, value)`

It stores `value` for `key`, and returns the stored value.

#### `#delete(key)`

It removes `key` from the storage, and returns the removed value.

#### `#update(key, &block)`

It calls `&block` with the stored value for `key`, stores the value returned by the block, and returns it. This is a transactional get-and-update, so no other operation on `key` may run in between. See [Persistence and Thread Safety](#persistence-and-thread-safety) for who takes the lock.

The following methods have working default implementations, and a plugin overrides them only when it needs another behavior.

#### `#load`

It reads the pairs from the data source. The owner plugin calls it on start, before any other operation, and also before every operation while `persistent` is enabled. It does nothing by default, which is right for a plugin that reaches the data source on every operation.

#### `#save`

It writes the pairs back to the data source. The owner plugin calls it every `autosave_interval` while `autosave` is enabled, on every write while `persistent` is enabled, and on shutdown while `save_at_shutdown` is enabled. It does nothing by default.

#### `#persistent_always?`

It returns `true` if every operation reaches the data source, so that no value is lost when the process dies. A plugin backed by an external key-value store overrides this to return `true`. \(default: `false`\)

#### `#synchronized?`

It returns `true` if the operations of the plugin are already safe to call from two or more threads. \(default: `false`\)

## Persistence and Thread Safety

`persistent`, `autosave`, `autosave_interval` and `save_at_shutdown` are common to all the storage plugins, and the user sets them in the `<storage>` section. See [Config: Storage Section](../configuration/storage-section.md) for their meanings.

A storage plugin does not act on these parameters itself. The storage plugin helper reads them, together with `#persistent_always?` and `#synchronized?`, and decides what to hand to the owner plugin:

| `persistent` | `#persistent_always?` | `#synchronized?` | The owner plugin gets |
| :--- | :--- | :--- | :--- |
| `true` | `true` | any | the plugin itself |
| `true` | `false` | any | a wrapper which calls `#load` before every operation, and `#save` after every write, under a lock |
| `false` | any | `false` | a wrapper which runs every operation under a lock |
| `false` | any | `true` | the plugin itself |

So the two methods describe what the plugin can already do by itself, not what the user asked for. The helper drops a wrapper only when the plugin already provides what that wrapper would add, and `#persistent_always?` alone does not stop the lock from being added. Returning `false` from both, as the example above does, is always safe.

`#implementation` returns the plugin itself out of a wrapper. Use it when the plugin instance is needed, for example in tests.

## Writing Tests

Fluentd storage plugin has one or more points to be tested. Others \(parsing configurations, the plugin lifecycle, calling `#save` and many others\) are controlled by the Fluentd core.

Fluentd also provides the test driver for plugins. You can easily write tests for your own plugins:

```ruby
# test/plugin/test_storage_your_own.rb

require 'test/unit'
require 'fileutils'
require 'fluent/test'
require 'fluent/test/driver/storage'

# Your own plugin
require 'fluent/plugin/storage_your_own'

class StorageYourOwnTest < Test::Unit::TestCase
  TMP_DIR = File.expand_path(File.dirname(__FILE__) + '/tmp/storage_your_own')

  def setup
    Fluent::Test.setup
    FileUtils.rm_rf(TMP_DIR)
  end

  def teardown
    FileUtils.rm_rf(TMP_DIR)
  end

  CONFIG = %[
    path #{TMP_DIR}/storage.yaml
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Storage.new(Fluent::Plugin::YourOwnStorage).configure(conf)
  end

  sub_test_case 'configured with invalid configurations' do
    test 'empty' do
      assert_raise(Fluent::ConfigError) do
        create_driver('')
      end
    end
    # ...
  end

  sub_test_case 'plugin will store values' do
    test 'stores and restores the pairs' do
      d = create_driver(CONFIG)
      d.instance.put(:key1, 1)
      d.instance.update(:key1) { |v| v + 1 }
      assert_equal(2, d.instance.get(:key1))
      assert_equal('EMPTY', d.instance.fetch(:key2, 'EMPTY'))
      d.instance.save

      d2 = create_driver(CONFIG)
      d2.instance.load
      assert_equal(2, d2.instance.get(:key1))
    end
  end
end
```

The test driver gives the plugin a dummy owner plugin, so `d.instance` is the plugin itself and never a wrapper. To test it as the owner plugin sees it, configure a `<storage>` section on a real owner plugin and take the instance from `storage_create`.

### Overview of Tests

Testing for storage plugins is mainly for:

* Validation of configuration \(i.e. `#configure`\)
* Validation of the stored and restored values

To make testing easy, the plugin test driver provides a logger and the functionality to override the system and storage configurations, etc.

The lifecycle of plugin and test driver is:

1. Instantiate plugin driver which then instantiates the plugin
2. Configure plugin
3. Run test code
4. Assert results of tests by data provided by the driver

For:

* configuration tests, repeat steps \# 1-2
* full feature tests, repeat steps \# 1-4

See [Testing API for Plugins](plugin-test-code.md) for details.
