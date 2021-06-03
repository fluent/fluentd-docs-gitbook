# Plugin Helper: Parser

The `parser` plugin helper manages the lifecycle of the parser plugin.

Here is an example:

```ruby
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_input('example', self)

    # 1. Load parser helper
    helpers :parser

    # Omit `shutdown` and other plugin APIs

    def configure(conf)
      super

      # 2. Create parser plugin instance
      @parser = parser_create
    end

    def start
      super

      # Use parser helper in combination usually with other plugin helpers
      timer_execute(:example_timer, 10) do
        read_raw_data do |text|
          # 3. Call `@parser.parse(text)` to parse raw data
          @parser.parse(text) do |time, record|
            router.emit(tag, time, record)
          end
        end
      end
    end
  end
end
```

For more details, see the following articles:

* [Parser Plugin Overview](../parser/)
* [Writing Parser Plugins](../plugin-development/api-plugin-parser.md)
* [Parser Plugin](../configuration/parse-section.md)

## Methods

### `parser_create(usage: "", type: nil, conf: nil, default_type: nil)`

This method creates a parser plugin instance with the given parameters.

* `usage`: unique name required for multiple parsers
* `type`: parser type
* `conf`: parser plugin configuration
* `default_type`: default parser type

**Examples**

```ruby
# Create parser plugin instance using <parse> section in fluent.conf during configure phase
@parser = parser_create
@parser.parse(text) do |time, record|
  # ...
end

# Create JSON parser
@json_parser = parser_create(usage: 'parser_in_example_json', type: 'json')
@json_parser.parse(json) do |time, record|
  # ...
end

# Create MessagePack parser
@msgpack_parser = parser_create(usage: 'parser_in_example_msgpack', type: 'msgpack')
@msgpack_parser.parse(msgpack_binary) do |time, record|
  # ...
end
```

## Plugins using `parser`

* [`filter_parser`](../filter/parser.md)
* [`in_exec`](../input/exec.md)
* [`in_http`](../input/http.md)
* [`in_syslog`](../input/syslog.md)
* [`in_tail`](../input/tail.md)
* [`in_tcp`](../input/tcp.md)
* [`in_udp`](../input/udp.md)
* [`out_exec_filter`](../output/exec_filter.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

