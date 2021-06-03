# Config: Inject Section

## Inject section overview

The **inject** section can be under `<match>` or `<filter>` section. It is enabled for the plugins that support injecting values to the event record.

```text
<match>
  @type file
  # ...
  <inject>
    # ...
  </inject>
</match>
```

### Example

Configuration:

```text
<inject>
  time_key fluentd_time
  time_type string
  time_format %Y-%m-%dT%H:%M:%S.%NZ
  tag_key fluentd_tag
</inject>
```

Event Record:

```text
tag: test
time: 1547575563.952259
record: {"message":"hello"}
```

Injected Record:

```text
{"message":"hello","fluentd_tag":"test","fluentd_time":"2019-01-15T18:06:03.952259000Z"}
```

## Inject Section Parameter

### Inject Parameters

* **`hostname_key`** \(string\) \(optional\): the field name to inject `hostname`
  * Default: `nil`
* **`hostname`** \(string\) \(optional\): hostname value
  * Default: `Socket.gethostname`
* **`worker_id_key`** \(string\) \(optional\): the field name to inject

  `worker_id`

  * Default: `nil`

* **`tag_key`** \(string\) \(optional\): the field name to inject `tag`
  * Default: `nil`
* **`time_key`** \(string\) \(optional\): the field name to inject `time`
  * Default: `nil`

### Time Parameters

* **`time_type`** \(enum\) \(optional\): parses/formats value according to this

  type

  * Default: `float`
  * Available values:
    * `float`: seconds from Epoch + microseconds \(e.g.

      1510544836.154709\)

    * `unixtime`: seconds from Epoch \(e.g. 1510544836\)
    * `unixtime_millis` \(since v1.11.4\): milliseconds from Epoch

      \(e.g. 1510544836154\)

    * `unixtime_micros` \(since v1.20.0\): microseconds from Epoch

      \(e.g. 1510544836154709\)

    * `unixtime_nanos` \(since v1.20.0\): nanoseconds from Epoch

      \(e.g. 1510544836154709804\)

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

