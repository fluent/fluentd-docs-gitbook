# json

The `json` parser plugin parses JSON logs. One JSON map per line.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

### `json_parser`

| type | default | available | version |
| :--- | :--- | :--- | :--- |
| enum | oj | oj, yajl, json | 0.14.0 |

Sets the JSON parser. If you have a problem with the configured parser, check the other available parser types.

NOTE: If you want to enable `json_parser oj` by default, The `oj` gem must be installed separately. This is because `oj` gem is not required from fluentd by default. If `oj` gem is not installed, `json` is used as a fallback. (The fallback has been changed from `yajl` to `json` since v1.19.0.)

Here is a simple comparison:

* `oj`: Faster json parser
* `yajl`: Mainly for stream parsing
* `json`: Standard bundled library

### `stream_buffer_size`

| type | default | version |
| :--- | :--- | :--- |
| integer | 8192 | 1.0.0 |

Set the buffer size that Yajl will use when parsing streaming input.

If you specify the smaller buffer size, you could get outcome response instantaneously in exchange for performance penalty.

See also: [Method: Yajl::Parser\#parse](https://www.rubydoc.info/github/brianmario/yajl-ruby/Yajl%2FParser:parse)

### `time_type`

`json` parser changes the default value of `time_type` to `float`. If you want to parse string field, set `time_type` and `time_format` like this:

```text
# conf
@type json
time_type string
time_format %d/%b/%Y:%H:%M:%S %z

# record example
{"key":"value","time":"28/Feb/2013:12:00:00 +0900"}
```

See also [`parse` Section](../configuration/parse-section.md#time-parameters) article.

## Example

This incoming event:

```text
{"time":1362020400,"host":"192.168.0.1","size":777,"method":"PUT"}
```

is parsed as:

```text
time:
1362020400 (2013-02-28 12:00:00 +0900)

record:
{
  "host"  : "192.168.0.1",
  "size"  : 777,
  "method": "PUT",
}
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

