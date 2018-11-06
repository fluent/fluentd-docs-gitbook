
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_null) \| ***v0.12*(td-agent2) **
------------------------------------------------------------------------

null Output Plugin
==================

The `null` output plugin just throws away events.


### Table of Contents

[Example Configuration](#example-configuration)

[Parameters](#parameters)

-   [\@type (required)](#@type-(required))
Example Configuration
---------------------

`out_null` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<match pattern>
  @type null
</match>
```
Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

Parameters
----------

### \@type (required)

The value must be `null`.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.


Last updated: 2015-12-01 21:20:32 UTC
------------------------------------------------------------------------
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_null) \| ***v0.12*(td-agent2) **
------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
