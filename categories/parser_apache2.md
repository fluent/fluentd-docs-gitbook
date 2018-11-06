::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/parser_apache2) \|
***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

apache2 Parser Plugin
=====================

The `apache2` parser plugin parses apache2 logs.

[]{#parameters}

::: {#table-of-contents .section}
### Table of Contents

[Parameters](#parameters)

-   [keep\_time\_key](#keep_time_key)

[Regexp patterns](#regexp-patterns)

[Example](#example)
:::

Parameters
----------

[]{#keep_time_key}

### keep\_time\_key

If you want to keep time field in the record, set `true`. Default is
`false`.

[]{#regexp-patterns}

Regexp patterns
---------------

This is regexp and time format patterns of this plugin:

``` {.CodeRay}
format /^(?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^ ]*) +\S*)?" (?<code>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)")?$/
time_format %d/%b/%Y:%H:%M:%S %z
```

`host`, `user`, `method`, `path`, `code`, `size`, `referer` and `agent`
are included in the event record. `time` is used for the event time.

`code` and `size` fields are converted into integer type automatically.
And if the field value is `-`, it is interpreted as `nil`. See "Result
Example".

[]{#example}

Example
-------

``` {.CodeRay}
192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777 "-" "Opera/12.0"
```

This incoming event is parsed as:

``` {.CodeRay}
time:
1362020400 (28/Feb/2013:12:00:00 +0900)

record:
{
  "user"   : nil,
  "method" : "GET",
  "code"   : 200,
  "size"   : 777,
  "host"   : "192.168.0.1",
  "path"   : "/",
  "referer": nil,
  "agent"  : "Opera/12.0"
}
```

::: {style="text-align:right"}
Last updated: 2018-11-06 18:16:25 +0000
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/parser_apache2) \|
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
