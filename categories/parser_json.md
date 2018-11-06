::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/parser_json) \| ***v0.12*
(td-agent2) **
:::
:::

------------------------------------------------------------------------

json Parser Plugin
==================

The `json` parser plugin parses JSON logs. One JSON map per line.


### Table of Contents

[Parameters](#parameters)

-   [time\_key](#time_key)
-   [time\_format](#time_format)
-   [keep\_time\_key](#keep_time_key)

[Example](#example)
:::

Parameters
----------

[]{#time_key}

### time\_key

Specify time field for event time. Default is `time`.

If there is no time field in the record, this parser uses current time
as an event time.

[]{#time_format}

### time\_format

If time field value is formatted string, e.g. "28/Feb/2013:12:00:00
+0900", you need to specify this parameter to parse it.

Default is `nil` and it means time field value is a second integer like
`1497915137`.

See
[Time\#strptime](http://ruby-doc.org/stdlib-2.4.1/libdoc/time/rdoc/Time.html#method-c-strptime)
for additional format information.

[]{#keep_time_key}

### keep\_time\_key

If you want to keep time field in the record, set `true`. Default is
`false`.

[]{#example}

Example
-------

``` {.CodeRay}
{"time":1362020400,"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is parsed as:

``` {.CodeRay}
time:
1362020400 (2013-02-28 12:00:00 +0900)

record:
{
  "host"  : "192.168.0.1",
  "size"  : 777,
  "method": "PUT",
}
```

::: {style="text-align:right"}
Last updated: 2018-11-06 18:02:28 +0000
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/parser_json) \| ***v0.12*
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
