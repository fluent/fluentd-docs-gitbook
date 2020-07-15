# `parser` Filter Plugin

The `parser` filter plugin "parses" string field in event records and mutates
its event record with parsed result.

It is included in the Fluentd's core.


## Example Configurations

```
<filter foo.bar>
  @type parser
  key_name log
  <parse>
    @type regexp
    expression /^(?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] "(?<method>\S+)(?: +(?<path>[^ ]*) +\S*)?" (?<code>[^ ]*) (?<size>[^ ]*)$/
    time_format %d/%b/%Y:%H:%M:%S %z
  </parse>
</filter>
```

`filter_parser` uses built-in parser plugins and your own customized parser
plugin, so you can reuse the predefined formats like `apache2`, `json`, etc. See
[Parser Plugin Overview](/plugins/parser/README.md) for more details

With this example, if you receive this event:

```
time:
injected time (depends on your input)
record:
{"log":"192.168.0.1 - - [05/Feb/2018:12:00:00 +0900] \"GET / HTTP/1.1\" 200 777"}
```

The parsed result will be:

```
time
05/Feb/2018:12:00:00 +0900
record:
{"host":"192.168.0.1","user":"-","method":"GET","path":"/","code":"200","size":"777"}
```


## Plugin Helpers

-   [`parser`](/developer/api-plugin-helper-parser.md)
-   [`record_accessor`](/developer/api-plugin-helper-record_accessor.md)
-   [`compat_parameters`](/developer/api-plugin-helper-compat_parameters.md)


## Parameters

See [Common Parameters](/configuration/plugin-common-parameters.md).


### `<parse>` Section

This is a required subsection. Specifies the parser type and related parameter.

For more details, see [Parse Section
Configurations](/configuration/parse-section.md).


### `key_name`

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.9  |

Specifies the field name in the record to parse.

This parameter supports nested field access via [`record_accessor`
syntax](/developer/api-plugin-helper-record_accessor.md/#syntax).


### `reserve_time`

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.9  |

Keeps the original event time in the parsed result.


### `reserve_data`

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.9  |

Keeps the original key-value pair in the parsed result.

```
<filter foo.bar>
  @type parser
  key_name log
  reserve_data true
  <parse>
    @type json
  </parse>
</filter>
```

With above configuration, here is the result:

```
# input data:  {"key":"value","log":"{\"user\":1,\"num\":2}"}
# output data: {"key":"value","log":"{\"user\":1,\"num\":2}","user":1,"num":2}
```

Without `reserve_data`, the result is:

```
# input data:  {"key":"value","log":"{\"user\":1,\"num\":2}"}
# output data: {"user":1,"num":2}
```


### remove\_key\_name\_field

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 1.2.2   |

Removes `key_name` field when parsing is succeeded.

```
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

With above configuration, here is the result:

```
# input data:  {"key":"value","log":"{\"user\":1,\"num\":2}"}
# output data: {"key":"value","user":1,"num":2}
```


### `replace_invalid_sequence`

| type | default | version |
|:-----|:--------|:--------||bool | false   | 0.14.9  |

If `true`, invalid string is replaced with safe characters and re-parse it.


### `inject_key_prefix`

| type   | default | version |
|:-------|:--------|:--------|
| string | false   | 0.14.9  |

Stores the parsed values with the specified key name prefix.

```
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

With above configuration, here is the result:

```
# input data:  {"log": "{\"user\":1,\"num\":2}"}
# output data: {"log":"{\"user\":1,\"num\":2}","data.user":1, "data.num":2}
```


### `hash_value_field`

| type   | default | version |
|:-------|:--------|:--------|
| string | false   | 0.14.9  |

Stores the parsed values as a hash value in a field.

```
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

```
# input data:  {"log": "{\"user\":1,\"num\":2}"}
# output data: {"parsed":{"user":1,"num":2}}
```


### `emit_invalid_record_to_error`

| type | default | version |
|:-----|:--------|:--------|
| bool | true    | 0.14.0  |

Emits invalid record to `@ERROR` label. Invalid cases are:

-   key not exist
-   format is not matched
-   unexpected error

You can rescue unexpected format logs in `@ERROR` label.

If you want to ignore these errors, set `false`.


## FAQ


### `suppress_parse_error_log` is missing. What are the alternatives?

Since v1, `parser` filter does not support `suppress_parse_error_log`
parameter because `parser` filter uses `@ERROR` feature instead of
internal logging to rescue invalid records. If you want to simply
ignore invalid records, set `emit_invalid_record_to_error false`.

See also `emit_invalid_record_to_error` parameter.


## Learn More

-   [Filter Plugin Overview](/plugins/filter/README.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
