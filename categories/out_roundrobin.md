::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_roundrobin) \|
***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

roundrobin Output Plugin
========================

The `roundrobin` Output plugin distributes events to multiple outputs
using a round-robin algorithm.


### Table of Contents

[Example Configuration](#example-configuration)

[Parameters](#parameters)

-   [\@type (required)](#@type-(required))
-   [\<store\> (required at least
    one)](#%3Cstore%3E-(required-at-least-one))
:::

Example Configuration
---------------------

`out_roundrobin` is included in Fluentd's core. No additional
installation process is required.

``` {.CodeRay}
<match pattern>
  @type roundrobin

  <store>
    @type tcp
    host 192.168.1.21
    ...
  </store>
  <store>
    ...
  </store>
  <store>
    ...
  </store>
</match>
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

The value must be `roundrobin`.

[]{#<store>-(required-at-least-one)}

### \<store\> (required at least one)

Specifies the storage destinations. The format is the same as the
\<match\> directive.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.

::: {style="text-align:right"}
Last updated: 2015-12-01 21:20:32 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_roundrobin) \|
***v0.12* (td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
