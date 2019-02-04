# TSV Parser Plugin

The `tsv` parser plugin parses TSV format.


## Parameters

See [Parse section configurations](/configuration/parse-section.md)


### keys

|	        type |             default |        version	|
|-----------------|--------------------|---------|
|	   array of string   required parameter   0.14.9

Names of fields included in each lines.


### delimiter

|	    type |   default |  version	|
|--------|---------|---------|
|	   string    "\\t"    0.14.0

The delimiter character (or string) of TSV values.


## Example

``` {.CodeRay}
<parse>
  @type tsv
  keys time,host,req_id,user
  time_key time
</parse>
```

With this configuration:

``` {.CodeRay}
2013/02/28 12:00:00\t192.168.0.1\t111\t-
```

This incoming event is parsed as:

``` {.CodeRay}
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


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
