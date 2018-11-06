::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| ***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

Unix Domain Socket Input Plugin
===============================

The `in_unix` Input plugin enables Fluentd to retrieve records from the
Unix Domain Socket. The wire protocol is the same as
[in\_forward](in_forward), but the transport layer is different.

[]{#example-configuration}

::: {#table-of-contents .section}
### Table of Contents

[Example Configuration](#example-configuration)

[Parameters](#parameters)

-   [\@type (required)](#@type-(required))
-   [path (required)](#path-(required))
-   [backlog](#backlog)
:::

Example Configuration
---------------------

`in_unix` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<source>
  @type unix
  path /path/to/socket.sock
</source>
```
:::
:::
:::

Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

[]{#parameters}

Parameters
----------

[]{#@type-(required)}

### \@type (required)

The value must be `unix`.

[]{#path-(required)}

### path (required)

The path to your Unix Domain Socket.

[]{#backlog}

### backlog

The backlog of Unix Domain Socket. The default is `1024`.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.

::: {style="text-align:right"}
Last updated: 2016-10-21 06:29:58 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| ***v0.12* (td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
