# Writing Filter Plugins

This section shows how to write a custom filter plugin in addition to the core
[ones](/plugins/filter/README.md). The plugin filenames starting with `filter_`
prefix are registered as filter plugins.

See [Plugin Base Class API](/developer/api-plugin-base.md) for more details on
the common APIs of all the plugins.

Here is the implementation of the most basic filter that passes through all the
events as-is:

```rb
require 'fluent/plugin/filter'

module Fluent::Plugin
  class PassThruFilter < Filter
    # Register this filter as "passthru"
    Fluent::Plugin.register_filter('passthru', self)

    # config_param works like other plugins

    def configure(conf)
      super
      # Do the usual configuration here
    end

    # def start
    #   super
    #   # Override this method if anything needed as startup.
    # end

    # def shutdown
    #   # Override this method to use it to free up resources, etc.
    #   super
    # end

    def filter(tag, time, record)
      # Since our example is a pass-thru filter, it does nothing and just
      # returns the record as-is.
      # If returns nil, that records are ignored.
      record
    end
  end
end
```


## Methods

A filter plugin overrides the `filter` method.


#### `#filter(tag, time, record)`

This method implements the filtering logic.

- `tag`: is a `String`,
- `time` is a `Fluent::EventTime` or an `Integer`; and,
- `record` is a `Hash` with String keys.

The return value of this method should be a `Hash` of modified record, or `nil`.
In case of `nil`, the event will be discarded.


## Writing Tests

Fluentd filter plugin has one or some points to be tested. Others (parsing
configurations, controlling buffers, retries, flushes and many others) are
controlled by Fluentd core.

Fluentd also provides test driver for plugins. You can write tests for your own
plugins very easily:

```rb
# test/plugin/test_filter_your_own.rb

require 'test/unit'
require 'fluent/plugin/test/driver/filter'

# your own plugin
require 'fluent/plugin/filter_your_own'

class YourOwnFilterTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup # this is required to setup router and others
  end

  # default configuration for tests
  CONFIG = %[
    param1 value1
    param2 value2
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::YourOwnFilter).configure(conf)
  end

  def filter(config, messages)
    d = create_driver(config)
    d.run(default_tag: 'input.access') do
      messages.each do |message|
        d.feed(message)
      end
    end
    d.filtered_records
  end

  sub_test_case 'configured with invalid configuration' do
    test 'empty configuration' do
      assert_raise(Fluent::ConfigError) do
         create_driver('')
      end
    end

    test 'param1 should reject too short string' do
      conf = %[
        param1 a
      ]
      assert_raise(Fluent::ConfigError) do
         create_driver(conf)
      end
    end
    # ...
  end

  sub_test_case 'plugin will add some fields' do
    test 'add hostname to record' do
      conf = CONFIG
      messages = [
        { 'message' => 'This is test message' }
      ]
      expected = [
        { 'message' => 'This is test message', 'hostname' => 'example.com' }
      ]
      filtered_records = filter(conf, messages)
      assert_equal(expected, filtered_records)
    end
    # ...
  end
  # ...
end
```


### Overview of Tests

Testing for the filter plugins is mainly for:

-   Validation of configuration parameters (i.e. `#configure`)
-   Validation of the filtered records

To make testing easy, the plugin test driver provides a dummy router, a logger
and general functionality to override the system, parser and other relevant
configurations.

The lifecycle of the plugin and its test driver is:

1.  Instantiate the test driver which then instantiates the plugin
2.  Configure plugin
3.  Register conditions to stop/break running tests
4.  Run test code (provided as a block for `d.run`)
5.  Assert results of tests using data provided by the driver

At the start of Step # 4, the test driver calls the startup methods of the
plugin e.g. `#start` and at the end `#stop`, `#shutdown`, etc. It can be skipped
by optional arguments of `#run`.

For:

- configuration tests, repeat steps # 1-2
- full feature tests, repeat steps # 1-5

For more details, see [Testing API for Plugins](/developer/plugin-test-code.md).


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under
[Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are
available under the Apache 2 License.
