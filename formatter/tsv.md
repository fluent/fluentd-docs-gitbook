# tsv

The `tsv` formatter plugin converts an event as TSV.

```text
value1[delimiter]value2[newline]
```

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

### `keys`

| type | default | version |
| :--- | :--- | :--- |
| array of string | `nil` | 0.14.0 |

Specifies the output fields. It is a required parameter.

### `delimiter`

| type | default | version |
| :--- | :--- | :--- |
| string | `\t` \(TAB\) | 0.14.0 |

Delimiter for the fields.

### `add_newline`

| type | default | version |
| :--- | :--- | :--- |
| bool | `true` | 0.14.12 |

Adds `\n` to the result.

### `newline`

| type | default | version |
| :--- | :--- | :--- |
| enum | `lf (for non-Windows)` or `crlf (for Windows)` | 1.11.5 |

Specify newline characters.

## Example

```text
tag:    app.event
time:   1362020400
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

In non-Windows:

```text
192.168.0.1\t777\tPUT\n
```

In non-Windows:

```text
192.168.0.1\t777\tPUT\r\n
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

