# Config: Extract Section

## Extract Section Overview

The **extract** section can be under `<match>`, `<source>`, or `<filter>` sections. It is enabled for the plugins that support extracting values from the event record e.g. `exec`.

```text
<source>
  @type exec
  # ...
  <extract>
    # ...
  </extract>
</source>
```

## Extract Section Parameter

### Extract Parameters

* **`tag_key`** \(string\) \(optional\): the field name to extract `tag`
  * Default: `nil`
* **`keep_tag_key`** \(bool\) \(optional\): if `true`, keeps the field in the

  record after extracting its value

  * Default: `false`

* **`time_key`** \(string\) \(optional\): the field name to extract the time
  * Default: `nil`
* **`keep_time_key`** \(bool\) \(optional\): if `true`, keeps the field in the

  record after extracting its value

  * Default: `false`

### Time Parameters

* **`time_type`** \(enum\) \(optional\): parses/formats value according to this

  type

  * Default: `float`
  * Available values: `float`, `unixtime`, `string`
    * `float`: seconds from Epoch + nano seconds \(e.g.

      1510544836.154709804\)

    * `unixtime`: seconds from Epoch \(e.g. 1510544815\)
    * `string`: use format specified by `time_format`, local time or time

      zone

* **`time_format`** \(string\) \(optional\): processes value according to the

  specified format. This is available only when `time_type` is `string`.

  * Default: `nil`
  * Available time format:
    * For more details about formatting, see

      [`Time#strftime`](https://docs.ruby-lang.org/en/2.4.0/Time.html#method-i-strftime).

    * For more details about parsing, see

      [`Time.strptime`](https://docs.ruby-lang.org/en/2.4.0/Time.html#method-c-strptime).

    * `%iso8601` \(only for parsing\)
    * Use `%N` to parse/format with sub-second precision, because

      [`strptime`](https://github.com/nurse/strptime) does not support

      `%3N`, `%6N`, `%9N`, and `%L`.

* **`localtime`** \(bool\) \(optional\): if `true`, uses local time. Otherwise,

  UTC is used. This is exclusive with `utc`.

  * Default: `true`

* **`utc`** \(bool\) \(optional\): if `true`, uses UTC. Otherwise, local time is

  used. This is exclusive with `localtime`.

  * Default: `false`

* **`timezone`** \(string\) \(optional\): uses the specified timezone. One can

  parse/format the time value in the specified timezone format.

  * Default: `nil`
  * Available time zone format:
    1. `[+-]HH:MM` \(e.g. "+09:00"\) **\(recommended\)**
    2. `[+-]HHMM` \(e.g. "+0900"\)
    3. `[+-]HH` \(e.g. "+09"\)
    4. Region/Zone \(e.g. `Asia/Tokyo`\)
    5. Region/Zone/Zone \(e.g. `America/Argentina/Buenos_Aires`\)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

