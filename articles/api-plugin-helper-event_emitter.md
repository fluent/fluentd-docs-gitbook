# Event Emitter Plugin Helper API

`event_emitter` helper introduces `router` method to the plugin.

Here is the code example with `event_emitter` helper:

``` {.CodeRay}
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


### router

This method returns `Fluent::EventRouter` instance

Code example:

``` {.CodeRay}
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


## event\_emitter used plugins

-   All input plugins
-   All filter plugins
-   [Exec output](/articles/out_exec.md)
-   [Relabel output](/articles/out_relabel.md)
-   [Copy output](/articles/out_copy.md)
-   [Roundrobin output](/articles/out_roundrobin.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
