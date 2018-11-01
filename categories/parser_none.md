none Parser Plugin
==================

The `none` parser plugin parses the line as-is with single field. This
format is to defer parsing/structuring the data.

[]{#parameters}

::: {#table-of-contents .section}
### Table of Contents

[Parameters](#parameters)

-   [message\_key](#message_key)

[Example](#example)
:::

Parameters
----------

[]{#message_key}

### message\_key

Specify field name to contain logs. Default is `message`.

[]{#example}

Example
-------

``` {.CodeRay}
Hello world. I am a line of log!
```

This incoming event is parsed as:

``` {.CodeRay}
time:
1362020400 (current time)

record:
{"message":"Hello world. I am a line of log!"}
```

::: {style="text-align:right"}
Last updated: 2018-10-19 00:26:16 +0000
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/parser_none) \| ***v0.12*
(td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
