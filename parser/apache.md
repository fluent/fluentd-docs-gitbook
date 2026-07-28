# apache

The `apache` parser plugin parses the default Apache logs \(Common Log Format with the optional referer and user-agent fields\).

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

## Regexp Patterns

Here is the regexp and time format patterns of this plugin:

```text
expression /^(?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^ ]*) +\S*)?" (?<code>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>[^\"]*)" "(?<agent>[^\"]*)")?$/
time_format %d/%b/%Y:%H:%M:%S %z
```

`host`, `user`, `method`, `path`, `code`, `size`, `referer` and `agent` are included in the event record. `time` is used for the event time.

This plugin is a [`regexp`](regexp.md) parser with the above defaults, so every field is kept as a string and a `-` value is kept as it is.

## Difference from `apache2`

The [`apache2`](apache2.md) parser accepts a wider range of lines: its `path` may contain spaces, the protocol token after the path is optional, and `path`, `referer` and `agent` may contain escaped double quotes. It also converts `code` and `size` into the integer type and interprets the `-` value as `nil`. The `apache` parser does none of these: it requires the protocol token, does not allow a space in `path`, and returns all the fields as a string.

## Example

This incoming event:

```text
192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777 "-" "Opera/12.0"
```

is parsed as:

```text
time:
1362020400 (28/Feb/2013:12:00:00 +0900)

record:
{
  "host"   : "192.168.0.1",
  "user"   : "-",
  "method" : "GET",
  "path"   : "/",
  "code"   : "200",
  "size"   : "777",
  "referer": "-",
  "agent"  : "Opera/12.0"
}
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](https://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

