# none

The `none` parser plugin parses the line as-is with the single field. This format is to defer the parsing/structuring of the data.

This parser is often used in conjunction with [`single_value`](../formatter/single_value.md) format in output plugin.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

### `message_key`

| type | default | version |
| :--- | :--- | :--- |
| string | message | 0.14.0 |

Specifies the field name to contain logs.

## Example

This incoming event:

```text
Hello world. I am a line of log!
```

is parsed as:

```text
time:
1362020400 (current time)

record:
{"message":"Hello world. I am a line of log!"}
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

