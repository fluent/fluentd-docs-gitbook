# Extract section configurations


## Extract section overview

Extract section can be in `<match>`, `<source>`, or `<filter>` sections.
It's enabled for plugins which support extracting values from the event
record.

``` {.CodeRay}
<source>
  @type exec
  # parameters for input plugin
  <extract>
    # extract section parameters
  </extract>
</source>
```


## extract section parameter


### Extract parameters

-   **tag\_key** (string) (optional): the field name to extract tag
    -   Default: `nil`
-   **keep\_tag\_key** (bool) (optional): if true keep the field in the record after extract value
    -   Default: `false`
-   **time\_key** (string) (optional): the field name to extract time
    -   Default: `nil`
-   **keep\_time\_key** (bool) (optional): if true keep the field in the record after extract value
    -   Default: `false`


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
