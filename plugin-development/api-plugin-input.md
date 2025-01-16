# How to Write Input Plugin

Extend `Fluent::Plugin::Input` class and implement its methods.

See [Plugin Base Class API](api-plugin-base.md) for details on the common APIs for all plugin types.

In most cases, input plugins start timers, threads, or network servers to listen on ports in `#start` method and then call `router.emit` in the callbacks of timers, threads or network servers to emit events.

Example:

```ruby
require 'fluent/plugin/input'

module Fluent::Plugin
  class SomeInput < Input
    # First, register the plugin. 'NAME' is the name of this plugin
    # and identifies the plugin in the configuration file.
    Fluent::Plugin.register_input('NAME', self)

    # `config_param` defines a parameter.
    # You can refer to a parameter like an instance variable e.g. @port.
    # `:default` means that the parameter is optional.
    config_param :port, :integer, default: 8888

    # `configure` is called before `start`.
    # 'conf' is a `Hash` that includes the configuration parameters.
    # If the configuration is invalid, raise `Fluent::ConfigError`.
    def configure(conf)
      super

      # The configured 'port' is referred by `@port` or instance method `#port`.
      if @port < 1024
        raise Fluent::ConfigError, "well-known ports cannot be used."
      end

      # You can also refer to raw parameter via `conf[name]`.
      @port = conf['port']
      # ...
    end

    # `start` is called when starting and after `configure` is successfully completed.
    # Open sockets or files and create threads here.
    def start
      super

      # Startup code goes here!
    end

    # `shutdown` is called while closing down.
    def shutdown
      # Shutdown code goes here!

      super
    end
  end
end
```

To submit events, use `router.emit(tag, time, record)` method, where:

* `tag` is a `String`,
* `time` is the `Fluent::EventTime` or `Integer` as Unix time; and,
* `record` is a `Hash` object.

Example:

```ruby
tag = "myapp.access"
time = Fluent::Engine.now
record = {"message"=>"body"}
router.emit(tag, time, record)
```

To submit multiple events, use `router.emit_stream(tag, es)` method, where:

* `tag` is a `String`; and,
* `es` is a `MultiEventStream` object.

Example:

```ruby
es = MultiEventStream.new
records.each do |record|
  es.add(time, record)
end
router.emit_stream(tag, es)
```

### Record Format

Fluentd plugins assume the record is in JSON format so the key should be the `String`, not `Symbol`. If you emit a record with a key as `Symbol`, it may cause a problem.

Example:

```ruby
# Good
router.emit(tag, time, {'foo' => 'bar'})

# Bad
router.emit(tag, time, {:foo => 'bar'})
```

## Methods

### zero_downtime_restart_ready?

To support [Zero-downtime restart](../deployment/zero-downtime-restart.md), you can override this method to return `true`.

```ruby
def zero_downtime_restart_ready?
  true
end
```

To do this, the following condition must be met:

* This plugin can run in parallel with another Fluentd.

This is because there is a period when the old process and the new process run in parallel during a zero-downtime restart.

After addressing the following considerations and ensuring there are no issues, override this method.
Then, the plugin will succeed with zero-downtime restart.

* Handling Files
  * When handling files, there is a possibility of conflict.
  * Basically, input plugins that handle files should not support Zero-downtime restart.
* Handling Sockets
  * A socket provided as a shared socket by [server plugin helper](../plugin-helper-overview/api-plugin-helper-server.md) is shared between the old and new processes. So, such a plugin can support Zero-downtime restart.
  * When handling sockets on your own, be careful to avoid conflicts.

## Writing Tests

Fluentd input plugin has one or more points to be tested. Others aspects \(parsing configurations, controlling buffers, retries, flushes, etc.\) are controlled by the Fluentd core.

Fluentd also provides the test drivers for plugins. You can write tests for your own plugins very easily:

```ruby
# test/plugin/test_in_your_own.rb

require 'test/unit'
require 'fluent/test'
require 'fluent/test/driver/input'

# Your own plugin
require 'fluent/plugin/in_your_own'

class YourOwnInputTest < Test::Unit::TestCase
  def setup
    # This line is required to set up router, and other required components.
    Fluent::Test.setup
  end

  # Default configuration for tests
  CONFIG = %[
    param1 value1
    param2 value2
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::YourOwnInput).configure(conf)
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

  sub_test_case 'plugin will emit some events' do
    test 'test expects plugin emits events 4 times' do
      d = create_driver

      # This method blocks until the input plugin emits events 4 times
      # or 10 seconds lapse.
      d.run(expect_emits: 4, timeout: 10)

      # An array of `[tag, time, record]`
      events = d.events

      assert_equal 'expected_tag', events[0][0]
      # ...
    end
  end
  # ...
end
```

### Overview of Tests

Testing for input plugins is mainly for:

* Validation of configuration \(i.e. `#configure`\)
* Validation of the emitted events

To make testing easy, the test driver provides a dummy router, a logger and the functionality to override system and parser configurations, etc.

The lifecycle of plugin and test driver is:

1. Instantiate plugin driver which then instantiates the plugin
2. Configure plugin
3. Register conditions to stop/break running tests
4. Run test code \(provided as a block for `d.run`\)
5. Assert results of tests by data provided by the driver

Test driver calls methods for plugin lifecycle at the beginning of Step \# 4 \(i.e. `#start`\) and at the end \(i.e. `#stop`, `#shutdown`, etc.\). It can be skipped by optional arguments of `#run`.

See [Testing API for Plugins](plugin-test-code.md) for details.

For:

* configuration tests, repeat steps \# 1-2
* full feature tests, repeat steps \# 1-5

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

