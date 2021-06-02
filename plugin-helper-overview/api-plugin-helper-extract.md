# Plugin Helper: Extract

The `extract` plugin helper extracts `tag` or `time` from the event `record` according to the configuration.

Here is an example:

```ruby
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput > Output
    Fluent::Plugin.register_output('Example')

    def process(tag, es)
      es.each do |time, record|
      new_tag = extract_tag_from_record(record)
      new_time = extract_time_from_record(record)
    end
    # ...
  end
end
```

For more details, see [Extract section](../configuration/extract-section.md).

## Methods

### `extract_tag_from_record(record)`

This method extracts `tag` from the given record.

* `record`: event record

Example:

```ruby
new_tag = extract_tag_from_record(record)
```

### `extract_time_from_record(record)`

This method extracts `time` from the given record.

* `record`: event record

Example:

```ruby
new_time = extract_time_from_record(record)
```

## Plugins using `extract`

* [`in_exec`](../input/exec.md)
* [`in_tcp`](../input/tcp.md)
* [`in_udp`](../input/udp.md)
* [`out_exec_filter`](../output/exec_filter.md)

{% include "../.gitbook/assets/footer.txt" %}
