# How to Write Parser Plugin

Fluentd supports [pluggable and customizable formats for input plugins](../parser/). The plugin filenames prefixed `parser_` are registered as Parser Plugins.

See [Plugin Base Class API](api-plugin-base.md) for details on the common APIs for all the plugin types.

Here is an example of a custom parser that parses the following newline-delimited log format:

```text
<timestamp><SPACE>key1=value1<DELIMITER>key2=value2<DELIMITER>key3=value...
```

like this:

```text
2014-04-01T00:00:00 name=jake age=100 action=debugging
```

While it is not hard to write a regular expression to match this format, it is tricky to extract and save key names.

Here is the code to parse this custom format \(let's call it `time_key_value`\). It takes one optional parameter called `delimiter`, which is the delimiter for key/value pairs. It also takes `time_format` to parse the `time` string.

```ruby
require 'fluent/plugin/parser'

module Fluent::Plugin
  class TimeKeyValueParser < Parser
    # Register this parser as 'time_key_value'
    Fluent::Plugin.register_parser('time_key_value', self)

    # `delimiter` is configurable with ' ' as default
    config_param :delimiter, :string, default: ' '

    # `time_format` is configurable
    config_param :time_format, :string, default: nil

    def configure(conf)
      super

      if @delimiter.length != 1
        raise ConfigError, "delimiter must be a single character. #{@delimiter} is not."
      end

      # `TimeParser` class is already available.
      # It takes a single argument as the time format
      # to parse the time string with.
      @time_parser = Fluent::TimeParser.new(@time_format)
    end

    def parse(text)
      time, key_values = text.split(' ', 2)
      time = @time_parser.parse(time)
      record = {}
      key_values.split(@delimiter).each do |kv|
        k, v = kv.split('=', 2)
        record[k] = v
      end
      yield time, record
    end
  end
end
```

Save this code as `parser_time_key_value.rb` in a loadable plugin path.

With `in_tail` configured as:

```text
# Other lines...
<source>
  @type tail
  path /path/to/input/file
  <parse>
    @type time_key_value
  </parse>
</source>
```

this log line:

```text
2014-01-01T00:00:00 k=v a=b
```

will be parsed as:

```text
2014-01-01 00:00:00 +0000 test: {"k":"v","a":"b"}
```

For more details on `<parse>`, see [Parse Section Configurations](../configuration/parse-section.md).

## How To Use Parsers From Plugins

Parser plugins are designed to be used with other plugins, like Input, Filter and Output. There is a Parser plugin helper solely for this purpose:

```ruby
# in class definition
helpers :parser

# in #configure
@parser = parser_create(type: 'json')

# in input loop or #filter or ...
@parser.parse do |time, record|
  # ...
end
```

See [Parser Plugin Helper API](../plugin-helper-overview/api-plugin-helper-parser.md) for details.

## Methods

Parser plugins have a method to parse input \(text\) data to a structured record \(`Hash`\) with time.

#### `#parse(text, &block)`

It gets input data as `text`, and call `&block` to feed the results of the parser. The input `text` may contain two or more records so that means the parser plugin might call the `&block` two or more times for one argument.

Parser plugins must implement this method.

## Writing Tests

Fluentd parser plugin has one or more points to be tested. Others \(parsing configurations, controlling buffers, retries, flushes, etc.\) are controlled by the Fluentd core.

Fluentd also provides the test driver for plugins. You can easily write tests for your own plugins:

```ruby
# test/plugin/test_parser_your_own.rb

require 'test/unit'
require 'fluent/test/driver/parser'

# Your own plugin
require 'fluent/plugin/parser_your_own'

class ParserYourOwnTest < Test::Unit::TestCase
  def setup
    # Common setup
  end

  CONFIG = %[
    pattern apache
  ]

  def create_driver(conf = CONF)
    Fluent::Test::Driver::Parser.new(Fluent::Plugin::YourOwnParser).configure(conf)
  end

  sub_test_case 'configured with invalid configurations' do
    test 'empty' do
      assert_raise(Fluent::ConfigError) do
        create_driver('')
      end
    end
    # ...
  end

  sub_test_case 'plugin will parse text' do
    test 'record has a field' do
      d = create_driver(CONFIG)
      text = '192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777'
      expected_time = event_time('28/Feb/2013:12:00:00 +0900', format: '%d/%b/%Y:%H:%M:%S %z')
      expected_record = {
        'method' => 'GET',
        # ...
      }
      d.instance.parse(text) do |time, record|
        assert_equal(expected_time, time)
        assert_equal(expected_record, record)
      end
    end
  end
end
```

### Overview of Tests

Testing for parser plugins is mainly for:

* Validation of configuration \(i.e. `#configure`\)
* Validation of the parsed time and record

To make testing easy, the plugin test driver provides a logger and the functionality to override the system and parser configurations, etc.

The lifecycle of plugin and test driver is:

1. Instantiate plugin driver which then instantiates the plugin
2. Configure plugin
3. Run test code
4. Assert results of tests by data provided by the driver

For:

* configuration tests, repeat steps \# 1-2
* full feature tests, repeat steps \# 1-4

See [Testing API for Plugins](plugin-test-code.md) for details.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

