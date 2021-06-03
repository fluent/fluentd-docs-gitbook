# Plugin Helper: Record Accessor

The `record_accessor` plugin helper provides unified access to the event record. It uses `jsonpath` like syntax for the target field. With this helper, you can easily access/delete a nested field in the plugin.

Here is an example:

```ruby
require 'fluent/plugin/filter'

module Fluent::Plugin
  class ExampleFilter < Filter
    Fluent::Plugin.register_filter('example', self)

    # 1. Load record_accessor helper
    helpers :record_accessor

    def configure(conf)
      super

      # 2. Call `record_accessor_create` to create object
      @accessor = record_accessor_create('$.user.name')
    end

    # Omit `super`, `shutdown` and other plugin APIs

    def filter(tag, time, record)
      # 3. Call `call` method to get value
      value = @accessor.call(record) # With `$.user.name`, access to record["user"]["name"]
      # ...
    end
  end
end
```

## Syntax

* dot notation: `$.` is the starting parameter. Chain fields with dots `.`.

For example:

`$.event.level` for `record["event"]["level"]`

`$.key1[0].key2` for `record["key1"][0]["key2"]`

* bracket notation: `$[` starting parameter. Chain fields with `[]`.

Useful for special characters, `.`, whitespace, etc.

`$['dot.key'][0]['space key']` for `record["dot.key"][0]["space key"]`

If you set non `$.` or `$[` starting value, e.g. `key log`, it is the same as `record["log"]`. So, using `record_accessor` does not break the existing plugin behavior.

## Methods

### `record_accessor_create(param)`

This method returns the accessor object of the event record.

The `param` is a `String`.

See the "Syntax" section for more details.

```ruby
record_accessor_create("log")
record_accessor_create("$.key1.key2")
record_accessor_create("$['key1'][0]['key2']")
```

After creating an object, call `call`/`delete`/`set` method with the record object.

```ruby
accessor.call(record)       # get record field
accessor.delete(record)     # delete record field
accessor.set(record, value) # set new value to record field
```

NOTE: `set` method is supported since v1.10.3

## Plugins using `record_accessor`

* [`filter_grep`](../filter/grep.md)
* [`filter_parser`](../filter/parser.md)
* [`filter_record_transformer`](../filter/record_transformer.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

