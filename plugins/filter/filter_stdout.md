# stdout Filter Plugin

The `filter_stdout` filter plugin prints events to stdout (or logs if
launched with daemon mode). This filter plugin is useful for debugging
purposes.


## Example Configurations

`filter_stdout` is included in Fluentd's core. No installation required.

``` {.CodeRay}
<filter pattern>
  @type stdout
</filter>
```

A sample output is as follows:

``` {.CodeRay}
2015-05-02 12:12:17 +0900 tag: {"field1":"value1","field2":"value2"}
```

where the first part shows the output time, the second part shows the
tag, and the third part shows the record.
The first part shows the \*\*output\*\* time, not the time attribute of
message event structure as \`out\_stdout\` does.

## Parameters

#### type (required)

The value must be `stdout`.

#### format

The format of the output. The default is `stdout`.

#### output\_type

This is the option of `stdout` format. Configure the format of record
(third part). Any formatter plugins can be specified. The default is
`json`.

#### out\_file

Output time, tag and json record separated by a delimiter:

``` {.CodeRay}
time[delimiter]tag[delimiter]record\n
```

Example:

``` {.CodeRay}
2014-06-08T23:59:40[TAB]file.server.logs[TAB]{"field1":"value1","field2":"value2"}\n
```

`out_file` format has several options to customize the format.

``` {.CodeRay}
delimiter SPACE   # Optional, SPACE or COMMA. "\t"(TAB) is used by default
output_tag false  # Optional, defaults to true. Output the tag field if true.
output_time true  # Optional, defaults to true. Output the time field if true.
```

For this format, the following common parameters are also supported.

-   **include\_time\_key** (Boolean, Optional, defaults to false) If
    true, the time field (as specified by the `time_key` parameter) is
    kept in the record.
-   **time\_key** (String, Optional, defaults to "time") The field name
    for the time key.
-   **time\_format** (String. Optional) By default, the output format is
    iso8601 (e.g. "2008-02-01T21:41:49"). One can specify their own
    format with this parameter.
-   **include\_tag\_key** (Boolean. Optional, defaults to false) If
    true, the tag field (as specified by the `tag_key` parameter) is
    kept in the record.
-   **tag\_key** (String, Optional, defaults to "tag") The field name
    for the tag key.
-   **localtime** (Boolean. Optional, defaults to true) If true, use
    local time. Otherwise, UTC is used. This parameter is overwritten by
    the `utc` parameter.
-   **timezone** (String. Optional) By setting this parameter, one can
    parse the time value in the specified timezone. The following
    formats are accepted:

    1.  \[+-\]HH:MM (e.g. "+09:00")
    2.  \[+-\]HHMM (e.g. "+0900")
    3.  \[+-\]HH (e.g. "+09")
    4.  Region/Zone (e.g. "Asia/Tokyo")
    5.  Region/Zone/Zone (e.g. "America/Argentina/Buenos\_Aires")

    **The timezone set in this parameter takes precedence over
    `localtime`**, e.g., if `localtime` is set to `true` but `timezone`
    is set to `+0000`, UTC would be used.

#### json

Output a json record without the time or tag field:

``` {.CodeRay}
{"field1":"value1","field2":"value2"}\n
```

For this format, the following common parameters are also supported.

-   **include\_time\_key** (Boolean, Optional, defaults to false) If
    true, the time field (as specified by the `time_key` parameter) is
    kept in the record.
-   **time\_key** (String, Optional, defaults to "time") The field name
    for the time key.
-   **time\_format** (String. Optional) By default, the output format is
    iso8601 (e.g. "2008-02-01T21:41:49"). One can specify their own
    format with this parameter.
-   **include\_tag\_key** (Boolean. Optional, defaults to false) If
    true, the tag field (as specified by the `tag_key` parameter) is
    kept in the record.
-   **tag\_key** (String, Optional, defaults to "tag") The field name
    for the tag key.
-   **localtime** (Boolean. Optional, defaults to true) If true, use
    local time. Otherwise, UTC is used. This parameter is overwritten by
    the `utc` parameter.
-   **timezone** (String. Optional) By setting this parameter, one can
    parse the time value in the specified timezone. The following
    formats are accepted:

    1.  \[+-\]HH:MM (e.g. "+09:00")
    2.  \[+-\]HHMM (e.g. "+0900")
    3.  \[+-\]HH (e.g. "+09")
    4.  Region/Zone (e.g. "Asia/Tokyo")
    5.  Region/Zone/Zone (e.g. "America/Argentina/Buenos\_Aires")

    **The timezone set in this parameter takes precedence over
    `localtime`**, e.g., if `localtime` is set to `true` but `timezone`
    is set to `+0000`, UTC would be used.

#### hash

Output a record as ruby hash without the time or tag field:

``` {.CodeRay}
{"field1"=>"value1","field2"=>"value2"}\n
```

For this format, the following common parameters are also supported.

-   **include\_time\_key** (Boolean, Optional, defaults to false) If
    true, the time field (as specified by the `time_key` parameter) is
    kept in the record.
-   **time\_key** (String, Optional, defaults to "time") The field name
    for the time key.
-   **time\_format** (String. Optional) By default, the output format is
    iso8601 (e.g. "2008-02-01T21:41:49"). One can specify their own
    format with this parameter.
-   **include\_tag\_key** (Boolean. Optional, defaults to false) If
    true, the tag field (as specified by the `tag_key` parameter) is
    kept in the record.
-   **tag\_key** (String, Optional, defaults to "tag") The field name
    for the tag key.
-   **localtime** (Boolean. Optional, defaults to true) If true, use
    local time. Otherwise, UTC is used. This parameter is overwritten by
    the `utc` parameter.
-   **timezone** (String. Optional) By setting this parameter, one can
    parse the time value in the specified timezone. The following
    formats are accepted:

    1.  \[+-\]HH:MM (e.g. "+09:00")
    2.  \[+-\]HHMM (e.g. "+0900")
    3.  \[+-\]HH (e.g. "+09")
    4.  Region/Zone (e.g. "Asia/Tokyo")
    5.  Region/Zone/Zone (e.g. "America/Argentina/Buenos\_Aires")

    **The timezone set in this parameter takes precedence over
    `localtime`**, e.g., if `localtime` is set to `true` but `timezone`
    is set to `+0000`, UTC would be used.

#### ltsv

Output the record as [LTSV](http://ltsv.org):

``` {.CodeRay}
field1[label_delimiter]value1[delimiter]field2[label_delimiter]value2\n
```

`ltsv` format supports `delimiter` and `label_delimiter` options.

``` {.CodeRay}
format ltsv
delimiter SPACE   # Optional. "\t"(TAB) is used by default
label_delimiter = # Optional. ":" is used by default
```

For this format, the following common parameters are also supported.

-   **include\_time\_key** (Boolean, Optional, defaults to false) If
    true, the time field (as specified by the `time_key` parameter) is
    kept in the record.
-   **time\_key** (String, Optional, defaults to "time") The field name
    for the time key.
-   **time\_format** (String. Optional) By default, the output format is
    iso8601 (e.g. "2008-02-01T21:41:49"). One can specify their own
    format with this parameter.
-   **include\_tag\_key** (Boolean. Optional, defaults to false) If
    true, the tag field (as specified by the `tag_key` parameter) is
    kept in the record.
-   **tag\_key** (String, Optional, defaults to "tag") The field name
    for the tag key.
-   **localtime** (Boolean. Optional, defaults to true) If true, use
    local time. Otherwise, UTC is used. This parameter is overwritten by
    the `utc` parameter.
-   **timezone** (String. Optional) By setting this parameter, one can
    parse the time value in the specified timezone. The following
    formats are accepted:

    1.  \[+-\]HH:MM (e.g. "+09:00")
    2.  \[+-\]HHMM (e.g. "+0900")
    3.  \[+-\]HH (e.g. "+09")
    4.  Region/Zone (e.g. "Asia/Tokyo")
    5.  Region/Zone/Zone (e.g. "America/Argentina/Buenos\_Aires")

    **The timezone set in this parameter takes precedence over
    `localtime`**, e.g., if `localtime` is set to `true` but `timezone`
    is set to `+0000`, UTC would be used.

#### single\_value

Output the value of a single field instead of the whole record. Often
used in conjunction with [in\_tail](/plugins/input/in_tail.md)'s `format none`.

``` {.CodeRay}
value1\n
```

`single_value` format supports the `add_newline` and `message_key`
options.

``` {.CodeRay}
add_newline false # Optional, defaults to true. If there is a trailing "\n" already, set it "false"
message_key my_field # Optional, defaults to "message". The value of this field is outputted.
```

#### csv

Output the record as CSV/TSV:

``` {.CodeRay}
"value1"[delimiter]"value2"[delimiter]"value3"\n
```

`csv` format supports the `delimiter` and `force_quotes` options.

``` {.CodeRay}
format csv
fields field1,field2,field3
delimiter \t   # Optional. "," is used by default.
force_quotes false # Optional. true is used by default. If false, value won't be framed by quotes.
```

For this format, the following common parameters are also supported.

-   **include\_time\_key** (Boolean, Optional, defaults to false) If
    true, the time field (as specified by the `time_key` parameter) is
    kept in the record.
-   **time\_key** (String, Optional, defaults to "time") The field name
    for the time key.
-   **time\_format** (String. Optional) By default, the output format is
    iso8601 (e.g. "2008-02-01T21:41:49"). One can specify their own
    format with this parameter.
-   **include\_tag\_key** (Boolean. Optional, defaults to false) If
    true, the tag field (as specified by the `tag_key` parameter) is
    kept in the record.
-   **tag\_key** (String, Optional, defaults to "tag") The field name
    for the tag key.
-   **localtime** (Boolean. Optional, defaults to true) If true, use
    local time. Otherwise, UTC is used. This parameter is overwritten by
    the `utc` parameter.
-   **timezone** (String. Optional) By setting this parameter, one can
    parse the time value in the specified timezone. The following
    formats are accepted:

    1.  \[+-\]HH:MM (e.g. "+09:00")
    2.  \[+-\]HHMM (e.g. "+0900")
    3.  \[+-\]HH (e.g. "+09")
    4.  Region/Zone (e.g. "Asia/Tokyo")
    5.  Region/Zone/Zone (e.g. "America/Argentina/Buenos\_Aires")

    **The timezone set in this parameter takes precedence over
    `localtime`**, e.g., if `localtime` is set to `true` but `timezone`
    is set to `+0000`, UTC would be used.

#### stdout

This format is aimed to be used by stdout plugins.

Output time, tag and formatted record as follows:

``` {.CodeRay}
time tag: formatted_record\n
```

Example:

``` {.CodeRay}
2015-05-02 12:12:17 +0900 tag: {"field1":"value1","field2":"value2"}\n
```

`stdout` format has a following option to customize the format of the
record part.

``` {.CodeRay}
output_type format # Optional, defaults to "json". The format of
`formatted_record`. Any formatter plugins can be specified.
```

For this format, the following common parameters are also supported.

-   **include\_time\_key** (Boolean, Optional, defaults to false) If
    true, the time field (as specified by the `time_key` parameter) is
    kept in the record.
-   **time\_key** (String, Optional, defaults to "time") The field name
    for the time key.
-   **time\_format** (String. Optional) By default, the output format is
    iso8601 (e.g. "2008-02-01T21:41:49"). One can specify their own
    format with this parameter.
-   **include\_tag\_key** (Boolean. Optional, defaults to false) If
    true, the tag field (as specified by the `tag_key` parameter) is
    kept in the record.
-   **tag\_key** (String, Optional, defaults to "tag") The field name
    for the tag key.
-   **localtime** (Boolean. Optional, defaults to true) If true, use
    local time. Otherwise, UTC is used. This parameter is overwritten by
    the `utc` parameter.
-   **timezone** (String. Optional) By setting this parameter, one can
    parse the time value in the specified timezone. The following
    formats are accepted:

    1.  \[+-\]HH:MM (e.g. "+09:00")
    2.  \[+-\]HHMM (e.g. "+0900")
    3.  \[+-\]HH (e.g. "+09")
    4.  Region/Zone (e.g. "Asia/Tokyo")
    5.  Region/Zone/Zone (e.g. "America/Argentina/Buenos\_Aires")

    **The timezone set in this parameter takes precedence over
    `localtime`**, e.g., if `localtime` is set to `true` but `timezone`
    is set to `+0000`, UTC would be used.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.

## Learn More

-   [Filter Plugin Overview](/plugins/filter/filter-plugin-overview.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
