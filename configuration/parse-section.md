# Parse section configurations

Some of Fluentd's plugins support the `<parse>` section to specify how
to parse raw data.


## Parse section overview

Parse section can be in `<source>`, `<match>` or `<filter>` sections.
It's enabled for plugins which support parser plugin features.

```
<source>
  @type tail
  # parameters for input plugin
  <parse>
    # parse section parameters
  </parse>
</source>
```


## parser plugin type

`<parse>` section requires `@type` parameter to specify the type of
parser plugin. Fluentd core bundles [a lot of useful parser plugins](/plugins/parser/README.md). 3rd party plugins are also available
when installed.

```
<parse>
  @type apache2
</parse>
```

For more details, see plugins documentation.


## Parameters


### @type

`@type` key is to specify the type of parser plugin.

```
<parse>
  @type regexp
  # ...
</parse>
```

These parsers are built-in by default.

-   [regexp](/plugins/parser/regexp.md)
-   [apache2](/plugins/parser/apache2.md)
-   [apache\_error](/plugins/parser/apache_error.md)
-   [nginx](/plugins/parser/nginx.md)
-   [syslog](/plugins/parser/syslog.md)
-   [csv](/plugins/parser/csv.md)
-   [tsv](/plugins/parser/tsv.md)
-   [ltsv](/plugins/parser/ltsv.md)
-   [json](/plugins/parser/json.md)
-   [multiline](/plugins/parser/multiline.md)
-   [none](/plugins/parser/none.md)


### Parse parameters

These parameters default value will be overwritten by individual parser
plugins.

-   **types** (hash) (optional): Specify types for converting field into
    other type. See below "The detail of types parameter" section.
    -   Default: `nil`
    -   string-based hash: `field1:type, field2:type, field3:type:option, field4:type:option`
    -   JSON format: `{"field1":"type", "field2":"type", "field3":"type:option", "field4":"type:option"}`
    -   example: `types user_id:integer,paid:bool,paid_usd_amount:float`
-   **time\_key** (string) (optional): Specify time field for event time. If the event doesn't have this field, current time is used.
    -   Default: `nil`
    -   Note that [json](/plugins/parser/json), [ltsv](/plugins/parser/ltsv) and [regexp](/plugins/parser/regexp) override the default value of this parameter and set it to `time` by default.
-   **null\_value\_pattern** (string) (optional): Specify null value pattern.
    -   Default: `nil`
-   **null\_empty\_string** (bool) (optional): If `true`, empty string field is replaced with `nil`.
    -   Default: `false`
-   **estimate\_current\_event** (bool) (optional): If `true`, use `Fluent::EventTime.now`(current time) as a timestamp when `time_key` is specified.
    -   Default: `false`
-   **keep\_time\_key** (bool) (optional): If `true`, keep time field in the record.
    -   Default: `false`

#### The detail of types parameter

The list of supported types are shown below:

-   string

Convert field into String type. This uses `to_s` method for conversion.

-   bool

Convert `"true"`, `"yes"` or `"1"` string into `true`. Otherwise,
`false`.

-   integer ("int" would NOT work!)

Convert field into Integer type. This uses `to_i` method for conversion.
For example, `"1000"` string is converted into `1000`.

-   float

Convert field into Float type. This uses `to_f` method for conversion.
For example, `"7.45"` string is converted into `7.45`.

-   time

Convert field into Fluent::EventTime type. This uses Fluentd's time
parser for conversion. For time type, the third field specifies a time
format you would in `time_format`.

```
date:time:%d/%b/%Y:%H:%M:%S %z # for string with time format
date:time:unixtime             # for integer time
date:time:float                # for float time
```

See `time_type` and `time_format` parameters in `Time parameters`
section.

-   array

Convert string field into Array type. For the "array" type, the third
field specifies the delimiter (the default is ","). For example, if a
field called "item\_ids" contains the value `"3,4,5"`,
`types item_ids:array` parses it as `["3", "4", "5"]`. Alternatively, if
the value is `"Adam|Alice|Bob"`, `types item_ids:array:|` parses it as
`["Adam", "Alice", "Bob"]`.


### Time parameters

-   **time\_type** (enum) (optional): parse/format value according to this type
    -   Default: `float`
    -   Available values: `float`, `unixtime`, `string`
        -   `float`: seconds from Epoch + nano seconds (e.g. 1510544836.154709804)
        -   `unixtime`: seconds from Epoch (e.g. 1510544815)
        -   `string`: use format specified by `time_format`, local time or time zone
-   **time\_format** (string) (optional): process value using specified format. This is available only when `time_type` is `string`
    -   Default: `nil`
    -   Available time format:
        -   For more details about formatting, see [Time\#strftime](https://docs.ruby-lang.org/en/2.4.0/Time.html#method-i-strftime)
        -   For more details about parsing, see [Time.strptime](https://docs.ruby-lang.org/en/2.4.0/Time.html#method-c-strptime)
        -   `%iso8601` (only for parsing)
        -    Use `%N` to parse/format subsecond, because [strptime](https://github.com/nurse/strptime) does not support `%3N`, `%6N`, `%9N`, and `%L`
-   **localtime** (bool) (optional): if true, use local time. Otherwise, UTC is used. This is exclusive with `utc`.
    -   Default: `true`
-   **utc** (bool) (optional): if true, use UTC. Otherwise, local time is used. This is exclusive with `localtime`.
    -   Default: `false`
-   **timezone** (string) (optional): use specified timezone. one can parse/format the time value in the specified timezone.
    -   Default: `nil`
    -   Available time zone format:
        1.  \[+-\]HH:MM (e.g. "+09:00") **(recommended)**
        2.  \[+-\]HHMM (e.g. "+0900")
        3.  \[+-\]HH (e.g. "+09")
        4.  Region/Zone (e.g. "Asia/Tokyo")
        5.  Region/Zone/Zone (e.g. "America/Argentina/Buenos\_Aires")


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
