# multiline

The `multiline` parser plugin parses multiline logs. This plugin is the multiline version of `regexp` parser.

The `multiline` parser parses log with `formatN` and `format_firstline` parameters. `format_firstline` is for detecting the start line of the multiline log. `formatN`, where N's range is \[1..20\], is the list of Regexp format for multiline log.

Unlike other parser plugins, this plugin needs special code in input plugin e.g. handle `format_firstline`. So, currently, `in_tail` plugin works with `multiline` but other input plugins do not work with it.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

### `format_firstline`

Specifies the regexp pattern for the start line of multiple lines. Input plugin can skip the logs until `format_firstline` is matched. Default is `nil`.

If `format_firstline` is not specified, the input plugin should store the unmatched new lines in the temporary buffer and try to match the buffered logs with each new line.

### `formatN`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 0.14.0 |

It is a required parameter.

Specifies the regexp patterns. For readability, you can separate the regexp patterns into multiple `formatN` parameters. See the Rails Log's example below. These patterns are joined and then construct a regexp pattern with multiline mode.

## Example

### Rails Log

With this configuration:

```text
<parse>
  @type multiline
  format_firstline /^Started/
  format1 /Started (?<method>[^ ]+) "(?<path>[^"]+)" for (?<host>[^ ]+) at (?<time>[^ ]+ [^ ]+ [^ ]+)\n/
  format2 /Processing by (?<controller>[^\u0023]+)\u0023(?<controller_method>[^ ]+) as (?<format>[^ ]+?)\n/
  format3 /(  Parameters: (?<parameters>[^ ]+)\n)?/
  format4 /  Rendered (?<template>[^ ]+) within (?<layout>.+) \([\d\.]+ms\)\n/
  format5 /Completed (?<code>[^ ]+) [^ ]+ in (?<runtime>[\d\.]+)ms \(Views: (?<view_runtime>[\d\.]+)ms \| ActiveRecord: (?<ar_runtime>[\d\.]+)ms\)/
</parse>
```

This incoming event:

```text
Started GET "/users/123/" for 127.0.0.1 at 2013-06-14 12:00:11 +0900
Processing by UsersController#show as HTML
  Parameters: {"user_id"=>"123"}
  Rendered users/show.html.erb within layouts/application (0.3ms)
Completed 200 OK in 4ms (Views: 3.2ms | ActiveRecord: 0.0ms)
```

is parsed as:

```text
time:
1371178811 (2013-06-14 12:00:11 +0900)

record:
{
  "method"           :"GET",
  "path"             :"/users/123/",
  "host"             :"127.0.0.1",
  "controller"       :"UsersController",
  "controller_method":"show",
  "format"           :"HTML",
  "parameters"       :"{ \"user_id\":\"123\"}",
  ...
}
```

### Java Stacktrace Log

With this configuration:

```text
<parse>
  @type multiline
  format_firstline /\d{4}-\d{1,2}-\d{1,2}/
  format1 /^(?<time>\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}) \[(?<thread>.*)\] (?<level>[^\s]+)(?<message>.*)/
</parse>
```

These incoming events:

```text
2013-3-03 14:27:33 [main] INFO  Main - Start
2013-3-03 14:27:33 [main] ERROR Main - Exception
javax.management.RuntimeErrorException: null
    at Main.main(Main.java:16) ~[bin/:na]
2013-3-03 14:27:33 [main] INFO  Main - End
```

are parsed as:

```text
time:
2013-03-03 14:27:33 +0900
record:
{
  "thread" :"main",
  "level"  :"INFO",
  "message":"  Main - Start"
}

time:
2013-03-03 14:27:33 +0900
record:
{
  "thread" :"main",
  "level"  :"ERROR",
  "message":" Main - Exception\njavax.management.RuntimeErrorException: null\n    at Main.main(Main.java:16) ~[bin/:na]"
}

time:
2013-03-03 14:27:33 +0900
record:
{
  "thread" :"main",
  "level"  :"INFO",
  "message":"  Main - End"
}
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

