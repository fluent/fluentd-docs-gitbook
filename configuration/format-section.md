# Config: Format Section

Some of the Fluentd plugins support the `<format>` section to specify how to format the record.

## Format Section Overview

The **format** section can be under `<match>` or `<filter>` section.

```text
<match tag.*>
  @type file
  # ...
  <format>
    # ...
  </format>
</match>
```

## Formatter Plugin Type

The `@type` parameter of `<format>` section specifies the type of the formatter plugin. Fluentd core bundles some useful [formatter plugins](../formatter/).

```text
<format>
  @type json
</format>
```

Here's the list of built-in formatter plugins:

* [`out_file`](../formatter/out_file.md)
* [`json`](../formatter/json.md)
* [`ltsv`](../formatter/ltsv.md)
* [`csv`](../formatter/csv.md)
* [`msgpack`](../formatter/msgpack.md)
* [`hash`](../formatter/hash.md)
* [`single_value`](../formatter/single_value.md)

Third-party plugins may also be installed and configured.

For more details, see plugins documentation.

## Parameters

### `@type`

The `@type` parameter specifies the type of the formatter plugin.

```text
<format>
  @type csv
  # ...
</format>
```

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

