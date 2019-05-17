# stdout Formatter Plugin

The `stdout` formatter plugin converts an event to stdout format.

This plugin is only for [stdout Output Plugin](/plugins/output/stdout.md) and [stdout Filter Plugin](/plugins/filter/stdout.md).

```
2015-05-02 12:12:17 +0900 tag: {"field1":"value1","field2":"value2"}
```


## Parameters

-   [Common Parameters](/configuration/plugin-common-parameters.md)
-   [Format section configurations](/configuration/format-section.md)


### output\_type (string) (optional)

| type   | default | version |
|:-------|:--------|:--------|
| string | json    | 0.14.0  |

Set sub-formatter type. Any formatter plugins can be specified.


## Example

```
<format>
  @type stdout
  output_type json
</format>
```

with this configuration:

```
tag:    app.event
time:   1511156652
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is formatted to:

```
2017-11-20 14:44:12 +0900 app.event: {"host":"192.168.0.1","size":777,"method":"PUT"}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
