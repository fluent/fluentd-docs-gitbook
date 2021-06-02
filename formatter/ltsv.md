# ltsv

The `ltsv` formatter plugin output an event as [LTSV](http://ltsv.org).

```text
field1[label_delimiter]value1[delimiter]field2[label_delimiter]value2[newline]
```

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

### `delimiter`

| type | default | version |
| :--- | :--- | :--- |
| string | `\t` \(TAB\) | 0.14.0 |

Delimiter for the fields.

### `label_delimiter`

| type | default | version |
| :--- | :--- | :--- |
| string | `:` | 0.14.0 |

Delimiter for the key-value field.

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

### `replacement`

| type | default | version |
| :--- | :--- | :--- |
| string |  `` \(SPACE\) | 1.12.2 |

Safe replacement to substitute delimiters characters in records.

## Example

```text
tag:    app.event
time:   1362020400
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

In non-Windows:

```text
host:192.168.0.1\tsize:777\tmethod:PUT\n
```

In Windows:

```text
host:192.168.0.1\tsize:777\tmethod:PUT\r\n
```

{% include "../.gitbook/assets/footer.txt" %}
