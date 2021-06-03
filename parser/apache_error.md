# apache\_error

The `apache_error` parser plugin parses apache error logs.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

## Regexp patterns

This is regexp pattern of this plugin:

```text
expression /^\[[^ ]* (?<time>[^\]]*)\] \[(?<level>[^\]]*)\](?: \[pid (?<pid>[^\]]*)\])? \[client (?<client>[^\]]*)\] (?<message>.*)$/
```

`level`, `pid`, `client` and `message` are included in the event record. `time` is used for the event time.

## Example

This incoming event:

```text
[Wed Oct 11 14:32:52 2000] [error] [client 127.0.0.1] client denied by server configuration
```

is parsed as:

```text
time:
971242372 (Wed Oct 11 14:32:52 2000)

record:
{
  "level"  : "error",
  "client" : "127.0.0.1",
  "message": "client denied by server configuration"
}
```

{% include "../.gitbook/assets/footer.txt" %}
