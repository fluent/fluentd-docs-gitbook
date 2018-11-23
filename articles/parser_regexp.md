# regexp Parser Plugin

The `regexp` parser plugin parses logs by given regexp pattern. The
regexp must have at least one named capture (?\<NAME\>PATTERN). If the
regexp has a capture named `time`, this is configurable via `time_key`
parameter, it is used as the time of the event. You can specify the time
format using the time\_format parameter.

``` {.CodeRay}
<parse>
  @type regexp
  expression /.../
</parse>
```


## Parameters

See [Parse section configurations](/articles/parse-section.md) for common parameters.


### expression

    type         default         version
  -------- -------------------- ---------
   regexp   required parameter    1.2.0

Regular expression for matching logs.

expression is string type before 1.2.0.


### ignorecase

   type   default   version
  ------ --------- ---------
   bool    false    0.14.2

Ignore case in matching. Use `i` option with expression.

Deprecated since 1.2.0. Use `expression /pattern/i` instead.


### multiline

   type   default   version
  ------ --------- ---------
   bool    false    0.14.2

Build regular expression as a multline mode. `.` matches newline. See
[Ruby's Regexp
document](https://ruby-doc.org/core-2.4.1/Regexp.html#class-Regexp-label-Options)
Use `m` option with expression.

Deprecated since 1.2.0. Use `expression /pattern/m` instead.


## Example

``` {.CodeRay}
<parse>
  @type regexp
  expression /^\[(?<logtime>[^\]]*)\] (?<name>[^ ]*) (?<title>[^ ]*) (?<id>\d*)$/
  time_key logtime
  time_format %Y-%m-%d %H:%M:%S %z
  types id:integer
</parse>
```

With this config:

``` {.CodeRay}
[2013-02-28 12:00:00 +0900] alice engineer 1
```

This incoming log is parsed as:

``` {.CodeRay}
time:
1362020400 (22013-02-28 12:00:00 +0900)

record:
{
  "name" : "alice",
  "title": "engineer",
  "id"   : 1
}
```


## FAQ


### How to debug my regexp pattern?

[fluentd-ui's in\_tail editor](/articles/fluentd-ui.md/#intail-setting)
helps your regexp testing. Another way,
[Fluentular](http://fluentular.herokuapp.com/) is a great website to
test your regexp for Fluentd configuration.

NOTE: You may hit Application Error at Fluentular due to [heroku free plan limitation](https://www.heroku.com/pricing). Retry a few hours
later or use fluentd-ui instead.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
