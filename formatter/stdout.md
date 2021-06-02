# stdout

The `stdout` formatter plugin converts an event to the stdout format.

This plugin is only for [`stdout` Output Plugin](../output/stdout.md) and [`stdout` Filter Plugin](../filter/stdout.md).

```text
2015-05-02 12:12:17 +0900 tag: {"field1":"value1","field2":"value2"}
```

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

### `output_type` \(string\) \(optional\)

| type | default | version |
| :--- | :--- | :--- |
| string | `json` | 0.14.0 |

Sets the sub-formatter type. Any formatter plugins can be specified.

## Example

```text
<format>
  @type stdout
  output_type json
</format>
```

with this configuration:

```text
tag:    app.event
time:   1511156652
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

```text
2017-11-20 14:44:12 +0900 app.event: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

{% include "../.gitbook/assets/footer.txt" %}
