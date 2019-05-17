# Compat Parameters Plugin Helper API

`compat_parameters` helper convert parameters from v0.12 style to v1.0
style.

Here is the code example with `compat_parameters` helper:

```
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. load compat_parameters helper
    helpers :compat_parameters

    # omit start, shutdown and other plugin API

    def configure(conf)
      compat_parameters_convert(conf, :buffer, :inject, default_chunk_key: "time")
      super
      ...
    end
  end
end
```


## Methods


### compat\_parameters\_convert(conf, \*types, \*\*kwargs)

-   `conf`: `Fluent::Configuration` instance
-   `types`: Following 5 types are supported
    -   `:buffer`
    -   `:inject`
    -   `:extract`
    -   `:parser`
    -   `:formatter`
-   `kwargs`:
    -   `default_chunk_key`: Set default chunk key. For more details,
        see [Buffer section configurations](/configuration/buffer-section.md)

The important point is you can't mix v1.0 and v0.12 styles in one plugin
directive. If you mix v1.0 and v0.12 styles, v1.0 style is used and
v0.12 style is ignored. Here is an example:

```
<match pattern>
  @type foo
  # This flush_interval is ignored because <buffer> exist. Conversion doesn't happen.
  flush_interval 30s
  # This <buffer> parameters are used
  <buffer>
    @type file
    path /path/to/buffer
    retry_max_times 10
    queue_limit_length 256
  </buffer>
</match>
```

#### buffer

| old (v0.12)                    | new (v1)                       | note                          |
|:-------------------------------|:-------------------------------|:------------------------------|
| buffer\_type                   | @type                          |                               |
| buffer\_path                   | path                           |                               |
| num\_threads                   | flush\_thread\_count           |                               |
| num\_threads                   | flush\_thread\_count           |                               |
| flush\_interval                | flush\_interval                |                               |
| try\_flush\_interval           | flush\_thread\_interval        |                               |
| queued\_chunk\_flush\_interval | flush\_thread\_burst\_interval |                               |
| disable\_retry\_limit          | retry\_forever                 |                               |
| retry\_limit                   | retry\_max\_times              |                               |
| max\_retry\_wait               | retry\_max\_interval           |                               |
| buffer\_chunk\_limit           | chunk\_limit\_size             |                               |
| buffer\_queue\_limit           | queue\_limit\_length           |                               |
| buffer\_queue\_full\_action    | overflow\_action               |                               |
| flush\_at\_shutdown            | flush\_at\_shutdown            |                               |
| time\_slice\_format            | timekey                        | also set chunk\_key to 'time' |
| time\_slice\_wait              | timekey\_wait                  |                               |
| timezone                       | timekey\_zone                  |                               |
| localtime                      | timekey\_use\_utc              | exclusive with utc            |
| utc                            | timekey\_use\_utc              | exclusive with localtime      |


This converts following flat configuration:

```
buffer_type file
buffer_path /path/to/buffer
retry_limit 10
flush_interval 30s
buffer_queue_limit 256
```

into:

```
<buffer>
  @type file
  path /path/to/buffer
  retry_max_times 10
  flush_interval 30s
  queue_limit_length 256
</buffer>
```

For more details, see [Buffer section configuration](/configuration/buffer-section.md)

#### inject

| old (v0.12)        | new (v1)     | note                     |
|:-------------------|:-------------|:-------------------------|
| include\_time\_key | time\_key    | if true, set time\_key   |
| time\_key          | time\_key    |                          |
| time\_format       | time\_format |                          |
| timezone           | timezone     |                          |
| include\_tag\_key  | tag\_key     | if true, set tag\_key    |
| tag\_key           | tag\_key     |                          |
| localtime          | localtime    | exclusive with utc       |
| utc                | localtime    | exclusive with localtime |

This converts following flat configuration:

```
include_time_key
time_key event_time
utc
```

into:

```
<inject>
  time_key event_time
  localtime false
</inject>
```

For more details, see [Inject Plugin Helper API](/developer/api-plugin-helper-inject.md)

#### extract

| old (v0.12) | new (v1)    | note                     |
|:------------|:------------|:-------------------------|
| time_key    | time_key    |                          |
| time_format | time_format |                          |
| timezone    | timezone    |                          |
| tag_key     | tag_key     |                          |
| localtime   | localtime   | exclusive with utc       |
| utc         | localtime   | exclusive with localtime |

This converts following flat configuration:

```
include_time_key
time_key event_time
utc
```

into:

```
<extract>
  time_key event_time
  localtime false
</extract>
```

For more details, see [Extract Plugin Helper API](/developer/api-plugin-helper-extract.md)

#### parser

| old (v0.12)             | new (v1)              | note                     | plugin                                  |
|:------------------------|:----------------------|:-------------------------|:----------------------------------------|
| format                  | @type                 |                          |                                         |
| types                   | types                 | converted to JSON format |                                         |
| types\_delimiter        | types                 |                          |                                         |
| types\_label\_delimiter | types                 |                          |                                         |
| keys                    | keys                  |                          | CSVParser, TSVParser (old ValuesParser) |
| time\_key               | time\_key             |                          |                                         |
| time\_format            | time\_format          |                          |                                         |
| localtime               | localtime             | exclusive with utc       |                                         |
| utc                     | localtime             | exclusive with localtime |                                         |
| delimiter               | delimiter             |                          |                                         |
| keep\_time\_key         | keep\_time\_key       |                          |                                         |
| null\_empty\_string     | null\_empty\_string   |                          |                                         |
| null\_value\_pattern    | null\_value\_pattern  |                          |                                         |
| json\_parser            | json\_parser          |                          | JSONParser                              |
| label\_delimiter        | label\_delimiter      |                          | LabeledTSVParser                        |
| format\_firstline       | format\_firstline     |                          | MultilineParser                         |
| message\_key            | message\_key          |                          | NoneParser                              |
| with\_priority          | with\_priority        |                          | SyslogParser                            |
| message\_format         | message\_format       |                          | SyslogParser                            |
| rfc5424\_time\_format   | rfc5424\_time\_format |                          | SyslogParser                            |

This converts following configuration:

```
format /^(?<log_time>[^ ]*) (?<message>)+*/
time_key log_time
time_format %Y%m%d%H%M%S
keep_time_key
```

into:

```
<parse>
  @type regexp
  pattern /^(?<log_time>[^ ]*) (?<message>)+*/
  time_key log_time
  time_format %Y%m%d%H%M%S
  keep_time_key
</parse>
```

For more details, see [Parser Plugin Overview](/plugins/parser/README.md)
and [Writing Parser Plugins](/developer/api-plugin-parser.md).

#### formatter

| old (v0.12)      | new (v1)         | note                     | plugin               |
|:-----------------|:-----------------|:-------------------------|:---------------------|
| format           | @type            |                          |                      |
| delimiter        | delimiter        |                          |                      |
| force\_quotes    | force\_quotes    |                          | CsvFormatter         |
| keys             | keys             |                          | TSVFormatter         |
| fields           | fields           |                          | CsvFormatter         |
| json\_parser     | json\_parser     |                          | JSONFormatter        |
| label\_delimiter | label\_delimiter |                          | LabeledTSVFormatter  |
| output\_time     | output\_time     |                          | OutFileFormatter     |
| output\_tag      | output\_tag      |                          | OutFileFormatter     |
| localtime        | localtime        | exclusive with utc       | OutFileFormatter     |
| utc              | utc              | exclusive with localtime | OutFileFormatter     |
| timezone         | timezone         |                          | OutFileFormatter     |
| message\_key     | message\_key     |                          | SingleValueFormatter |
| add\_newline     | add\_newline     |                          | SingleValueFormatter |
| output\_type     | output\_type     |                          | StdoutFormatter      |

This converts following configuration:

```
format json
```

into:

```
<format>
  @type json
</format>
```

For more details, see [Formatter Plugin Overview](/plugins/formatter/README.md) and [Writing Formatter Plugins](/developer/api-plugin-formatter.md).


## compat\_parameters used plugins

-   [Parser filter](/plugins/filter/parser.md)
-   [Exec input](/plugins/input/exec.md)
-   [HTTP input](/plugins/input/http.md)
-   [Syslog input](/plugins/input/syslog.md)
-   [Tail input](/plugins/input/tail.md)
-   [TCP input](/plugins/input/tcp.md)
-   [UDP input](/plugins/input/udp.md)
-   [Exec output](/plugins/output/exec.md)
-   [Exec filter output](/plugins/output/exec_filter.md)
-   [File output](/plugins/output/file.md)
-   [Forward output](/plugins/output/forward.md)
-   [Stdout output](/plugins/output/stdout.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
