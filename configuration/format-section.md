# Format section configurations

Some of Fluentd's plugins support the `<format>` section to specify how
to format record.


## Format section overview

Format section can be in `<match>` or `<filter>` sections.

``` {.CodeRay}
<match tag.*>
  @type file
  # parameters for output plugin
  <format>
    # format section parameters
  </format>
</match>
```


## formatter plugin type

`<format>` section requires `@type` parameter to specify the type of
formatter plugin. Fluentd core bundles [some useful formatter plugins](/plugins/formatter/README.md). 3rd party plugins are also
available when installed.

``` {.CodeRay}
<format>
  @type json
</format>
```

These are the list of built-in formatter plugins.

-   [out\_file](/plugins/formatter/out_file.md)
-   [json](/plugins/formatter/json.md)
-   [ltsv](/plugins/formatter/ltsv.md)
-   [csv](/plugins/formatter/csv.md)
-   [msgpack](/plugins/formatter/msgpack.md)
-   [hash](/plugins/formatter/hash.md)
-   [single\_value](/plugins/formatter/single_value.md)

For more details, see plugins documentation.


## Parameters


### @type

`@type` key is to specify the type of formatter plugin.

``` {.CodeRay}
<format>
  @type csv
  # ...
</format>
```


### Time parameters

-   **time\_type** (enum) (optional): parse/format value according to
    this type
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
