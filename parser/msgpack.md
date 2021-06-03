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

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

