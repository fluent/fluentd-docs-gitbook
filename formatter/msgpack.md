# msgpack

The `msgpack` formatter plugin converts an event to the msgpack binary.

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Format section configurations](../configuration/format-section.md)

## Example

```text
tag:    app.event
time:   1362020400
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

```text
\x83\xA4host\xAB192.168.0.1\xA4size\xCD\x03\t\xA6method\xA3PUT
```

{% include "../.gitbook/assets/footer.txt" %}
