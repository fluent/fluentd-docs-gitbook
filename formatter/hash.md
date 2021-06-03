# hash

The `hash` formatter plugin converts an event to the Ruby hash.

By default, `hash` formatter result doesn't contain `tag` and `time` fields.

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

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

```ruby
{"host"=>"192.168.0.1","size"=>777,"method"=>"PUT"}
```

{% include "../.gitbook/assets/footer.txt" %}
