# nginx

The `nginx` parser plugin parses the default Nginx logs.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

## Regexp Patterns

Here is the regexp and time format patterns of this plugin:

```text
expression /^(?<remote>[^ ]*) (?<host>[^ ]*) (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^\"]*?)(?: +\S*)?)?" (?<code>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)"(?:\s+(?<http_x_forwarded_for>[^ ]+))?)?$/
time_format %d/%b/%Y:%H:%M:%S %z
```

`remote`, `user`, `method`, `path`, `code`, `size`, `referer`, `agent` and `http_x_forwarded_for` are included in the event record. `time` is used for the event time.

## Example

This incoming event:

```text
127.0.0.1 192.168.0.1 - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777 "-" "Opera/12.0" -
```

is parsed as:

```text
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

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

