
Versions \| [v1.0 (td-agent3)](/v1.0/articles/formatter-plugin-overview)
\| ***v0.12* (td-agent2) **
------------------------------------------------------------------------

Text Formatter Overview
=======================

Fluentd has 6 types of plugins: [Input](input-plugin-overview),
[Parser](parser-plugin-overview), [Filter](filter-plugin-overview),
[Output](output-plugin-overview), [Formatter](formatter-plugin-overview)
and [Buffer](buffer-plugin-overview). This article gives an overview of
Formatter Plugin.


### Table of Contents

-   [Overview](#overview)
-   [How To Use](#how-to-use)
-   [List of Built-in Formatters](#list-of-built-in-formatters)
-   [List of Output Plugins with Text Formatter
    Support](#list-of-output-plugins-with-text-formatter-support)
Overview
--------

Sometimes, the output format for an output plugin does not meet one's
needs. Fluentd has a pluggable system called Text Formatter that lets
the user extend and re-use custom output formats.

How To Use
----------

For an output plugin that supports Text Formatter, the `format`
parameter can be used to change the output format.

For example, by default, [out\_file](out_file) plugin outputs data as

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

-   [out\_file](formatter_out_file)
-   [json](formatter_json)
-   [ltsv](formatter_ltsv)
-   [csv](formatter_csv)
-   [msgpack](formatter_msgpack)
-   [hash](formatter_hash)
-   [single\_value](formatter_single_value)

List of Output Plugins with Text Formatter Support
--------------------------------------------------

-   [out\_file](out_file)
-   [out\_s3](out_s3)


Last updated: 2015-12-01 21:20:32 UTC
------------------------------------------------------------------------
Versions \| [v1.0 (td-agent3)](/v1.0/articles/formatter-plugin-overview)
\| ***v0.12* (td-agent2) **
------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
