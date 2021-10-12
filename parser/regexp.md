# regexp

The `regexp` parser plugin parses logs by given regexp pattern. The regexp must have at least one named capture \(`?<NAME>`PATTERN\). If the regexp has a capture named `time`, this is configurable via `time_key` parameter, it is used as the time of the event. You can specify the time format using the `time_format` parameter.

```text
<parse>
  @type regexp
  expression /.../
</parse>
```

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md) for common parameters.

### `expression`

| type | default | version |
| :--- | :--- | :--- |
| regexp | required parameter | 1.2.0 |

Specifies the regular expression for matching logs. Regular expression also supports `i` and `m` suffix.

#### `i` \(ignorecase\)

Ignores case in matching.

```text
expression /.../i
```

#### `m` \(multiline\)

Build regular expression as a multiline mode. `.` matches the newline. See Ruby's [Regexp](https://ruby-doc.org/core-2.4.1/Regexp.html#class-Regexp-label-Options).

```text
expression /.../m
```

#### `both`

Specifies both `i` and `m`.

```text
expression /.../im
```

`expression` is the string type before 1.2.0.

### `ignorecase`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.2 |

Ignores case in matching. Use `i` option with expression.

Deprecated since 1.2.0. Use `expression /pattern/i` instead.

### `multiline`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.2 |

Builds regular expression in multiline mode. `.` matches the newline. See Ruby's [Regexp](https://ruby-doc.org/core-2.4.1/Regexp.html#class-Regexp-label-Options). Use `m` option with expression.

Deprecated since 1.2.0. Use `expression /pattern/m` instead.

## Example

With this configuration:

```text
<parse>
  @type regexp
  expression /^\[(?<logtime>[^\]]*)\] (?<name>[^ ]*) (?<title>[^ ]*) (?<id>\d*)$/
  time_key logtime
  time_format %Y-%m-%d %H:%M:%S %z
  types id:integer
</parse>
```

This incoming event:

```text
[2013-02-28 12:00:00 +0900] alice engineer 1
```

is parsed as:

```text
time:
1362020400 (2013-02-28 12:00:00 +0900)

record:
{
  "name" : "alice",
  "title": "engineer",
  "id"   : 1
}
```

## FAQ

### How to debug my regexp pattern?

[fluentd-ui's `in_tail` editor](../deployment/fluentd-ui.md#in_tail-setting) helps your regexp testing. Another way, [Fluentular](http://fluentular.herokuapp.com/) is a great website to test your regexp for Fluentd configuration.

NOTE: You may hit Application Error at Fluentular due to [heroku's free plan limitation](https://www.heroku.com/pricing). Retry a few hours later or use `fluentd-ui` instead.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
