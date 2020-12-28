# How to Write Output Plugin

Extend `Fluent::Plugin::Output` class and implement its methods.

The exact set of methods to be implemented is dependent on the design of the plugin. The following is a general template for writing a custom output plugin:

```ruby
require 'fluent/plugin/output'

module Fluent::Plugin
  class SomeOutput < Output
    # First, register the plugin. 'NAME' is the name of this plugin
    # and identifies the plugin in the configuration file.
    Fluent::Plugin.register_output('NAME', self)

    # Enable threads if you are writing an async buffered plugin.
    helpers :thread

    # Define parameters for your plugin.
    config_param :path, :string

    #### Non-Buffered Output #############################
    # Implement `process()` if your plugin is non-buffered.
    # Read "Non-Buffered output" for details.
    ######################################################
    def process(tag, es)
      es.each do |time, record|
        # output events to ...
      end
    end

    #### Sync Buffered Output ##############################
    # Implement `write()` if your plugin uses normal buffer.
    # Read "Sync Buffered Output" for details.
    ########################################################
    def write(chunk)
      real_path = extract_placeholders(@path, chunk)

      log.debug 'writing data to file', chunk_id: dump_unique_id_hex(chunk.unique_id)

      # For standard chunk format (without `#format()` method)
      chunk.each do |time, record|
        # output events to ...
      end

      # For custom format (when `#format()` implemented)
      # File.open(real_path, 'w+')

      # or `#write_to(io)` is available
      # File.open(real_path, 'w+') do |file|
      #   chunk.write_to(file)
      # end
    end

    #### Async Buffered Output #############################
    # Implement `try_write()` if you want to defer committing
    # chunks. Read "Async Buffered Output" for details.
    ########################################################
    def try_write(chunk)
      real_path = extract_placeholders(@path, chunk)

      log.debug 'sending data to server', chunk_id: dump_unique_id_hex(chunk.unique_id)

      send_data_to_server(@host, real_path, chunk.read)

      chunk_id = chunk.unique_id

      # Create a thread for deferred commit.
      thread_create(:check_send_result) do
        while thread_current_running?
          sleep SENDDATA_CHECK_INTERVAL # == 5

          if check_data_on_server(real_path, chunk_id)
            # commit chunk
            # chunk will be deleted and not be retried anymore by this call
            commit_write(chunk_id)
            break
          end
        end
      end
    end

    # Override `#format` if you want to customize how Fluentd stores
    # events. Read the section "How to Customize the Serialization
    # Format for Chunks" for details.
    def format(tag, time, record)
      [tag, time, record].to_json
    end
  end
end
```

## Three Modes of Output Plugins

Output plugins have three operational modes. Each mode has a set of interfaces to implement. An output plugin must support \(at least\) one of these three modes.

* Non-Buffered Mode
* Sync-Buffered Mode
* Async-Buffered Mode

### Non-Buffered Mode

This is the simplest mode. The output plugin transfers events to the destination immediately after receiving them. It does not use any buffer and never attempts to retry on errors.

For example, the built-in plugin `out_stdout` normally uses this mode. It just dumps events to the standard output without maintaining any state.

This mode is available when the `#process` method is implemented.

### Sync-Buffered Mode

In this mode, the output plugin temporarily stores events in a buffer and send them later. The exact buffering behavior is fine-tunable through configuration parameters.

The most notable benefit of this mode is that it enables you to leverage the native retry mechanism. The errors such as network failures are transparently handled by Fluentd and you do not need to implement an error-handling mechanism by yourself.

This mode is available when the `#write` method is implemented.

### Async-Buffered Mode

In this mode, the output plugin temporarily stores events in a buffer and send them later. The major difference with the synchronous mode is that this mode allows you to defer the acknowledgment of transferred records. For example, you can implement the **at-least-once** semantics using this mode.

Please read "How To Use Asynchronous Buffered Mode" for details.

This mode is available when the `#try_write` method is implemented.

### How Fluentd Chooses Modes

From the users' perspective, the `<buffer>` section enables buffering. An output plugin will use the buffered mode if available or fail otherwise.

However, from the plugin developer's viewpoint, it is a bit different.

See the full chart here showing how Fluentd chooses a mode:

[**Fluentd v0.14 Plugin API Details**](https://www.slideshare.net/tagomoris/fluentd-v014-plugin-api-details) from [**SATOSHI TAGOMORI**](https://www.slideshare.net/tagomoris)

This is the rule:

* If `<buffer>` section is configured:
  * plugin tries to do buffering
* Else if plugin implements both methods for buffered/non-buffered:
  * plugin calls `#prefer_buffer_processing` to decide \(`true` means to do

    buffering: default is `true`\)
* Else plugin does as implemented.

When plugin does buffering:

* If plugin implements both Sync/Async buffered methods:
  * plugin calls `#prefer_delayed_commit` to decide \(`true` means to use delayed

    commit: default is `true`\)
* Else plugin does as implemented.

It is important to note that the methods that decide modes are called in `#start` after `#configure`. So, the plugins can decide the default behavior using configured parameters by overriding `#prefer_buffer_processing` and `#prefer_delayed_commit` methods.

## How Buffers Work

### Understanding Chunking and Metadata

For more details, see [Buffer](../configuration/buffer-section.md) section.

Fluentd creates buffer chunks to store events. Each buffer chunks should be written at once, without any re-chunking. In Fluentd v1.0, users can specify chunk keys by themselves using `<buffer CHUNK_KEYS>` section.

Example:

```text
<buffer>         # Use pre-configured chunk keys by plugin
<buffer []>      # without any chunk keys: all events will be appended into a chunk
<buffer time>    # events in a time unit will be appended into a chunk
                 # (using `timekey` parameter)
<buffer tag>     # events with same tag will be appended into a chunk
<buffer any_key> # events with same value for specified key will be appended into a chunk
```

When `time` is specified as the chunk key, `timekey` must also be specified in the buffer section. If it is configured as `15m` \(15 minutes\), the events between `00:00:00` and `00:14:59` will be in a chunk. An event at `00:15:00` will be in a different chunk.

Users can specify two or more chunk keys as a list of items separated by comma \(','\).

Example:

```text
<buffer time,tag>
<buffer time,country>
<buffer tag,country,item>
```

Too many chunk keys means too many small chunks and that may result in too many open files in a directory for a file buffer.

Metadata, fetched by `chunk.metadata`, contains values for chunking. If `time` is specified, metadata contains a value in `metadata.timekey`. Otherwise, `metadata.timekey` is `nil`. See `chunk.metadata` for details.

In most cases, plugin authors do not need to consider these values. If you want to use these values to generate any paths, keys, table/database names, etc., you can use `#extract_placeholders` method.

```ruby
@path = "/mydisk/mydir/${tag}/purchase.%Y-%m-%d.%H.log" # This value might be coming from configuration.

extract_placeholders(@path, chunk) # => "/mydisk/mydir/service.cart/purshase.2016-06-10.23.log"
```

The above method call should be performed by the plugin. And, the plugin that supports this feature should explain which configuration parameter accepts placeholders in its documentation.

### How To Control Buffering

Buffer chunks may be flushed due to the following reasons:

1. its size reaches the limit of bytesize or the maximum number of records
2. its `timekey` is expired and `timekey_wait` lapsed
3. it lives longer than `flush_interval`
4. it appends data when `flush_mode` is `immediate`

Buffer configuration provides `flush_mode` to control the mode. Here are its supported values and default behavior:

* `lazy`: 1 and 2 are enabled 
* `interval`: 1, 2 and 3 are enabled
* `immediate`: 4 is enabled

Default is `lazy` if `time` is specified as the chunk key, `interval` otherwise. If `flush_mode` is explicitly configured, the plugin used the configured mode.

### How to Change the Default Values for Parameters

Some configuration parameters are in `fluent/plugin/output.rb` and some are in `fluent/plugin/buffer.rb`. These parameters have been designed to work for most use cases. However, there may be need to override the default values of some parameters in plugins.

To change the default chunk keys and the limit of buffer chunk bytesize of a custom plugin, configure like this:

```ruby
class MyAwesomeOutput < Output
  config_section :buffer do
    config_set_default :chunk_keys, ['tag']
    config_set_default :chunk_limit_size, 2 * 1024 * 1024 # 2MB
  end
end
```

This overriding is valid for this plugin only!

## Development Guide

### How To Use Asynchronous Buffered Mode and Delayed Commit

Plugins must call `#commit_write` in async buffered mode. It is called after some checks and it waits for the completion on destination side, so `#try_write` should NOT block its processing. The best practice is to create a dedicated thread or timer for it when the plugin starts.

Example:

```ruby
class MyAwesomeOutput < Output
  helpers :timer

  def start
    @waiting_ids_mutex = Mutex.new
    @waiting_ids = []

    timer_create(:awesome_delayed_checker, 5) do
      @waiting_ids_mutex.synchronize{ @waiting_ids.dup }.each do |chunk_id|
        if check_it_succeeded(chunk_id)
          commit_write(chunk_id)
          @waiting_ids_mutex.synchronize{ @waiting_ids.delete(chunk_id) }
        end
      end
    end
  end

  def try_write(chunk)
    chunk_id = chunk.unique_id
    send_to_destination(chunk)
    @waiting_ids.synchronize{ @waiting_ids << chunk_id }
  end
end
```

The plugin can perform writing of data and checking/committing completion in parallel, and can use CPU resources more efficiently.

If you are sure that writing of data succeeds right after writing/sending data, you should use sync buffered output instead. Async mode is for destinations that we cannot check immediately after sending data whether it succeeded or not.

### How to Customize the Serialization Format for Chunks

The serialization format to store events in a buffer may be customized by overriding `#format` method.

Generally, it is not needed. Fluentd has its own serialization format and there are many benefits to just use the default one. For example, it transparently allows you to iterate through records via `chunk.each`.

An exceptional case is when the chunks need to sent to the destination without any further processing. For example, `out_file` overrides `#format` so that it can produce chunk files that exactly look like the final outputs. By doing this, `out_file` can flush data just by moving chunk files to the destination path.

For further details, read the interface definition of the `#format` method below.

## List of Interface Methods

Some methods should be overridden/implemented by the plugins. On the other hand, plugins MUST NOT override methods without any mention.

### `#process(tag, es)`

The method for non-buffered output mode. A plugin that supports non-buffered output must implement this method.

* `tag`: a string, represents tag of events. Events in `es` have the same `tag`.
* `es`: an event stream \(`Fluent::EventStream`\)

Return values will be ignored.

### `#write(chunk)`

The method for sync buffered output mode. A plugin that supports sync buffered output must implement this method.

* `chunk`: a buffer chunk \(`Fluent::Plugin::Buffer::Chunk`\)

This method will execute in parallel when `flush_thread_count` is greater than `1`. So, if your plugin modifies an instance variable in this method, you need to synchronize its access using a `Mutex` or some other synchronization facility to avoid the broken state.

Return values will be ignored.

### `#try_write(chunk)`

The method for async buffered output mode. The plugin which supports async buffered output must implement this method.

* `chunk`: a buffer chunk \(Fluent::Plugin::Buffer::Chunk\)

This method will be executed in parallel when `flush_thread_count` is larger than 1. So if your plugin modifies instance variables in this method, you need to protect it with `Mutex` or similar to avoid broken state.

Return values will be ignored.

### `#format(tag, time, record)`

The method for custom formatting of buffer chunks. A plugin that uses a custom format to format buffer chunks must implement this method.

* `tag`: a `String` represents tag of events
* `time`: a `Fluent::EventTime` object or an `Integer` representing Unix

  timestamp \(seconds from Epoch\)

* `record`: a `Hash` with String keys

Return value must be a `String`.

### `#prefer_buffered_processing`

It specifies whether to use buffered or non-buffered output mode as the default when both methods are implemented. `True` means buffered output.

Return value must be `true` or `false`.

### `#prefer_delayed_commit`

It specifies whether to use asynchronous or synchronous output mode when both methods are implemented. `True` means asynchronous buffered output.

Return value must be `true` or `false`.

### `#extract_placeholders(str, chunk)`

It extracts placeholders in the given string using the values in chunk.

* `str`: a `String` containing placeholders
* `chunk`: a `Fluent::Plugin::Buffer::Chunk` via `write`/`try_write`

Return value is a `String`.

### `#commit_write(chunk_id)`

It tells Fluentd that the specified chunk should be committed. That chunk will be purged after this method call.

* `chunk_id`: a `String`, brought by `chunk.unique_id`

This method has some other optional arguments, but those are for internal use.

### `#rollback_write(chunk_id)`

It tells Fluentd that it should retry writing buffer chunk specified in the argument. Plugins can call this method explicitly to retry writing chunks, or they can just leave that chunk ID until timeout.

* `chunk_id`: a `String`, brought by `chunk.unique_id`

### `#dump_unique_id_hex(chunk_id)`

It dumps buffer chunk IDs. Buffer chunk ID is a `String`, but the value may include non-printable characters. This method formats chunk IDs as printable strings that can be used for logging purposes.

* `chunk_id`: a `String`, brought by `chunk.unique_id`

Return value is a `String`.

### `es.size`

`EventStream#size` returns an `Integer` representing the number of events in the event stream.

### `es.each(&block)`

`EventStream#each` receives a block argument and call it for each event \(`time` and `record`\).

Example:

```ruby
es.each do |time, record|
  # ...
end
```

* `time`: a `Fluent::EventTime` object or an `Integer` representing Unix

  timestamp \(seconds from Epoch\)

* `record`: a `Hash` with String keys

### `chunk.unique_id`

Returns a `String` representing a unique ID for buffer chunk.

The returned `String` may include non-printable characters, so use `#dump_unique_id_hex` method to print it in logs or other purposes.

### `chunk.metadata`

Returns a `Fluent::Plugin::Buffer::Metadata` object containing values for chunking.

Available fields of `metadata` are:

* `timekey`: an `Integer` representing Unix timestamp, which is equal to the

  first second of `timekey` range \(`nil` if `time` is not specified\)

* `tag`: a `String` representing event tag \(`nil` if `tag` is not specified\)
* `variables`: a `Hash` with Symbol keys, containing other keys of chunk keys

  and values for these \(`nil` if any other chunk keys are specified\)

For example, `chunk.metadata.timekey` returns an `Integer`. `chunk.metadata.variables[:name]` returns an `Object` if `name` is specified as a chunk key.

### `chunk.size`

Returns an `Integer` representing the bytesize of chunks.

### `chunk.read`

Reads all the content of the chunk and returns it as a `String`.

Unlike Ruby's IO object, this method has no arguments.

### `chunk.open(&block)`

Receives a block and calls it with an IO argument that provides read operations.

```ruby
chunk.open do |io|
  while data = io.read(100)
    # ...
  end
end
```

* `io`: a readable IO object

### `chunk.write_to(io)`

Writes entire data into an IO object.

* `io`: a writable IO object

### chunk.each\(&block\)

This method is available only for standard format buffer chunks, and to provide iteration for events in buffer chunks.

```ruby
chunk.each do |time, record|
  # ...
  # tag is available from `chunk.metadata.tag` if `chunk_key` is configured with tag
end
```

* `time`: a `Fluent::EventTime` object or an `Integer` representing Unix

  timestamp \(seconds from Epoch\)

* `record`: a `Hash` with String keys

## How to Write Tests

This section explains how to write a test suite for a custom output plugin.

### Plugin Testing Overview

To write a test suite, you need to define a class inheriting from `Test::Unit::TestCase`. The basic structure is similar to any other `Test::Unit`-based test codes.

Here is a minimum example:

```ruby
require_relative '../helper'
require 'fluent/test/driver/output'
require 'fluent/plugin/out_stdout'

class MyOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  test 'output a sample event' do
    # ...
  end
end
```

Please take notice of `Fluent::Test.setup` in the `setup` function. This function sets up a number of dummy proxies that are convenient for most testing scenarios. So, do not forget to call it!

When you write a test suite for your plugin, please try to cover the following scenarios:

1. What happens if the configuration is invalid?
2. Can the plugin transfer events to the destination?
3. Does `#write` \(or `#try_write`\) get called properly? \(for a buffered plugin\)
4. Is your `#format` method working as expected? \(for a buffered plugin\)

### How to Use Test Drivers

To make testing easy, the plugin test driver provides a dummy router, a logger and the functionality to override the system and parser configurations, etc.

The lifecycle of plugin and test driver is:

1. Instantiate plugin driver which then instantiates the plugin
2. Configure plugin
3. Register conditions to stop/break running tests
4. Run test code \(provided as a block for `d.run`\)
5. Assert results of tests by data provided from driver

Test driver calls methods for plugin lifecycle at the beginning of Step \# 4 \(i.e. `#start`\) and the end \(i.e. `#stop`, `#shutdown`, etc.\). It can be skipped by optional arguments of `#run`.

See [Testing API for Plugins](plugin-test-code.md) for details.

For:

* configuration tests, repeat steps \# 1-2
* full feature tests, repeat steps \# 1-5

### Example Test Code

The following is a more convoluted example involving test drivers. A good first step is to modify the following code according to your own specific needs.

```ruby
# test/plugin/test_out_your_own.rb

require 'test/unit'
require 'fluent/test/driver/output'
require 'fluent/test/helpers' # for event_time()

# your own plugin
require 'fluent/plugin/out_your_own'

class YourOwnOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup  # this is required to setup router and others
  end

  # default configuration for tests
  CONFIG = %[
    param1 value1
    param2 value2
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::YourOwnOutput).configure(conf)
  end

  sub_test_case 'configured with invalid configurations' do
    test 'param1 should reject too short string' do
      assert_raise Fluent::ConfigError do
        create_driver(%[
          param1 a
        ])
      end
    end

    test 'param2 is set correctly' do
      d = create_driver
      assert_equal 'value2', d.instance.param2
    end

    # ...
  end

  sub_test_case 'tests for #write' do
    test 'to test #write' do
      d = create_driver
      t = event_time("2016-06-10 19:46:32 +0900")
      d.run do
        d.feed('tag', t, { 'message' => 'this is a test message', 'amount' => 53 })
      end

      assert{ check_write_of_plugin_called_and_its_result() }
    end
  end

  sub_test_case 'tests for #format' do
    test 'to test #format' do
      d = create_driver
      t = event_time('2016-06-10 19:46:32 +0900')
      d.run do
        d.feed('tag', t, { 'message' => 'this is a test message', 'amount' => 53 })
      end

      # This returns an array i.e. the result of `#format`.
      rows = d.formatted

      assert_equal 'expected format result', rows[0]

      # Of course, you can check `#format` and `#write` at once.
      assert{ check_write_of_plugin_called_and_its_result() }
    end
  end

  # ...
end
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

