# Plugin Helper: Storage

The `storage` plugin helper manages the plugin's internal states.

Here is an example:

```ruby
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_input('awesome_example', self)

    # 1. Load storage helper
    helpers :storage, :thread

    DEFAULT_STORAGE_TYPE = 'local'

    # Omit `shutdown` and other plugin APIs

    def initialize
      super

      @storage = nil
    end

    def configure(conf)
      super

      # 2. Create storage with unique name
      config = conf.elements(name: 'storage').first
      @storage = storage_create(usage: 'awesome_index', conf: config, default_type: DEFAULT_STORAGE_TYPE)
    end

    def start
      super

      # 3. Call storage plugin helpers get/put methods
      @storage.put(:awesome_index, 0) unless @storage.get(:awesome_index)
      thread_create(:awesome_input_runner, &method(:run))
    end

    def run
      while thread_current_running?
        current_time = Time.now.to_i
        break unless (thread_current_running? && Time.now.to_i <= current_time)
        router.emit('awesome', Fluent::Engine.now, generate)
        sleep 0.1
      end
    end

    def generate
      # 4. Update storage plugin helper's storing value
      @storage.update(:awesome_index) { |v| v + 1 }
    end
  end
end
```

The created storage is managed by the plugin helper. No need of storage shutdown code in plugin's `shutdown`. It shutdowns the created storages automatically.

For more details, see [Storage](../storage/) section.

## Methods

### `storage_create(usage: '', type: nil, conf: nil, default_type: nil)`

This method executes storage with the given parameters and routine.

* `usage`: unique string value \(default: `''`\)
* `type`: storage plugin type \(default: `nil`\)
* `conf`: storage plugin configuration \(default: `nil`\)
* `default_conf`: storage plugin default configuration \(default: `nil`\)

### Storage Plugin Helper Instance Types

| Instance Type | Attributes |
| :--- | :--- |


Raw \| `persistent && persistent_always? || otherwise` \| Persistent Wrapper \| `persistent` \| Synchronized Wrapper \| `!synchronized?` \|

#### Raw

Storage plugins will handle as-is.

#### Persistent Wrapper

This wrapper makes the handled storage plugin operate values persistently.

#### Synchronized Wrapper

This wrapper makes handled storage plugin operate values synchronically.

### Common Methods

Storage plugin helper encapsulates storage plugin implementation. Normally, the following methods will be called by the owner plugin through this plugin helper:

#### `load`

This method loads persistently stored value.

#### `save`

This method saves value persistently.

#### `get(key)`

* `key`: symbol value.

This method obtains stored value by key.

#### `fetch(key, defval)`

* `key`: symbol value.
* `defval`: default value.

This method obtains the stored value by key. If missing, it returns the default value.

#### `put(key, value)`

* `key`: symbol value.
* `value`: store value.

This method updates the stored value by key.

#### `delete(key)`

* `key`: symbol value.

This method deletes the stored value by key.

#### `update(key, &block)`

* `key`: symbol value.
* `&block`: a `Proc` object.

This method updates the stored value using a `Proc` object.

## Plugins using `storage`

* [`in_sample`](../input/sample.md)
* [`in_windows_eventlog`](../input/windows_eventlog.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

