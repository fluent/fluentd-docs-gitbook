# Inject Plugin Helper API

`inject` helper injects values to events according to the configuration.

For details about configuration, see [Inject section](/configuration/inject-section.md).

Here is the code example with `inject` helper:

```
require 'fluent/plugin/filter'

module Fluent::Plugin
  class ExampleFilter < Filter
    Fluent::Plugin.register_filter('example', self)

    # 1. load inject helper
    helpers :inject

    # omit configure, shutdown and other plugin API

    def filter(tag, time, record)
      # 2. inject values to record
      new_record = inject_values_to_record(tag, time, record)
      # edit new_record ...
      new_record
    end
  end
end
```

For more details about configuration, see [Inject section](/configuration/inject-section.md).


## Methods


### inject\_values\_to\_recort(tag, time, record)

This method injects values to given record and returns new record

-   `tag`: the tag of the event
-   `time`: event timestamp
-   `record`: event record

Code example:

```
def filter(tag, time, record)
  new_record = inject_values_to_record(tag, time, record)
  # edit new_record ...
  new_record
end
```


### inject\_values\_to\_event\_stream(tag, es)

This method injects values to given event stream and returns new event
stream

-   `tag`: the tag of the event
-   `es`: event stream

Code example:

```
def process(tag, es)
  new_es = inject_values_to_event_stream(tag, es)
  # do something using new_es
end
```


## inject used plugins

-   [Stdout filter](/plugins/filter/stdout.md)
-   [Exec output](/plugins/output/exec.md)
-   [Exec filter output](/plugins/output/exec_filter.md)
-   [File output](/plugins/output/file.md)
-   [Stdout output](/plugins/output/stdout.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
