# tsv

The `tsv` formatter plugin output an event as TSV

```text
value1[delimiter]value2[delimiter]value3[delimiter]...[newline]
```

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

### `keys`

| type | default | version |
| :--- | :--- | :--- |
| array | nil | 0.14.9 |

Field names included in each lines

### `delimiter`

| type | default | version |
| :--- | :--- | :--- |
| string | `\t` \(TAB\) | 0.14.9 |

The delimiter character (or string) of TSV values.

### `add_newline`

| type | default | version |
| :--- | :--- | :--- |
| bool | `true` | 0.14.22 |

Adds `\n` to the result.

## Example

```
<format>
  @type tsv
  fields host,method
</format>
```

```text
tag:    app.event
time:   1362020400
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

In non-Windows:

```text
192.168.0.1\tPUT\n
```

In Windows:

```text
192.168.0.1\tPUT\r\n
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

