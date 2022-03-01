# Config: Parse Section

Some of the Fluentd plugins support the `<parse>` section to specify how to parse the raw data.

## Parse Section Overview

The **parse** section can be under `<source>`, `<match>` or `<filter>` section. It is enabled for the plugins that support parser plugin features.

```text
<source>
  @type tail
  # ...
  <parse>
    # ...
  </parse>
</source>
```

## Parser Plugin Type

The `@type` parameter of `<parse>` section specifies the type of the parser plugin. Fluentd core bundles some useful [parser plugins](../parser/).

```text
<parse>
  @type apache2
</parse>
```

Third-party plugins may also be installed and configured.

For more details, see plugins documentation.

## Parameters

### `@type`

The `@type` parameter specifies the type of the parser plugin.

```text
<parse>
  @type regexp
  # ...
</parse>
```

Here's the list of built-in parser plugins:

* [`regexp`](../parser/regexp.md)
* [`apache2`](../parser/apache2.md)
* [`apache_error`](../parser/apache_error.md)
* [`nginx`](../parser/nginx.md)
* [`syslog`](../parser/syslog.md)
* [`csv`](../parser/csv.md)
* [`tsv`](../parser/tsv.md)
* [`ltsv`](../parser/ltsv.md)
* [`json`](../parser/json.md)
* [`multiline`](../parser/multiline.md)
* [`none`](../parser/none.md)

### Parse Parameters

The default value of the following parameters will be overridden by the individual parser plugins:

* **`types`** \(hash\) \(optional\): Specify types for converting field into another

  type. See below "The detail of types parameter" section.

  * Default: `nil`
  * string-based hash: \`field1:type, field2:type, field3:type:option,

    field4:type:option\`

  * JSON format: \`{"field1":"type", "field2":"type", "field3":"type:option",

    "field4":"type:option"}\`

  * example: `types user_id:integer,paid:bool,paid_usd_amount:float`

* **`time_key`** \(string\) \(optional\): Specify time field for event time. If

  the event doesn't have this field, current time is used.

  * Default: `nil`
  * Note that [`json`](../parser/json.md),

    [`ltsv`](../parser/ltsv.md) and

    [`regexp`](../parser/regexp.md) override the default value of this

    parameter and set it to `time` by default.

* **`null_value_pattern`** \(regexp\) \(optional\): Specify null value pattern.
  * Default: `nil`
* **`null_empty_string`** \(bool\) \(optional\): If `true`, empty string field is

  replaced with `nil`.

  * Default: `false`

* **`estimate_current_event`** \(bool\) \(optional\): If `true`, use

  `Fluent::EventTime.now`\(current time\) as a timestamp when `time_key` is

  specified.

  * Default: `true`

* **`keep_time_key`** \(bool\) \(optional\): If `true`, keep time field in the

  record.

  * Default: `false`

* **`timeout`** \(time\) \(optional\): Specify timeout for `parse` processing. This

  is mainly for detecting wrong regexp pattern.

  * Default: `nil`    

#### `types` Parameter

For the `types` parameter, the following types are supported:

* `string`: Converts the field into `String` type. This uses `to_s` method for conversion.
* `bool`: Converts the string `"true"`, `"yes"` or `"1"` into `true`. Otherwise, `false`.
* `integer` \(not `int`\): Converts the field into the `Integer` type. This uses `to_i` method for conversion. For example, the string `"1000"` converts into `1000`.
* `float`: Converts the field into `Float` type. This uses `to_f` method for conversion. For example, the string `"7.45"` converts into `7.45`.
* `time`: Converts the field into `Fluent::EventTime` type. This uses Fluentd time parser for conversion. For the `time` type, the third field specifies the time format similar to `time_format`.

  ```text
    date:time:%d/%b/%Y:%H:%M:%S %z # for string with time format
    date:time:unixtime             # for integer time
    date:time:float                # for float time
  ```

  See `time_type` and `time_format` parameters in `Time parameters` section.

* `array`: Converts the string field into `Array` type. For the `array` type, the third field specifies the delimiter \(the default is comma `","`\). For example, if a field `item_ids` contains the value `"3,4,5"`, `types item_ids:array` parses it as `["3", "4", "5"]`. Alternatively, if the value is `"Adam|Alice|Bob"`, `types item_ids:array:|` parses it as `["Adam", "Alice", "Bob"]`.

### Time Parameters

* **`time_type`** \(enum\) \(optional\): parses/formats value according to this

  type

  * Default: `string`
  * Available values: `float`, `unixtime`, `string`, `mixed`
    * `float`: seconds from Epoch + nano seconds \(e.g.

      1510544836.154709804\)

    * `unixtime`: seconds from Epoch \(e.g. 1510544815\)
    * `string`: use format specified by `time_format`, local time or time

      zone

    * `mixed`: enable `time_format_fallbacks` option. \(Since Fluentd v1.12.2\)

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

* **`time_format_fallbacks`** \(\) \(optional\): uses the specified time format as a fallback in the specified order.

  You can parse undetermined time format by using `time_format_fallbacks`. This options is enabled when `time_type` is `mixed`.

  * Default: `nil`

  ```text
    time_type mixed
    time_format unixtime
    time_format_fallbacks %iso8601
  ```

  In the above use case, the timestamp is parsed as `unixtime` at first, if it fails, then it is parsed as `%iso8601` secondary. Note that `time_format_fallbacks` is the last resort to parse mixed timestamp format. There is a performance penalty \(Typically, N fallbacks are specified in `time_format_fallbacks` and if the last specified format is used as a fallback, N times slower in the worst case\).

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

