# msgpack

The `msgpack` parser plugin parses the MessagePack data.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

## Example

This incoming event:

```text
\x82\xA7message\xADHello msgpack\xA3numd
```

is parsed as:

```text
time:
1582648111.269613 (current time)

record:
{"message":"Hello msgpack", "num":100}
```

{% include "../.gitbook/assets/footer.txt" %}
