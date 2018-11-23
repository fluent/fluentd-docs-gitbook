# apache2 Parser Plugin

The `apache2` parser plugin parses apache2 logs.


## Parameters

See [Parse section configurations](/articles/parse-section.md)


## Regexp patterns

This is regexp and time format patterns of this plugin:

``` {.CodeRay}
expression /^(?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^ ]*) +\S*)?" (?<code>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)")?$/
time_format %d/%b/%Y:%H:%M:%S %z
```

`host`, `user`, `method`, `path`, `code`, `size`, `referer` and `agent`
are included in the event record. `time` is used for the event time.

`code` and `size` fields are converted into integer type automatically.
And if the field value is `-`, it is interpreted as `nil`. See "Result
Example".


## Example

``` {.CodeRay}
192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777 "-" "Opera/12.0"
```

This incoming event is parsed as:

``` {.CodeRay}
time:
1362020400 (28/Feb/2013:12:00:00 +0900)

record:
{
  "user"   : nil,
  "method" : "GET",
  "code"   : 200,
  "size"   : 777,
  "host"   : "192.168.0.1",
  "path"   : "/",
  "referer": nil,
  "agent"  : "Opera/12.0"
}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
