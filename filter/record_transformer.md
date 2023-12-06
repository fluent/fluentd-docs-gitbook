# record\_transformer

The `filter_record_transformer` filter plugin mutates/transforms incoming event streams in a versatile manner. If there is a need to add/delete/modify events, this plugin is the first filter to try.

It is included in the Fluentd's core.

## Example Configurations

```text
<filter foo.bar>
  @type record_transformer
  <record>
    hostname "#{Socket.gethostname}"
    tag ${tag}
  </record>
</filter>
```

The above filter adds the new field `hostname` with the server's hostname as its value \(It is taking advantage of Ruby's string interpolation\) and the new field `tag` with tag value.

So, an input like:

```text
{"message":"hello world!"}
```

is transformed into

```text
{"message":"hello world!", "hostname":"db001.internal.example.com", "tag":"foo.bar"}
```

Here is another example where the field `total` is divided by the field `count` to create a new field `avg`:

```text
<filter foo.bar>
  @type record_transformer
  enable_ruby
  <record>
    avg ${record["total"] / record["count"]}
  </record>
</filter>
```

It transforms an event like

```text
{"total":100, "count":10}
```

into

```text
{"total":100, "count":10, "avg":"10"}
```

With the `enable_ruby` option, an arbitrary Ruby expression can be used inside `${...}`. Note that the `avg` field is typed as a string in this example. You may use `auto_typecast true` option to treat the field as a float.

You can also use this plugin to modify your existing fields as:

```text
<filter foo.bar>
  @type record_transformer
  <record>
    message yay, ${record["message"]}
  </record>
</filter>
```

An input like

```text
{"message":"hello world!"}
```

is transformed into

```text
{"message":"yay, hello world!"}
```

Finally, this configuration embeds the value of the second part of the tag in the field `service_name`. It might come in handy when aggregating data across many services.

```text
<filter web.*>
  @type record_transformer
  <record>
    service_name ${tag_parts[1]}
  </record>
</filter>
```

So, if an event with the tag `web.auth` and record `{"user_id":1, "status":"ok"}` comes in, it transforms it into `{"user_id":1, "status":"ok", "service_name":"auth"}`.

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

### `@type`

The value must be `record_transformer`.

### `<record>` directive

The parameters inside `<record>` directives are considered to be new key-value pairs:

```text
<record>
  NEW_FIELD NEW_VALUE
</record>
```

For `NEW_FIELD` and `NEW_VALUE`, a special syntax `${}` allows the user to generate a new field dynamically. Inside the curly braces, the following variables are available:

* The incoming event's existing values can be referred by their field

  names. So, if the record is `{"total":100, "count":10}`, then

  `record["total"]=100` and `record["count"]=10`.

* `tag` refers to the whole tag.
* `time` refers to stringified event time.
* `hostname` refers to the machine's hostname. The actual value is the result of

  [`Socket.gethostname`](https://docs.ruby-lang.org/en/trunk/Socket.html#method-c-gethostname).

You can also access to a certain portion of a tag using the following notations:

* `tag_parts[N]` refers to the `Nth` part of the tag.
* `tag_prefix[N]` refers to the `[0..N]` part of the tag.
* `tag_suffix[N]` refers to the `[N..]` part of the tag.

All indices are zero-based. For example, if you have an incoming event tagged `debug.my.app`, then `tag_parts[1]` will represent `my`. Also in this case, `tag_prefix[N]` and `tag_suffix[N]` will work as follows:

```text
tag_prefix[0] = debug          tag_suffix[0] = debug.my.app
tag_prefix[1] = debug.my       tag_suffix[1] = my.app
tag_prefix[2] = debug.my.app   tag_suffix[2] = app
```

### `enable_ruby`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

When set to `true`, the full Ruby syntax is enabled in the `${...}` expression. The default value is `false`.

With `true`, additional variables could be used inside `${}`:

* `record` refers to the whole record.
* `time` refers to event time as Time object, not stringified event time.

Here is an example:

```text
jsonized_record ${record.to_json}
avg ${record["total"] / record["count"]}
formatted_time ${time.strftime('%Y-%m-%dT%H:%M:%S%z')}
escaped_tag ${tag.gsub('.', '-')}
last_tag ${tag_parts.last}
foo_${record["key"]} bar_${record["value"]}
nested_value ${record["payload"]["key"]}
```

By historical reason, `enable_ruby true` is too slow. If you need this option, consider `record_modifier` filter instead. See also `Need more performance?` section.

### `auto_typecast`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

Automatically casts the field types. Default is `false`.

LIMITATION: This option is effective only for field values comprised of a single placeholder.

Effective examples:

```text
foo ${record["foo"]}
```

Non-Effective examples:

```text
foo ${record["foo"]}${record["bar"]}
foo ${record["foo"]}bar
foo 1
```

Internally, this keeps the original value type only when a single placeholder is used.

### `renew_record`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

By default, the record transformer filter mutates the incoming data. However, if this parameter is set to `true`, it modifies a new empty hash instead.

### `renew_time_key`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.0 |

`renew_time_key foo` overwrites the time of events with a value of the record field `foo` if exists. The value of `foo` must be a Unix timestamp.

### `keep_keys`

| type | default | version |
| :--- | :--- | :--- |
| array | nil | 0.14.0 |

A list of keys to keep. Only relevant if `renew_record` is set to `true`.

`keep_keys` has been supported since 0.14.0.

### `remove_keys`

| type | default | version |
| :--- | :--- | :--- |
| array | nil | 0.14.0 |

A list of keys to delete.

This parameter supports nested field via [record\_accessor syntax](../plugin-helper-overview/api-plugin-helper-record_accessor.md#syntax) since v1.1.0.

Example:

Given the configuration:

```text
<filter foo.bar>
  @type record_transformer
  remove_keys hostname,$.kubernetes.pod_id
</filter>
```

And a message:

```text
{
  "hostname":"db001.internal.example.com",
  "kubernetes":{
    "pod_name":"mypod-8f6bb798b-xxddw",
    "pod_id":"b1187408-729a-11ea-9a13-fa163e3bcef1"
  }
}
```

The output would be:

```text
{
  "kubernetes":{
    "pod_name":"mypod-8f6bb798b-xxddw"
  }
}
```

## Need more performance?

[`filter_record_modifier`](https://github.com/repeatedly/fluent-plugin-record-modifier) is lightweight and faster version of `filter_record_transformer`. `filter_record_modifier` does not provide several `filter_record_transformer` features, but it covers popular cases. If you need better performance for mutating records, consider `filter_record_modifier` instead.

## Tips

### Use `dig` Method for Nested Field

Users sometimes need to access a nested field. In this case, you can use `[]` to create a chain like this:

```text
${record["top"]["nest1"]["nest2"]}
```

But, this approach has a problem. When `record["top"]` or `record["top"]["nest1"]` does not exist, you hit an unexpected error.

Here is the log example:

```text
error_class=RuntimeError error="failed to expand `record[\"top\"][\"nest1\"][\"nest2\"]` : error = undefined method `[]' for nil:NilClass
```

`dig` method resolves this problem. If field is not found, it returns `nil` instead of raising error:

```text
${record.dig("top", "nest1", "nest2")}
```

## FAQ

### What are the differences between `${record["key"]}` and `${key}`?

`${key}` was a shortcut for `${record["key"]}`. This is error-prone because `${tag}` is unclear, event tag or `record["tag"]`. So the `${key}` syntax was removed since v0.14. v0.12 still supports `${key}` but it is not recommended.

### I got `unknown placeholder ${record['msg']} found` error, why?

Without `enable_ruby`, `${}` placeholder supports only double-quoted string for record field access. So, use `${record["key"]}` instead of `${record['key']}`. This could also happen when the input does not contain `key`.

## Learn More

* [Filter Plugin Overview](./)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

