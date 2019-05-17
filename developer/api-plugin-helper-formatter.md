# Formatter Plugin Helper API

`formatter` helper manages formatter plugin life cycle.

Here is the code example with `formatter` helper:

```
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. load formatter helper
    helpers :formatter

    # omit shutdown and other plugin API

    def configure(conf)
      super

      # 2. call `formatter_create` to create object
      @formatter = formatter_create(usage: "awesome_formatter")
    end

    def format(tag, time, record)
      # 3. call `format` method to format record
      @formatter.format(tag, time, record)
    end
  end
end
```

For more details about formatter plugin, see following articles:

-   [Formatter Plugin Overview](/plugins/formatter/README.md)
-   [Writing Formatter Plugins](/developer/api-plugin-formatter.md)
-   [Format section](/configuration/format-section.md)


## Methods


### formatter\_create(usage: "", type: nil, conf: nil, default\_type: nil)

-   `usage`: unique name. This is required when multiple formatters are
    used in the plugin
-   `type`: formatter type
-   `conf`: formatter plugin configuration
-   `default_type`: default formatter type

Code examples:

```
def configure(conf)
  super
  # Create formatter plugin instance using <format> section in fluent.conf during configure phase
  @formatter = formatter_create
end

def format(tag, time, record)
  @formatter.format(tag, time, record)
end
```

JSON formatter example:

```
# Create JSON formatter
def configure(conf)
  super
  @json_formatter = formatter_create(usage: 'formatter_in_example_json', type: 'json')
end

def format(tag, time, record)
  @json_formatter.format(tag, time, record)
end
```

Msgpack formatter example:

```
# Create Msgpack formatter
def configure(conf)
  super
  @msgpack_formatter = formatter_create(usage: 'formatter_in_example_msgpack', type: 'msgpack')
end

def format(tag, time, record)
  @msgpack_formatter.format(tag, time, record)
end
```


## formatter used plugins

-   [Filter stdout](/plugins/filter/stdout.md)
-   [Out stdout](/plugins/output/stdout.md)
-   [Out exec](/plugins/output/exec.md)
-   [Out exec filter](/plugins/output/exec_filter.md)
-   [Out file](/plugins/output/file.md)
-   [Out s3](/plugins/output/s3.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
