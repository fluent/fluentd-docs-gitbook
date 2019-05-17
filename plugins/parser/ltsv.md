# LTSV Parser Plugin

The `ltsv` parser plugin parses [LTSV](http://ltsv.org/) format.


## Parameters

See [Parse section configurations](/configuration/parse-section.md)


### delimiter

| type   | default | version |
|:-------|:--------|:--------|
| string | "\\t"   | 0.14.0  |

The delimiter character (or string) of TSV values


### delimiter\_pattern

| type   | default | version |
|:-------|:--------|:--------|
| regexp | nil     | 1.2.0   |

The delimiter pattern of TSV values. This paramter overwrites
`delimiter` paramter if specified.

delimiter\_pattern is string type before 1.2.0.


### label\_delimiter

| type   | default | version |
|:-------|:--------|:--------|
| string | :       | 0.14.0  |

The delimiter character between field name and value


## Example for LTSV

```
time:2013/02/28 12:00:00\thost:192.168.0.1\treq_id:111\tuser:-
```

This incoming event is parsed as:

```
time:
1362020400 (2013/02/28/ 12:00:00)

record:
{
  "host"   : "192.168.0.1",
  "req_id" : "111",
  "user"   : "-"
}
```

If you set `null_value_pattern '-'` in the configuration, `user` field
becomes `nil` instead of `"-"`.


## Example with delimiter\_pattern

Incoming event:

```
timestamp=1362020400 host=192.168.0.1  req_id=111 user=-
```

Configuration to parse above incoming event:

```
<parse>
  @type ltsv
  delimiter_pattern /\s+/
  label_delimiter =
</parse>
```

The incoming event is parsed as:

```
record:
{
  "timestamp": "1362020400",
  "host"     : "192.168.0.1",
  "req_id"   : "111",
  "user"     : "-"
}
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
