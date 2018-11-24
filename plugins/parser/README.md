# Parser Plugin Overview

Fluentd has 7 types of plugins: [Input](/plugins/input/README.md),
[Parser](/plugins/parser/README.md), [Filter](/plugins/filter/README.md),
[Output](/plugins/output/README.md),
[Formatter](/plugins/formatter/README.md),
[Storage](/plugins/storage/README.md) and [Buffer](/plugins/buffer/README.md).
This article gives an overview of Parser Plugin.


## Overview

Sometimes, the `<parse>` directive for input plugins (ex:
[in\_tail](/plugins/input/tail.md), [in\_syslog](/plugins/input/syslog.md), [in\_tcp](/plugins/input/tcp.md) and
[in\_udp](/plugins/input/udp.md)) cannot parse the user's custom data format (for
example, a context-dependent grammar that can't be parsed with a regular
expression). To address such cases. Fluentd has a pluggable system that
enables the user to create their own parser formats.


## How To Use

-   Write a custom format plugin. [See here for more information](/developer/plugin-development.md/#parser-plugins).
-   From any input plugin that supports the `<parse>` directive, call
    the custom plugin by its name.

Here is a simple example to read Nginx access logs using `in_tail` and
`parser_nginx`:

``` {.CodeRay}
<source>
  @type tail
  path /path/to/input/file
  <parse>
    @type nginx
    keep_time_key true
  </parse>
</source>
```


## List of Built-in Parsers

-   [regexp](/plugins/parser/regexp.md)
-   [apache2](/plugins/parser/apache2.md)
-   [apache\_error](/plugins/parser/apache_error.md)
-   [nginx](/plugins/parser/nginx.md)
-   [syslog](/plugins/parser/syslog.md)
-   [csv](/plugins/parser/csv.md)
-   [tsv](/plugins/parser/tsv.md)
-   [ltsv](/plugins/parser/ltsv.md)
-   [json](/plugins/parser/json.md)
-   [multiline](/plugins/parser/multiline.md)
-   [none](/plugins/parser/none.md)


### 3rd party Parsers

-   [grok](https://github.com/fluent/fluent-plugin-grok-parser)

If you are familiar with grok patterns, grok-parser plugin is useful.
Use `> 1.0.0` versions for fluentd v0.14/v1.0.


## List of Core Input Plugins with Parser support

with `<parse>` directive.

-   [in\_tail](/plugins/input/tail.md)
-   [in\_tcp](/plugins/input/tcp.md)
-   [in\_udp](/plugins/input/udp.md)
-   [in\_syslog](/plugins/input/syslog.md)
-   [in\_http](/plugins/input/http.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
