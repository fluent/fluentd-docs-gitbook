# Formatter Overview

Fluentd has 8 types of plugins: [Input](/plugins/input/README.md),
[Parser](/plugins/parser/README.md), [Filter](/plugins/filter/README.md),
[Output](/plugins/output/README.md),
[Formatter](/plugins/formatter/README.md),
[Storage](/plugins/storage/README.md),
[Service Discovery](/plugins/service_discovery/README.md) and [Buffer](/plugins/buffer/README.md).
This article gives an overview of Formatter Plugin.


## Overview

Sometimes, the output format for an output plugin does not meet one's
needs. Fluentd has a pluggable system called Formatter that lets the
user extend and re-use custom output formats.


## How To Use

For an output plugin that supports Formatter, the `<format>` directive
can be used to change the output format.

For example, by default, [out\_file](/plugins/output/file.md) plugin outputs data as

```
2014-08-25 00:00:00 +0000<TAB>foo.bar<TAB>{"k1":"v1", "k2":"v2"}
```

However, if you set `@type json` in `<format>` like this

```
<match foo.bar>
  @type file
  path /path/to/file
  <format>
    @type json
  </format>
</match>
```

The output changes to

```
{"time": "2014-08-25 00:00:00 +0000", "tag":"foo.bar", "k1:"v1", "k2":"v2"}
```

i.e., each line is a single JSON object with "time" and "tag fields to
retain the event's timestamp and tag.

See [this section](/developer/plugin-development.md/#text-formatter-plugins) to learn
how to develop a custom formatter.


## List of Built-in Formatters

-   [out\_file](/plugins/formatter/out_file.md)
-   [json](/plugins/formatter/json.md)
-   [ltsv](/plugins/formatter/ltsv.md)
-   [csv](/plugins/formatter/csv.md)
-   [msgpack](/plugins/formatter/msgpack.md)
-   [hash](/plugins/formatter/hash.md)
-   [single\_value](/plugins/formatter/single_value.md)


## List of Output/Filter Plugins with Formatter Support

-   [filter\_stdout](/plugins/filter/stdout.md)
-   [out\_file](/plugins/output/file.md)
-   [out\_s3](/plugins/output/s3.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
