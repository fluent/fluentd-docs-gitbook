Text Formatter Overview
=======================

Fluentd has 6 types of plugins: [Input](input-plugin-overview.md),
[Parser](parser-plugin-overview.md), [Filter](filter-plugin-overview.md),
[Output](output-plugin-overview.md), [Formatter](formatter-plugin-overview.md)
and [Buffer](buffer-plugin-overview.md). This article gives an overview of
Formatter Plugin.


Overview
--------

Sometimes, the output format for an output plugin does not meet one's
needs. Fluentd has a pluggable system called Text Formatter that lets
the user extend and re-use custom output formats.

How To Use
----------

For an output plugin that supports Text Formatter, the `format`
parameter can be used to change the output format.

For example, by default, [out\_file](/articles/out_file.md) plugin outputs data as

``` {.CodeRay}
2014-08-25 00:00:00 +0000<TAB>foo.bar<TAB>{"k1":"v1", "k2":"v2"}
```

However, if you set `format json` like this

``` {.CodeRay}
<match foo.bar>
  @type file
  path /path/to/file
  format json
</match>
```

The output changes to

``` {.CodeRay}
{"time": "2014-08-25 00:00:00 +0000", "tag":"foo.bar", "k1:"v1", "k2":"v2"}
```

i.e., each line is a single JSON object with "time" and "tag fields to
retain the event's timestamp and tag.

See [this section](plugin-development#text-formatter-plugins) to learn
how to develop a custom formatter.

List of Built-in Formatters
---------------------------

-   [out\_file](/articles/formatter_out_file.md)
-   [json](/articles/formatter_json.md)
-   [ltsv](/articles/formatter_ltsv.md)
-   [csv](/articles/formatter_csv.md)
-   [msgpack](/articles/formatter_msgpack.md)
-   [hash](/articles/formatter_hash.md)
-   [single\_value](/articles/formatter_single_value.md)

List of Output Plugins with Text Formatter Support
--------------------------------------------------

-   [out\_file](/articles/out_file.md)
-   [out\_s3](/articles/out_s3.md)




If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
