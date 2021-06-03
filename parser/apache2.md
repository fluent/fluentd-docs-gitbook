# apache2

The `apache2` parser plugin parses apache2 logs.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md)

## Regexp Patterns

Here is the regexp and time format patterns of this plugin:

```text
expression /^(?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>(?:[^\"]|\\.)*?)(?: +\S*)?)?" (?<code>[^ ]*) (?<size>[^ ]*)(?: "(?<referer>(?:[^\"]|\\.)*)" "(?<agent>(?:[^\"]|\\.)*)")?$/
time_format %d/%b/%Y:%H:%M:%S %z
```

`host`, `user`, `method`, `path`, `code`, `size`, `referer` and `agent` are included in the event record. `time` is used for the event time.

`code` and `size` fields are converted to integer type automatically. And, if the field value is `-`, it is interpreted as `nil`. See **Result Example**.

## Example

This incoming event

```text
192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777 "-" "Opera/12.0"
```

is parsed as:

```text
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

{% include "../.gitbook/assets/footer.txt" %}
