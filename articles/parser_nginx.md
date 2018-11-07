# nginx Parser Plugin

The `nginx` parser plugin parses default nginx logs.


## Parameters

See [Parse section configurations](/articles/parse-section.md)


## Regexp patterns

This is regexp and time format patterns of this plugin:

``` {.CodeRay}
expression /^(?<remote>[^ ]*) (?<host>[^ ]*) (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*?)(?: +\S*)?)?" (?<code>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)"(?:\s+(?<http_x_forwarded_for>[^ ]+))?)?$/
time_format %d/%b/%Y:%H:%M:%S %z
```

`remote`, `user`, `method`, `path`, `code`, `size`, `referer`, `agent`
and `http_x_forwarded_for` are included in the event record. `time` is
used for the event time.


## Example

``` {.CodeRay}
127.0.0.1 192.168.0.1 - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777 "-" "Opera/12.0" -
```

This incoming event is parsed as:

``` {.CodeRay}
time:
1362020400 (28/Feb/2013:12:00:00 +0900)

record:
{
  "remote"              : "127.0.0.1",
  "host"                : "192.168.0.1",
  "user"                : "-",
  "method"              : "GET",
  "path"                : "/",
  "code"                : "200",
  "size"                : "777",
  "referer"             : "-",
  "agent"               : "Opera/12.0",
  "http_x_forwarded_for": "-"
}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
