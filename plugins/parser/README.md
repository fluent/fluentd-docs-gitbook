# Parser Plugin Overview

Fluentd has eight (8) types of plugins:

-   [Input](/plugins/input/README.md)
-   [Parser](/plugins/parser/README.md)
-   [Filter](/plugins/filter/README.md)
-   [Output](/plugins/output/README.md)
-   [Formatter](/plugins/formatter/README.md)
-   [Storage](/plugins/storage/README.md)
-   [Service Discovery](/plugins/service_discovery/README.md)
-   [Buffer](/plugins/buffer/README.md)

This article gives an overview of Parser Plugin.


## Overview

Sometimes, the `<parse>` directive for input plugins (e.g.
[`in_tail`](/plugins/input/tail.md), [`in_syslog`](/plugins/input/syslog.md),
[`in_tcp`](/plugins/input/tcp.md) and [`in_udp`](/plugins/input/udp.md)) cannot
parse the user's custom data format (for example, a context-dependent grammar
that can't be parsed with a regular expression). To address such cases, Fluentd
has a pluggable system that enables the user to create their own parser formats.


## How To Use

-   Write a custom format plugin. See [here](/developer/api-plugin-parser.md)
    for more information.
-   From any input plugin that supports the `<parse>` directive, call the custom
    plugin by its name.

Here is a simple example to read Nginx access logs using `in_tail` and
`parser_nginx`:

```
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

-   [`regexp`](/plugins/parser/regexp.md)
-   [`apache2`](/plugins/parser/apache2.md)
-   [`apache_error`](/plugins/parser/apache_error.md)
-   [`nginx`](/plugins/parser/nginx.md)
-   [`syslog`](/plugins/parser/syslog.md)
-   [`csv`](/plugins/parser/csv.md)
-   [`tsv`](/plugins/parser/tsv.md)
-   [`ltsv`](/plugins/parser/ltsv.md)
-   [`json`](/plugins/parser/json.md)
-   [`msgpack`](/plugins/parser/msgpack.md)
-   [`multiline`](/plugins/parser/multiline.md)
-   [`none`](/plugins/parser/none.md)


### Third-party Parsers

-   [`grok`](https://github.com/fluent/fluent-plugin-grok-parser)

    If you are familiar with `grok` patterns, `grok-parser` plugin is useful.
    Use `> 1.0.0` versions for `fluentd` v0.14/v1.0.

-   [`multi-format-parser`](https://github.com/repeatedly/fluent-plugin-multi-format-parser)

    If you need to parse multiple formats in one data stream,
    `multi-format-parser` is useful.

-   [`protobuf`](https://github.com/fluent-plugins-nursery/fluent-plugin-parser-protobuf)

    For protocol buffers.


## List of Core Input Plugins with Parser support

Following plugins support `<parse>` directive:

-   [`in_tail`](/plugins/input/tail.md)
-   [`in_tcp`](/plugins/input/tcp.md)
-   [`in_udp`](/plugins/input/udp.md)
-   [`in_syslog`](/plugins/input/syslog.md)
-   [`in_http`](/plugins/input/http.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under
[Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are
available under the Apache 2 License.
