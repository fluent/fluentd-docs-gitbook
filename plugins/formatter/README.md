# Formatter Overview

Fluentd has 7 types of plugins: [Input](/plugins/input/input-plugin-overview.md),
[Parser](/plugins/parser/parser-plugin-overview.md), [Filter](/plugins/filter/filter-plugin-overview.md),
[Output](/plugins/output/output-plugin-overview.md),
[Formatter](/plugins/formatter/formatter-plugin-overview.md),
[Storage](/plugins/storage/storage-plugin-overview.md) and [Buffer](/plugins/buffer/buffer-plugin-overview.md).
This article gives an overview of Formatter Plugin.


## Overview

Sometimes, the output format for an output plugin does not meet one's
needs. Fluentd has a pluggable system called Formatter that lets the
user extend and re-use custom output formats.


## How To Use

For an output plugin that supports Formatter, the `<format>` directive
can be used to change the output format.

For example, by default, [out\_file](/plugins/output/out_file.md) plugin outputs data as

``` {.CodeRay}
2014-08-25 00:00:00 +0000<TAB>foo.bar<TAB>{"k1":"v1", "k2":"v2"}
```

However, if you set `@type json` in `<format>` like this

``` {.CodeRay}
<match foo.bar>
  @type file
  path /path/to/file
  <format>
    @type json
  </format>
</match>
```

The output changes to

``` {.CodeRay}
{"time": "2014-08-25 00:00:00 +0000", "tag":"foo.bar", "k1:"v1", "k2":"v2"}
```

i.e., each line is a single JSON object with "time" and "tag fields to
retain the event's timestamp and tag.

See [this section](/developer/plugin-development.md/#text-formatter-plugins) to learn
how to develop a custom formatter.


## List of Built-in Formatters

-   [out\_file](/plugins/formatter/formatter_out_file.md)
-   [json](/plugins/formatter/formatter_json.md)
-   [ltsv](/plugins/formatter/formatter_ltsv.md)
-   [csv](/plugins/formatter/formatter_csv.md)
-   [msgpack](/plugins/formatter/formatter_msgpack.md)
-   [hash](/plugins/formatter/formatter_hash.md)
-   [single\_value](/plugins/formatter/formatter_single_value.md)


## List of Output/Filter Plugins with Formatter Support

-   [filter\_stdout](/plugins/filter/filter_stdout.md)
-   [out\_file](/plugins/output/out_file.md)
-   [out\_s3](/plugins/output/out_s3.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
