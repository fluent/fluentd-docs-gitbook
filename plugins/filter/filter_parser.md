# parser Filter Plugin

The `filter_parser` filter plugin "parses" string field in event records
and mutates its event record with parsed result.


## Example Configurations

`filter_parser` is included in Fluentd's core. No installation required.

``` {.CodeRay}
<filter foo.bar>
  @type parser
  key_name message
  <parse>
    @type regexp
    expression /^(?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^ ]*) +\S*)?" (?<code>[^ ]*) (?<size>[^ ]*)$/
    time_format %d/%b/%Y:%H:%M:%S %z
  </parse>
</filter>
```

`filter_parser` uses built-in parser plugins and your own customized
parser plugin, so you can re-use pre-defined format like `apache`,
`json` and etc. See document page for more details: [Parser Plugin Overview](/articles/parser-plugin-overview.md)


## Plugin helpers

-   [parser](/articles/api-plugin-helper-parser.md)
-   [record\_accessor](/articles/api-plugin-helper-record_accessor.md)
-   [compat\_parameters](/articles/api-plugin-helper-compat_parameters.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

[]{#<parse>-section}

### \<parse\> section

This is required sub section. Specify parser type and related parameter.

For more details, see [Parse section configurations](/configuration/parse-section.md).


### key\_name

    type         default         version
  -------- -------------------- ---------
   string   required parameter   0.14.9

Specify field name in the record to parse.

This parameter supports nested field access via [record\_accessor syntax](/articles/api-plugin-helper-record_accessor.md/#syntax).


### reserve\_time

   type   default   version
  ------ --------- ---------
   bool    false    0.14.9

Keep original event time in parsed result.


### reserve\_data

   type   default   version
  ------ --------- ---------
   bool    false    0.14.9

Keep original key-value pair in parsed result.

``` {.CodeRay}
<filter foo.bar>
  @type parser
  key_name log
  reserve_data true
  <parse>
    @type json
  </parse>
</filter>
```

With above configuration, result is below:

``` {.CodeRay}
# input data:  {"key":"value","log":"{\"user\":1,\"num\":2}"}
# output data: {"key":"value","log":"{\"user\":1,\"num\":2}","user":1,"num":2}
```

Without `reserve_data`, result is below

``` {.CodeRay}
# input data:  {"key":"value","log":"{\"user\":1,\"num\":2}"}
# output data: {"user":1,"num":2}
```


### remove\_key\_name\_field

   type   default   version
  ------ --------- ---------
   bool    false     1.2.2

Remove `key_name` field when parsing is succeeded.

``` {.CodeRay}
<filter foo.bar>
  @type parser
  key_name log
  reserve_data true
  remove_key_name_field true
  <parse>
    @type json
  </parse>
</filter>
```

With above configuration, result is below:

``` {.CodeRay}
# input data:  {"key":"value","log":"{\"user\":1,\"num\":2}"}
# output data: {"key":"value","user":1,"num":2}
```


### replace\_invalid\_sequence

   type   default   version
  ------ --------- ---------
   bool    false    0.14.9

If `true`, invalid string is replaced with safe characters and re-parse
it.


### inject\_key\_prefix

    type    default   version
  -------- --------- ---------
   string    false    0.14.9

Store parsed values with specified key name prefix.

``` {.CodeRay}
<filter foo.bar>
  @type parser
  key_name log
  reserve_data true
  inject_key_prefix data.
  <parse>
    @type json
  </parse>
</filter>
```

With above configuration, result is below:

``` {.CodeRay}
# input data:  {"log": "{\"user\":1,\"num\":2}"}
# output data: {"log":"{\"user\":1,\"num\":2}","data.user":1, "data.num":2}
```


### hash\_value\_field

    type    default   version
  -------- --------- ---------
   string    false    0.14.9

Store parsed values as a hash value in a field.

``` {.CodeRay}
<filter foo.bar>
  @type parser
  key_name log
  hash_value_field parsed
  <parse>
    @type json
  </parse>
</filter>
```

With above configuration, result is below:

``` {.CodeRay}
# input data:  {"log": "{\"user\":1,\"num\":2}"}
# output data: {"parsed":{"user":1,"num":2}}
```


### emit\_invalid\_record\_to\_error

   type   default   version
  ------ --------- ---------
   bool    true     0.14.0

Emit invalid record to `@ERROR` label. Invalid cases are

-   key not exist
-   format is not matched
-   unexpected error

You can rescue unexpected format logs in `@ERROR` label.

In v1.0, `emit_invalid_record_to_error` is `true` by default unlike
v0.12.


## Learn More

-   [Filter Plugin Overview](/plugins/filter/filter-plugin-overview.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
