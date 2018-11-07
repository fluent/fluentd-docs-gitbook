Parser Plugin Overview
======================

Fluentd has 6 types of plugins: [Input](input-plugin-overview.md),
[Parser](parser-plugin-overview.md), [Filter](filter-plugin-overview.md),
[Output](output-plugin-overview.md), [Formatter](formatter-plugin-overview.md)
and [Buffer](buffer-plugin-overview.md). This article gives an overview of
Parser Plugin.


Overview
--------

Sometimes, the `format` parameter for input plugins (ex:
[in\_tail](in_tail), [in\_syslog](in_syslog), [in\_tcp](in_tcp) and
[in\_udp](in_udp)) cannot parse the user's custom data format (for
example, a context-dependent grammar that can't be parsed with a regular
expression). To address such cases. Fluentd has a pluggable system that
enables the user to create their own parser formats.

How To Use
----------

-   Write a custom format plugin. [See here for more
    information](plugin-development#parser-plugins).
-   From any input plugin that supports the "format" field, call the
    custom plugin by its name.

Here is a simple example to read Nginx access logs using `in_tail` and
`parser_nginx`:

``` {.CodeRay}
<source>
  @type tail
  path /path/to/input/file
  format nginx
  keep_time_key true
</source>
```

List of Built-in Parsers
------------------------

-   [regexp](parser_regexp)
-   [apache2](parser_apache2)
-   [apache\_error](parser_apache_error)
-   [nginx](parser_nginx)
-   [syslog](parser_syslog)
-   [csv](parser_csv)
-   [tsv](parser_tsv)
-   [ltsv](parser_ltsv)
-   [json](parser_json)
-   [multiline](parser_multiline)
-   [none](parser_none)

### 3rd party Parsers

-   [grok](https://github.com/fluent/fluent-plugin-grok-parser)

If you are familiar with grok patterns, grok-parser plugin is useful.
Use `< 1.0.0` versions for fluentd v0.12.

List of Core Input Plugins with Parser support
----------------------------------------------

with `format` parameter.

-   [in\_tail](in_tail)
-   [in\_tcp](in_tcp)
-   [in\_udp](in_udp)
-   [in\_syslog](in_syslog)
-   [in\_http](in_http)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
