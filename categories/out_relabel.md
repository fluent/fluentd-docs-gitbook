::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_relabel) \| ***v0.12*
(td-agent2) **
:::
:::

------------------------------------------------------------------------

relabel Output Plugin
=====================

The `relabel` output plugin re-labels events.

[]{#example-configuration}

::: {#table-of-contents .section}
### Table of Contents

[Example Configuration](#example-configuration)

[Parameters](#parameters)

-   [\@type (required)](#@type-(required))
-   [\@label](#@label)
:::

Example Configuration
---------------------

`out_relabel` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<match pattern>
  @type relabel
  @label @foo
</match>

<label @foo>
  <match patter>
    ...
  </match>
</label>
```

The above example puts a label `@foo` to matched events, and the `label`
directive can take care of these events.

FYI: All of input and output plugins also have `@label` parameter
provided by Fluentd core. The `relabel` plugin is a plugin which
actually does nothing, but supports only `@label` parameter.

[]{#parameters}

Parameters
----------

[]{#@type-(required)}

### \@type (required)

The value must be `relabel`.

[]{#@label}

### \@label

The label.

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
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_relabel) \| ***v0.12*
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
