# msgpack Formatter Plugin

The `msgpack` formatter plugin converts an event to msgpack binary.


## Parameters

-   [Common Parameters](/configuration/plugin-common-parameters.md)
-   [Format section configurations](/configuration/format-section.md)


## Example

```
tag:    app.event
time:   1362020400
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

```
\x83\xA4host\xAB192.168.0.1\xA4size\xCD\x03\t\xA6method\xA3PUT
```



------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
