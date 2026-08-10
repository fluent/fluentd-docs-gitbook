# json

The `json` formatter plugin formats an event to JSON.

By default, `json` formatter result doesn't contain `tag` and `time` fields.

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

### `json_parser`

| type | default | version |
| :--- | :--- | :--- |
| string | oj | 0.12.19 |

Sets the library used to generate JSON. Despite its name, this parameter is for generating JSON, not for parsing it.

If `oj` is specified, the [`oj`](https://github.com/ohler55/oj) gem is used. The gem must be installed separately because Fluentd does not require it by default. If it is not installed, the `json` standard library is used as a fallback and it is reported in the log at the info level.

Any other value, including `yajl`, selects the `json` standard library. Unlike [`json_parser`](../parser/json.md#json_parser) of the `json` parser plugin, this parameter is not restricted to a fixed list of values.

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

```javascript
{"host":"192.168.0.1","size":777,"method":"PUT"}
```
