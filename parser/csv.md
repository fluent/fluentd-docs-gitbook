# csv

The `csv` parser plugin parses CSV format.

## Parameters

See [Parse Section Configurations](../configuration/parse-section.md).

### `keys`

| type | default | version |
| :--- | :--- | :--- |
| array of string | required parameter | 0.14.9 |

The array of names for fields on each line.

### `delimiter`

| type | default | version |
| :--- | :--- | :--- |
| string | , | 0.14.2 |

The delimiter \(character or string\) separating CSV values.

### `parser_type`

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | normal | normal/fast | 1.7.0 |

The parser type used to parse the log line.

* `normal` uses Ruby's

  [`CSV.parse_line`](http://ruby-doc.org/stdlib-2.4.1/libdoc/csv/rdoc/CSV.html#method-c-parse_line)

  method.

* `fast` uses its own lightweight implementation. This parser is several times

  faster than `normal` but it supports only typical patterns.

Supported CSV formats by `fast`:

```text
# non-quoted
value1,value2,value3,value4,value5

# quoted
"value1","val,ue2","va,lu,e3","val ue4",""

# escaped
"message","mes""sage","""message""",,""""""

# mixed
message,"mes,sage","me,ssa,ge",mess age,""
```

If your CSV format is not matched with the above patterns, use `normal` parser instead.

## Example

With this configuration:

```text
<parse>
  @type csv
  keys time,host,req_id,user
  time_key time
</parse>
```

This incoming event:

```text
2013/02/28 12:00:00,192.168.0.1,111,-
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

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

