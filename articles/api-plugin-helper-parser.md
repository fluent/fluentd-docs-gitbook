# Parser Plugin Helper API

`parser` helper manages parser plugin life cycle.

Here is the code example with `parser` helper:

``` {.CodeRay}
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_input('example', self)

    # 1. load parser helper
    helpers :parser

    # omit shutdown and other plugin API

    def configure(conf)
      super

      # 2. Create parser plugin instance
      @parser = parser_create
    end

    def start
      super

      # use parser helper in combination with other plugin helpers usually
      timer_execute(:example_timer, 10) do
        read_raw_data do |text|
          # 3. call @parser.parse(text) to parse raw data
          @parser.parse(text) do |time, record|
            router.emit(tag, time, record)
          end
        end
      end
    end
  end
end
```

For more details about parser plugin, see following articles:

-   [Parser Plugin Overview](/plugins/parser/parser-plugin-overview.md)
-   [Writing Parser Plugins](/articles/api-plugin-parser.md)
-   [Parser plugin](/configuration/parse-section.md)


## Methods


### parser\_create(usage: "", type: nil, conf: nil, default\_type: nil)

This method creates parser plugin instance with given parameters.

-   `usage`: unique name. This is required when multiple parsers are
    used in the plugin
-   `type`: parser type
-   `conf`: parser plugin configuration
-   `default_type`: default parser type

Code examples:

``` {.CodeRay}
# Create parser plugin instance using <parse> section in fluent.conf during configure phase
@parser = parser_create
@parser.parse(text) do |time, record|
  ...
end

# Create JSON parser
@json_parser = parser_create(usage: 'parser_in_example_json', type: 'json')
@json_parser.parse(json) do |time, record|
  ...
end

# Create MessagePack paser
@msgpack_parser = parser_create(usage: 'parser_in_example_msgpack', type: 'msgpack')
@msgpack_parser.parse(msgpack_binary) do |time, record|
   ...
end
```


## parser used plugins

-   [Parser filter](/plugins/filter/filter_parser.md)
-   [Exec input](/plugins/input/in_exec.md)
-   [HTTP input](/plugins/input/in_http.md)
-   [Syslog input](/plugins/input/in_syslog.md)
-   [Tail input](/plugins/input/in_tail.md)
-   [TCP input](/plugins/input/in_tcp.md)
-   [UDP input](/plugins/input/in_udp.md)
-   [Exec filter output](/plugins/output/out_exec_filter.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
