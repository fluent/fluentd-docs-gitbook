# Formatter Plugins

Fluentd has 6 types of plugins: [Input](../input/), [Parser](../parser/), [Filter](../filter/), [Output](../output/), [Formatter](./) and [Buffer](../buffer/). This article gives an overview of Formatter Plugin.

## Overview

Sometimes, the output format for an output plugin does not meet one's needs. Fluentd has a pluggable system called Text Formatter that lets the user extend and re-use custom output formats.

## How To Use

For an output plugin that supports Text Formatter, the `format` parameter can be used to change the output format.

For example, by default, [out\_file](../output/file.md) plugin outputs data as

```text
2014-08-25 00:00:00 +0000<TAB>foo.bar<TAB>{"k1":"v1", "k2":"v2"}
```

However, if you set `format json` like this

```text
<match foo.bar>
  @type file
  path /path/to/file
  format json
</match>
```

The output changes to

```text
{"time": "2014-08-25 00:00:00 +0000", "tag":"foo.bar", "k1:"v1", "k2":"v2"}
```

i.e., each line is a single JSON object with "time" and "tag fields to retain the event's timestamp and tag.

See [this section](../developer/plugin-development.md#text-formatter-plugins) to learn how to develop a custom formatter.

## List of Built-in Formatters

* [out\_file](out_file.md)
* [json](json.md)
* [ltsv](ltsv.md)
* [csv](csv.md)
* [msgpack](msgpack.md)
* [hash](hash.md)
* [single\_value](single_value.md)

## List of Output Plugins with Text Formatter Support

* [out\_file](../output/file.md)
* [out\_s3](../output/s3.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

