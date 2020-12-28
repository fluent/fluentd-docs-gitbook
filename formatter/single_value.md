# single\_value

The `single_value` formatter plugin output the value of a single field instead of the whole record.

This formatter is often used in conjunction with [`none` parser](../parser/none.md) in input plugin.

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

### `add_newline`

| type | default | version |
| :--- | :--- | :--- |
| bool | `true` | 0.14.0 |

Adds `\n` to the result. If there is a trailing `\n` already, set it `false`.

### `message_key`

| type | default | version |
| :--- | :--- | :--- |
| string | message | 0.14.0 |

The value of this field is outputted.

### `newline`

| type | default | version |
| :--- | :--- | :--- |
| enum | `lf (for non-Windows)` or `crlf (for Windows)` | 1.11.5 |

Specify newline characters.

## Example

```text
tag:    app.event
time:   1362020400
record: {"message":"Hello from Fluentd!"}
```

This incoming event is formatted to:

In non-Windows:

```text
Hello from Fluentd!\n
```

In Windows:

```text
Hello from Fluentd!\r\n
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

