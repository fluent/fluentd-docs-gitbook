# json Parser Plugin

The `json` parser plugin parses JSON logs. One JSON map per line.


## Parameters

See [Parse section configurations](/configuration/parse-section.md)


### json\_parser

| type | default | available      | version |
|:-----|:--------|:---------------|:--------|
| enum | oj      | oj, yajl, json | 0.14.0  |

Set JSON parser.


## Example

``` {.CodeRay}
{"time":1362020400,"host":"192.168.0.1","size":777,"method":"PUT"}
```

This incoming event is parsed as:

``` {.CodeRay}
time:
1362020400 (2013-02-28 12:00:00 +0900)

record:
{
  "host"  : "192.168.0.1",
  "size"  : 777,
  "method": "PUT",
}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
