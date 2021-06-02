# Formatter Plugins

Fluentd has eight \(8\) types of plugins:

* [Input](../input/)
* [Parser](../parser/)
* [Filter](../filter/)
* [Output](../output/)
* [Formatter](./)
* [Storage](../storage/)
* [Service Discovery](../service_discovery/)
* [Buffer](../buffer/)

This article gives an overview of the Formatter Plugin.

## Overview

Sometimes, the output format for an output plugin does not meet one's needs. Fluentd has a pluggable system called Formatter that lets the user extend and re-use custom output formats.

## How To Use

For an output plugin that supports Formatter, the `<format>` directive can be used to change the output format.

For example, by default, [`out_file`](../output/file.md) plugin outputs data as

```text
2014-08-25 00:00:00 +0000<TAB>foo.bar<TAB>{"k1":"v1", "k2":"v2"}
```

However, if you set `@type json` in `<format>` like this:

```text
<match foo.bar>
  @type file
  path /path/to/file
  <format>
    @type json
  </format>
</match>
```

The output changes to

```javascript
{"time": "2014-08-25 00:00:00 +0000", "tag":"foo.bar", "k1":"v1", "k2":"v2"}
```

i.e., each line is a single JSON object with "time" and "tag fields to retain the event's timestamp and tag.

See [this section](../plugin-development/#text-formatter-plugins) to learn how to develop a custom formatter.

## List of Built-in Formatters

* [`out_file`](out_file.md)
* [`json`](json.md)
* [`ltsv`](ltsv.md)
* [`csv`](csv.md)
* [`msgpack`](msgpack.md)
* [`hash`](hash.md)
* [`single_value`](single_value.md)
* [`tsv`](tsv.md)

## List of Output/Filter Plugins with Formatter Support

* [`filter_stdout`](../filter/stdout.md)
* [`out_file`](../output/file.md)
* [`out_s3`](../output/s3.md)

{% include "../.gitbook/assets/footer.txt" %}
