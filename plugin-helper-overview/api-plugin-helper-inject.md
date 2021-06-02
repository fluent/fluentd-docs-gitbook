# Plugin Helper: Inject

The `inject` plugin helper injects values into events according to the configuration.

Here is an example:

```ruby
require 'fluent/plugin/filter'

module Fluent::Plugin
  class ExampleFilter < Filter
    Fluent::Plugin.register_filter('example', self)

    # 1. Load inject helper
    helpers :inject

    # Omit `configure`, `shutdown` and other plugin APIs

    def filter(tag, time, record)
      # 2. Inject values into `record`
      new_record = inject_values_to_record(tag, time, record)
      # edit new_record ...
      new_record
    end
  end
end
```

For more details, see [Inject section](../configuration/inject-section.md).

## Methods

### `inject_values_to_record(tag, time, record)`

This method injects values to the given record and returns the new record.

* `tag`: the tag of the event
* `time`: event timestamp
* `record`: event record

Example:

```ruby
def filter(tag, time, record)
  new_record = inject_values_to_record(tag, time, record)
  # edit new_record ...
  new_record
end
```

### `inject_values_to_event_stream(tag, es)`

This method injects values into the given event stream and returns the new event stream.

* `tag`: the tag of the event
* `es`: event stream

Example:

```ruby
def process(tag, es)
  new_es = inject_values_to_event_stream(tag, es)
  # do something using new_es
end
```

## Plugins using `inject`

* [`filter_stdout`](../filter/stdout.md)
* [`out_exec`](../output/exec.md)
* [`out_exec_filter`](../output/exec_filter.md)
* [`out_file`](../output/file.md)
* [`out_stdout`](../output/stdout.md)

{% include "../.gitbook/assets/footer.txt" %}
