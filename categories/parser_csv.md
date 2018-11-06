::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/parser_csv) \| ***v0.12*
(td-agent2) **
:::
:::

------------------------------------------------------------------------

CSV Parser Plugin
=================

The `csv` parser plugin parses CSV format.

This plugin uses
[CSV.parse\_line](http://ruby-doc.org/stdlib-2.4.1/libdoc/csv/rdoc/CSV.html#method-c-parse_line)
method.


### Table of Contents

[Parameters](#parameters)

-   [time\_key](#time_key)
-   [time\_format](#time_format)
-   [null\_value\_pattern](#null_value_pattern)
-   [null\_empty\_string](#null_empty_string)
-   [types](#types)

[Example](#example)
:::

Parameters
----------

[]{#time_key}

### time\_key

Specify time field for event time. Default is `nil`.

If there is no time field in the record, this parser uses current time
as an event time.

[]{#time_format}

### time\_format

If time field value is formatted string, e.g. "28/Feb/2013:12:00:00
+0900", you need to specify this parameter to parse it.

Default is `nil` and it uses `Time.parse` method to parse the field.

See
[Time\#strptime](http://ruby-doc.org/stdlib-2.4.1/libdoc/time/rdoc/Time.html#method-c-strptime)
for additional format information.

[]{#null_value_pattern}

### null\_value\_pattern

Specify null value pattern. Default is `nil`.

If given field value is matched with this pattern, the field value is
replaced with `nil`.

[]{#null_empty_string}

### null\_empty\_string

If `true`, empty string field is replaced with `nil`. Default is
`false`.

[]{#types}

### types

Although every parsed field has type `string` by default, you can
specify other types. This is useful when filtering particular fields
numerically or storing data with sensible type information.

The syntax is

``` {.CodeRay}
types <field_name_1>:<type_name_1>,<field_name_2>:<type_name_2>,...
```

e.g.,

``` {.CodeRay}
types user_id:integer,paid:bool,paid_usd_amount:float
```

As demonstrated above, "," is used to delimit field-type pairs while ":"
is used to separate a field name with its intended type.

Unspecified fields are parsed at the default string type.

The list of supported types are shown below:

-   string
-   bool
-   integer ("int" would NOT work!)
-   float
-   time
-   array

For the `time` and `array` types, there is an optional third field after
the type name. For the "time" type, you can specify a time format like
you would in `time_format`.

For the "array" type, the third field specifies the delimiter (the
default is ","). For example, if a field called "item\_ids" contains the
value "3,4,5", `types item_ids:array` parses it as \["3", "4", "5"\].
Alternatively, if the value is "Adam\|Alice\|Bob",
`types item_ids:array:|` parses it as \["Adam", "Alice", "Bob"\].

[]{#example}

Example
-------

``` {.CodeRay}
format csv
keys time,host,req_id,user
time_key time
```

With this configuration:

``` {.CodeRay}
2013/02/28 12:00:00,192.168.0.1,111,-
```

This incoming event is parsed as:

``` {.CodeRay}
time:
1362020400 (2013/02/28/ 12:00:00)

record:
{
  "host"   : "192.168.0.1",
  "req_id" : "111",
  "user"   : "-"
}
```

If you set `null_value_pattern '-'` in the configuration, `user` field
becomes `nil` instead of `"-"`.

::: {style="text-align:right"}
Last updated: 2018-11-06 18:16:38 +0000
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/parser_csv) \| ***v0.12*
(td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
:::
:::
:::
