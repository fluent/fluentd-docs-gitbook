# msgpack Parser Plugin

The `msgpack` parser plugin parses the MessagePack data.

## Parameters

See [Parse section configurations](/configuration/parse-section.md)

## Example

```
\x82\xA7message\xADHello msgpack\xA3numd
```

This incoming event is parsed as:

```
time:
1582648111.269613 (current time)

record:
{"message":"Hello msgpack", "num":100}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
