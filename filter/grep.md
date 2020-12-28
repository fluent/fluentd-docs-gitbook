# grep

The `filter_grep` filter plugin "greps" events by the values of specified fields.

It is included in the Fluentd's core.

## Example Configurations

```text
<filter foo.bar>
  @type grep

  <regexp>
    key message
    pattern /cool/
  </regexp>

  <regexp>
    key hostname
    pattern /^web\d+\.example\.com$/
  </regexp>

  <exclude>
    key message
    pattern /uncool/
  </exclude>
</filter>
```

The above example matches any event that satisfies the following conditions:

1. The value of the `message` field contains `cool`.
2. The value of the `hostname` field matches `web<INTEGER>.example.com`.
3. The value of the `message` field does NOT contain `uncool`.

Hence, the following events are kept:

```text
{"message":"It's cool outside today", "hostname":"web001.example.com"}
{"message":"That's not cool", "hostname":"web1337.example.com"}
```

whereas the following examples are filtered out:

```text
{"message":"I am cool but you are uncool", "hostname":"db001.example.com"}
{"hostname":"web001.example.com"}
{"message":"It's cool outside today"}
```

## Plugin Helpers

* [`record_accessor`](../plugin-helper-overview/api-plugin-helper-record_accessor.md)

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `<and>` Directive

Specifies the filtering rule. This directive contains either `<regexp>` or `<exclude>` directive. This directive has been added since 1.2.0.

```text
<and>
  <regexp>
    key price
    pattern /[1-9]\d*/
  </regexp>

  <regexp>
    key item_name
    pattern /^book_/
  </regexp>
</and>
```

This is same as below:

```text
<regexp>
  key price
  pattern /[1-9]\d*/
</regexp>

<regexp>
  key item_name
  pattern /^book_/
</regexp>
```

We can also use `<and>` directive with `<exclude>` directive:

```text
<and>
  <exclude>
    key container_name
    pattern /^app\d{2}/
  </exclude>

  <exclude>
    key log_level
    pattern /^(?:debug|trace)$/
  </exclude>
</and>
```

### `<or>` Directive

Specifies the filtering rule. This directive contains either `<regexp>` or `<exclude>` directive. This directive has been added since 1.2.0.

```text
<or>
  <exclude>
    key status_code
    pattern /^5\d\d$/
  </exclude>

  <exclude>
    key url
    pattern /\.css$/
  </exclude>
</or>
```

This is same as below:

```text
<exclude>
  key status_code
  pattern /^5\d\d$/
</exclude>

<exclude>
  key url
  pattern /\.css$/
</exclude>
```

We can also use `<or>` directive with `<regexp>` directive:

```text
<or>
  <regexp>
    key container_name
    pattern /^db\d{2}/
  </regexp>

  <regexp>
    key log_level
    pattern /^(?:warn|error)$/
  </regexp>
</or>
```

### `<regexp>` Directive

Specifies the filtering rule. This directive contains two parameters:

* `key`
* `pattern`

#### `key`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 1.0.0 |

The field name to which the regular expression is applied.

This parameter supports nested field access via [`record_accessor` syntax](../plugin-helper-overview/api-plugin-helper-record_accessor.md#syntax).

#### `pattern`

| type | default | version |
| :--- | :--- | :--- |
| regexp | required parameter | 1.2.0 |

The regular expression.

The pattern parameter is string type before 1.2.0.

For example, the following filters out events unless the field `price` is a positive integer.

```text
<regexp>
  key price
  pattern /[1-9]\d*/
</regexp>
```

The `grep` filter filters out UNLESS all `<regexp>`s are matched. Hence, if you have:

```text
<regexp>
  key price
  pattern /[1-9]\d*/
</regexp>

<regexp>
  key item_name
  pattern /^book_/
</regexp>
```

unless the event's `item_name` field starts with `book_` and the `price` field is an integer, it is filtered out.

For OR condition, you can use `|` operator of regular expressions. For example, if you have:

```text
<regexp>
  key item_name
  pattern /(^book_|^article)/
</regexp>
```

unless the event's `item_name` field starts with `book*` or `article*`, it is filtered out.

Note that if you want to use a match pattern with a leading slash \(a typical case is a file path\), you need to escape the leading slash. Otherwise, the pattern will not be recognized as expected.

Here is a simple example:

```text
<regexp>
  key filepath
  pattern \/spool/
</regexp>
```

You can also write the pattern like this:

```text
<regexp>
  key filepath
  pattern /\/spool\//
</regexp>
```

Learn regular expressions for more patterns.

### `regexpN`

| type | version |
| :--- | :--- |
| string | 1.0.0 |

This is a deprecated parameter. Use `<regexp>` instead.

The `N` at the end should be replaced with an integer between 1 and 20 \(e.g. `regexp1`\). `regexpN` takes two whitespace-delimited arguments.

Here is `regexpN` version of `<regexp>` example:

```text
regexp1 price [1-9]\d*
regexp2 item_name ^book_
```

### `<exclude>` Directive

Specifies the filtering rule to reject events. This directive contains two parameters:

* `key`
* `pattern`

#### `key`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 1.0.0 |

The field name to which the regular expression is applied.

This parameter supports nested field access via [`record_accessor` syntax](../plugin-helper-overview/api-plugin-helper-record_accessor.md#syntax).

#### `pattern`

| type | default | version |
| :--- | :--- | :--- |
| regexp | required parameter | 1.2.0 |

The regular expression.

The pattern parameter is string type before 1.2.0.

For example, the following filters out events whose `status_code` field is 5xx:

```text
<exclude>
  key status_code
  pattern /^5\d\d$/
</exclude>
```

The `grep` filter filters out if any `<exclude>` is matched. Hence, if you have:

```text
<exclude>
  key status_code
  pattern /^5\d\d$/
</exclude>

<exclude>
  key url
  pattern /\.css$/
</exclude>
```

Then, any event with `status_code` of `5xx` OR `url` ending with `.css` is filtered out.

### `excludeN`

| type | version |
| :--- | :--- |
| string | 1.0.0 |

This is a deprecated parameter. Use `<exclude>` instead.

The `N` at the end should be replaced with an integer between 1 and 20 \(e.g. `exclude1`\). `excludeN` takes two whitespace-delimited arguments.

Here is `excludeN` version of `<exclude>` example:

```text
exclude1 status_code ^5\d\d$
exclude2 url \.css$
```

If `<regexp>` and `<exclude>` are used together, both are applied.

## Learn More

* [Filter Plugin Overview](./)
* [`record_transformer` Filter Plugin](record_transformer.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

