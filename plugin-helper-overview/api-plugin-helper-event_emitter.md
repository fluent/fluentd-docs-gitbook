# Plugin Helper: Event Emitter

The `event_emitter` plugin helper introduces the `router` method to the plugin.

Here is an example:

```ruby
require 'fluent/plugin/output'

module Fluent::Plugin
  class RelabelOutput < Output
    Fluent::Plugin.register_output('relabel', self)
    helpers :event_emitter

    def multi_workers_ready?
      true
    end

    def process(tag, es)
      router.emit_stream(tag, es)
    end
  end
end
```

## Methods

### `router`

This method returns a `Fluent::EventRouter` instance.

Code example:

```ruby
# emit event
router.emit(tag, time, record)

# emit event stream
router.emit_stream(tag, es)

# emit error event
begin
  # do something
rescue => error
  # Route event to @ERROR label or
  # log error message when @ERROR label is not defined in configuration
  router.emit_error_event(tag, time, record, error)
end
```

## Plugins using `event_emitter`

* All input plugins
* All filter plugins
* [`out_exec`](../output/exec.md)
* [`out_relabel`](../output/relabel.md)
* [`out_copy`](../output/copy.md)
* [`out_roundrobin`](../output/roundrobin.md)

{% include "../.gitbook/assets/footer.txt" %}
