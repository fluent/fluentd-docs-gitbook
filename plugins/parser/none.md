# none Parser Plugin

The `none` parser plugin parses the line as-is with single field. This
format is to defer parsing/structuring the data.

This parser is often used in conjunction with [single\_value format](/plugins/formatter/single_value.md) in output plugin.


## Parameters

See [Parse section configurations](/configuration/parse-section.md)


### message\_key

| type   | default | version |
|:-------|:--------|:--------|
| string | message | 0.14.0  |

Specify field name to contain logs.


## Example

```
Hello world. I am a line of log!
```

This incoming event is parsed as:

```
time:
1362020400 (current time)

record:
{"message":"Hello world. I am a line of log!"}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
