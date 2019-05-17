# apache\_error Parser Plugin

The `apache_error` parser plugin parses apache error logs.


## Parameters

See [Parse section configurations](/configuration/parse-section.md)


## Regexp patterns

This is regexp pattern of this plugin:

```
expression /^\[[^ ]* (?<time>[^\]]*)\] \[(?<level>[^\]]*)\](?: \[pid (?<pid>[^\]]*)\])? \[client (?<client>[^\]]*)\] (?<message>.*)$/
```

`level`, `pid`, `client` and `message` are included in the event record.
`time` is used for the event time.


## Example

```
[Wed Oct 11 14:32:52 2000] [error] [client 127.0.0.1] client denied by server configuration
```

This incoming event is parsed as:

```
time:
971242372 (Wed Oct 11 14:32:52 2000)

record:
{
  "level"  : "error",
  "client" : "127.0.0.1",
  "message": "client denied by server configuration"
}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
