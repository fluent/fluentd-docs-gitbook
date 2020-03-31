# Record Accessor Plugin Helper API

`record_accessor` helper provides the unified access for event record.
`record_accessor` uses jsonpath like syntax for target field. With this
helper, you can easy to access/delete nested field in the plugin.

Here is the code example with `record_accessor` helper:

```
require 'fluent/plugin/filter'

module Fluent::Plugin
  class ExampleFilter < Filter
    Fluent::Plugin.register_filter('example', self)

    # 1. load record_accessor helper
    helpers :record_accessor

    def configure(conf)
      super

      # 2. call `record_accessor_create` to create object
      @accessor = record_accessor_create('$.user.name')
    end

    # omit super, shutdown and other plugin API

    def filter(tag, time, record)
      # 3. call `call` method to get value
      value = @accessor.call(record) # With `$.user.name`, access to record["user"]["name"]
      # ...
    end
  end
end
```


## Syntax

-   dot notation: `$.` started parameter. Chain fields by `.`

This is simple syntax. For example, `$.event.level` for
`record["event"]["level"]`, `$.key1[0].key2` for
`record["key1"][0]["key2"]`

-   bracket notation: `$[` started parameter. Chain fields by `[]`

Useful for special characters, `.`, white space and etc:
`$['dot.key'][0]['space key']` for `record["dot.key"][0]["space key"]`

If you set non `$.` or `$[` started value, e.g. `key log`, it is same as
`record["log"]`. So using `record_accessor` doesn't break existing
plugin behaviour.


## Methods


### record\_accessor\_create(param)

This method returns accessor object for event record. `param` is a
string and see "Syntax" section for supported syntax.

```
record_accessor_create("log")
record_accessor_create("$.key1.key2")
record_accessor_create("$['key1'][0]['key2']")
```

After create object, call `call`/`delete` method with record object.

```
accessor.call(record)   # get record field
accessor.delete(record) # delete record field
```


## record\_accessor used plugins

-   [grep filter](/plugins/filter/grep.md)
-   [parser filter](/plugins/filter/parser.md)
-   [record_transformer filter](/plugins/filter/record_transformer.md)

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
