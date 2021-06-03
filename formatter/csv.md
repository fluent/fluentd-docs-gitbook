# csv

The `csv` formatter plugin output an event as CSV.

```text
"value1"[delimiter]"value2"[delimiter]"value3"[newline]
```

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

### `fields`

| type | default | version |
| :--- | :--- | :--- |
| array of string | `nil` | 0.14.0 |

Specifies the output fields. It is a required parameter.

### delimiter \(String, Optional. defaults to ","\)

| type | default | version |
| :--- | :--- | :--- |
| string | `,` | 0.14.0 |

Delimiter for values.

Use `\t` or `TAB` to specify the tab character.

### `force_quotes`

| type | default | version |
| :--- | :--- | :--- |
| bool | `true` | 0.14.0 |

If `false`, the value will not be framed by quotes.

### `add_newline`

| type | default | version |
| :--- | :--- | :--- |
| bool | `true` | 0.14.12 |

Add `\n` to the result.

## Example

```text
<format>
  @type csv
  fields host,method
</format>
```

With this configuration:

```text
tag:    app.event
time:   1362020400
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

In non-Windows:

```text
"192.168.0.1","PUT"\n
```

In Windows:

```text
"192.168.0.1","PUT"\r\n
```

With `force_quotes false`, the result is:

In non-Windows:

```text
192.168.0.1,PUT\n
```

In Windows:

```text
192.168.0.1,PUT\r\n
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

