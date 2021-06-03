# out\_file

The `out_file` formatter plugin outputs time, tag and json record separated by a delimiter.

```text
time[delimiter]tag[delimiter]record[newline]
```

This format is a default format of `out_file` plugin.

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

### `delimiter`

| type | default | version |
| :--- | :--- | :--- |
| string | `\t` \(TAB\) | 0.14.0 |

Delimiter for each field.

Supported: SPACE \(`' '`\) and COMMA \(`','`\)

### `output_tag`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.0 |

Output tag field if `true`.

### `output_time`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.0 |

Output time field if `true`.

### `time_type`

| type | default | version |
| :--- | :--- | :--- |
| enum | string | 0.14.7 |

Overwrites the default value in this plugin.

### `time_format`

| type | default | version |
| :--- | :--- | :--- |
| string | nil\(iso8601\) | 0.14.7 |

Overwrites the default value in this plugin.

### `newline`

| type | default | version |
| :--- | :--- | :--- |
| enum | `lf (for non-Windows)` or `crlf (for Windows)` | 1.11.5 |

Specify newline characters.

## Example

```text
tag:    app.event
time:   1362020400t
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

```text
2013-02-28T12:00:00+09:00\tapp.event\t{"host":"192.168.0.1","size":777,"method":"PUT"}
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

