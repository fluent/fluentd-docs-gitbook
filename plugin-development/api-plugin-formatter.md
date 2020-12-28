# How to Write Formatter Plugin

Fluentd supports [pluggable, customizable formats](../formatter/) for output plugins. The plugin filenames starting with `formatter_` are registered as Formatter Plugins.

See [Plugin Base Class API](api-plugin-base.md) for more details on the common APIs of all the plugins.

Following is an example of a custom formatter \(`formatter_my_csv.rb`\) that outputs events in CSV format. It takes a required parameter called `csv_fields` and outputs the fields. It assumes that the values of the fields are valid CSV fields.

```ruby
require 'fluent/plugin/formatter'

module Fluent::Plugin
  class MyCSVFormatter < Formatter
    # Register MyCSVFormatter as 'my_csv'.
    Fluent::Plugin.register_formatter('my_csv', self)

    config_param :csv_fields, :array, value_type: :string

    # This method does further processing. Configuration parameters can be
    # accessed either via `conf` hash or member variables.
    def configure(conf)
      super
    end

    # This is the method that formats the data output.
    def format(tag, time, record)
      values = []

      # Look up each required field and collect them from the record
      @csv_fields.each do |field|
        v = record[field]
        unless v
          log.error "#{field} is missing."
        end
        values << v.to_s
      end

      # Output by joining the fields with a comma
      values.join(',')
    end
  end
end
```

Save this as `formatter_my_csv.rb` in a loadable plugin path.

With `out_file` output plugin:

```text
# ...

<match test>
  @type file
  path /path/to/output/file
  <format>
    @type my_csv
    csv_fields k1,k2
  </format>
</match>
```

For a matched record e.g. `{"k1": 100, "k2": 200}`, the output CSV file would look like this:

```text
100,200
```

## How To Use Formatters From Plugins

Formatter plugins are designed to be used from other plugins, like Input, Filter and Output. Formatter plugin helper helps achieve this:

```ruby
# in class definition
helpers :formatter

# in #configure
@formatter = formatter_create(type: 'json')

# in #filter, #format or ...
es.each do |time, record|
  row = @formatter.format(@tag, time, record)
  # ...
end
```

See [Formatter Plugin Helper API](../plugin-helper-overview/api-plugin-helper-formatter.md) for details.

## Methods

The formatter plugins implement `filter` method to format the input `Hash` record as a `String` object.

#### `#format(tag, time, record)`

It receives an event represented by `tag`, `time` and `record`; and, after formatting returns a `String` object.

Formatter plugins must implement this method.

## Writing Tests

Fluentd formatter plugin has one or more points to be tested. Others \(parsing configurations, controlling buffers, retries, flushes and many others\) are controlled by the Fluentd core.

Fluentd also provides test driver for plugins. You can write tests for your own plugins very easily:

```ruby
# test/plugin/test_formatter_your_own.rb

require 'test/unit'
require 'fluent/test/driver/formatter'

# your own plugin
require 'fluent/plugin/formatter_your_own'

class FormatterYourOwnTest < Test::Unit::TestCase
  def setup
    # common setup
  end

  CONFIG = %[
    fields a,b,c
  ]

  def create_driver(conf = CONF)
    Fluent::Test::Driver::Formatter.new(Fluent::Plugin::YourOwnFormatter).configure(conf)
  end

  sub_test_case 'configured with invalid configurations' do
    test 'empty' do
      assert_raise(Fluent::ConfigError) do
        create_driver('')
      end
    end
    # ...
  end

  sub_test_case 'plugin will format record' do
    test 'record has a field' do
      d = create_driver(CONFIG)
      tag = 'test'
      time = event_time
      record = { 'message' => 'This is message' }
      formatted = d.instance.format(tag, time, record)
      expected = '...'
      assert_equal(expected, formatted)
    end
  end
end
```

### Overview of Tests

Testing for formatter plugins is mainly for:

* Validation of configuration parameters \(i.e. `#configure`\)
* Validation of the formatted records

To make testing easy, the plugin test driver provides a logger and the functionality to override the system, parser and other configurations.

The lifecycle of the plugin and its test driver is:

1. Instantiate plugin driver which then instantiates the plugin
2. Configure plugin
3. Run test code
4. Assert results of tests by data provided by the driver

For:

* configuration tests, repeat steps \# 1-2
* full feature tests, repeat step \# 1-4

For more details, see [Testing API for Plugins](plugin-test-code.md).

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

