# ltsv

The `ltsv` parser plugin parses [LTSV](http://ltsv.org/) format.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

### `delimiter`

| type | default | version |
| :--- | :--- | :--- |
| string | `\t` | 0.14.0 |

The delimiter \(character or string\) separating LTSV values.

### `delimiter_pattern`

| type | default | version |
| :--- | :--- | :--- |
| regexp | nil | 1.2.0 |

The delimiter pattern of TSV values. This parameter overwrites `delimiter` parameter if specified.

`delimiter_pattern` is string type before 1.2.0.

### `label_delimiter`

| type | default | version |
| :--- | :--- | :--- |
| string | : | 0.14.0 |

The delimiter character between field name and value.

## Example for LTSV

This incoming event:

```text
time:2013/02/28 12:00:00\thost:192.168.0.1\treq_id:111\tuser:-
```

is parsed as:

```text
time:
1362020400 (2013/02/28/ 12:00:00)

record:
{
  "host"   : "192.168.0.1",
  "req_id" : "111",
  "user"   : "-"
}
```

If you set `null_value_pattern '-'` in the configuration, `user` field becomes `nil` instead of `"-"`.

## Example with `delimiter_pattern`

With this configuration:

```text
<parse>
  @type ltsv
  delimiter_pattern /\s+/
  label_delimiter =
</parse>
```

This incoming event:

```text
timestamp=1362020400 host=192.168.0.1  req_id=111 user=-
```

is parsed as:

```text
record:
{
  "timestamp": "1362020400",
  "host"     : "192.168.0.1",
  "req_id"   : "111",
  "user"     : "-"
}
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

