# Parser Plugins

Fluentd has 6 types of plugins: [Input](../input/), [Parser](./), [Filter](../filter/), [Output](../output/), [Formatter](../formatter/) and [Buffer](../buffer/). This article gives an overview of Parser Plugin.

## Overview

Sometimes, the `format` parameter for input plugins \(ex: [in\_tail](../input/tail.md), [in\_syslog](../input/syslog.md), [in\_tcp](../input/tcp.md) and [in\_udp](../input/udp.md)\) cannot parse the user's custom data format \(for example, a context-dependent grammar that can't be parsed with a regular expression\). To address such cases. Fluentd has a pluggable system that enables the user to create their own parser formats.

## How To Use

* Write a custom format plugin. [See here for more information](../developer/plugin-development.md#parser-plugins).
* From any input plugin that supports the "format" field, call the

  custom plugin by its name.

Here is a simple example to read Nginx access logs using `in_tail` and `parser_nginx`:

```text
<source>
  @type tail
  path /path/to/input/file
  format nginx
  keep_time_key true
</source>
```

## List of Built-in Parsers

* [regexp](regexp.md)
* [apache2](apache2.md)
* [apache\_error](apache_error.md)
* [nginx](nginx.md)
* [syslog](syslog.md)
* [csv](csv.md)
* [tsv](tsv.md)
* [ltsv](ltsv.md)
* [json](json.md)
* [multiline](multiline.md)
* [none](none.md)

### 3rd party Parsers

* [grok](https://github.com/fluent/fluent-plugin-grok-parser)

If you are familiar with grok patterns, grok-parser plugin is useful. Use `< 1.0.0` versions for fluentd v0.12.

## List of Core Input Plugins with Parser support

with `format` parameter.

* [in\_tail](../input/tail.md)
* [in\_tcp](../input/tcp.md)
* [in\_udp](../input/udp.md)
* [in\_syslog](../input/syslog.md)
* [in\_http](../input/http.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

