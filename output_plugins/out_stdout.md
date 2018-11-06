
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_stdout) \|
***v0.12*(td-agent2) **
------------------------------------------------------------------------

stdout Output Plugin
====================

The `stdout` output plugin prints events to stdout (or logs if launched
with daemon mode). This output plugin is useful for debugging purposes.


### Table of Contents

[Example Configuration](#example-configuration)

[Parameters](#parameters)

-   [\@type (required)](#@type-(required))
-   [output\_type](#output_type)
Example Configuration
---------------------

`out_stdout` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<match pattern>
  @type stdout
</match>
```
Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

Parameters
----------

### \@type (required)

The value must be `stdout`.

### output\_type

Output format. The following formats are supported:

-   json
-   hash (Ruby's hash)

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.


Last updated: 2016-10-21 06:29:58 UTC
------------------------------------------------------------------------
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_stdout) \|
***v0.12*(td-agent2) **
------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
