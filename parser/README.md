# Parser Plugins

Fluentd has nine \(9\) types of plugins:

* [Input](../input/)
* [Parser](./)
* [Filter](../filter/)
* [Output](../output/)
* [Formatter](../formatter/)
* [Storage](../storage/)
* [Service Discovery](../service_discovery/)
* [Buffer](../buffer/)
* [Metrics](../metrics/)

This article gives an overview of the Parser Plugin.

## Overview

Sometimes, the `<parse>` directive for input plugins \(e.g. [`in_tail`](../input/tail.md), [`in_syslog`](../input/syslog.md), [`in_tcp`](../input/tcp.md) and [`in_udp`](../input/udp.md)\) cannot parse the user's custom data format \(for example, a context-dependent grammar that can't be parsed with a regular expression\). To address such cases, Fluentd has a pluggable system that enables the user to create their own parser formats.

## How To Use

* Write a custom format plugin. See [here](../plugin-development/api-plugin-parser.md)

  for more information.

* From any input plugin that supports the `<parse>` directive, call the custom

  plugin by its name.

Here is an example to read Nginx access logs using `in_tail` and `parser_nginx`:

```text
<source>
  @type tail
  path /path/to/input/file
  <parse>
    @type nginx
    keep_time_key true
  </parse>
</source>
```

**Note**: When `td-agent` is launched by systemd, the default user of the `td-agent` process is the `td-agent` user.
You must ensure that this user has read permission to the tailed `/path/to/file`. For instance, on Ubuntu,
the default Nginx access file `/var/log/nginx/access.log` is mode `0640` and owned by `www-data:adm`. In
this case, several options are available to allow read access:

1. Add the `td-agent` user to the `adm` group, e.g. through `usermod -aG`, or
2. Use the [`cap_dac_read_search` capability](../deployment/linux-capability#capability-handling-on-in_tail)
   to allow the invoking user to read the file without otherwise changing its permission bits or ownership.

## List of Built-in Parsers

* [`regexp`](regexp.md)
* [`apache2`](apache2.md)
* [`apache_error`](apache_error.md)
* [`nginx`](nginx.md)
* [`syslog`](syslog.md)
* [`csv`](csv.md)
* [`tsv`](tsv.md)
* [`ltsv`](ltsv.md)
* [`json`](json.md)
* [`msgpack`](msgpack.md)
* [`multiline`](multiline.md)
* [`none`](none.md)

### Third-party Parsers

* [`grok`](https://github.com/fluent/fluent-plugin-grok-parser)

  If you are familiar with `grok` patterns, `grok-parser` plugin is useful. Use `> 1.0.0` versions for `fluentd` v0.14/v1.0.

* [`multi-format-parser`](https://github.com/repeatedly/fluent-plugin-multi-format-parser)

  If you need to parse multiple formats in one data stream, `multi-format-parser` is useful.

* [`protobuf`](https://github.com/fluent-plugins-nursery/fluent-plugin-parser-protobuf)

  For protocol buffers.

* [`avro`](https://github.com/fluent-plugins-nursery/fluent-plugin-parser-avro)

  For Apache Avro.

## List of Core Input Plugins with Parser support

Following plugins support `<parse>` directive:

* [`in_tail`](../input/tail.md)
* [`in_tcp`](../input/tcp.md)
* [`in_udp`](../input/udp.md)
* [`in_syslog`](../input/syslog.md)
* [`in_http`](../input/http.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

