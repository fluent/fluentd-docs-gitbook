::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/parser_apache_error) \|
***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

apache\_error Parser Plugin
===========================

The `apache_error` parser plugin parses apache error logs.

[]{#parameters}

::: {#table-of-contents .section}
### Table of Contents

[Parameters](#parameters)

-   [keep\_time\_key](#keep_time_key)
-   [types](#types)

[Regexp patterns](#regexp-patterns)

[Example](#example)
:::

Parameters
----------

[]{#keep_time_key}

### keep\_time\_key

If you want to keep time field in the record, set `true`. Default is
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

[]{#regexp-patterns}

Regexp patterns
---------------

This is regexp pattern of this plugin:

``` {.CodeRay}
format /^\[[^ ]* (?<time>[^\]]*)\] \[(?<level>[^\]]*)\](?: \[pid (?<pid>[^\]]*)\])? \[client (?<client>[^\]]*)\] (?<message>.*)$/
```

`level`, `pid`, `client` and `message` are included in the event record.
`time` is used for the event time.

[]{#example}

Example
-------

``` {.CodeRay}
[Wed Oct 11 14:32:52 2000] [error] [client 127.0.0.1] client denied by server configuration
```

This incoming event is parsed as:

``` {.CodeRay}
time:
971242372 (Wed Oct 11 14:32:52 2000)

record:
{
  "level"  : "error",
  "client" : "127.0.0.1",
  "message": "client denied by server configuration"
}
```

::: {style="text-align:right"}
Last updated: 2018-11-06 18:16:27 +0000
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/parser_apache_error) \|
***v0.12* (td-agent2) **
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
