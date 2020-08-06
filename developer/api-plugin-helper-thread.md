# Thread Plugin Helper API

The `thread` plugin helper manages threads and these threads are integrated with
plugins. No need manual run or shutdown in the plugin.

Here is an example:

```rb
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. Load thread helper
    helpers :thread

    # Omit `configure`, `shutdown` and other plugin APIs

    def start
      super

      # 2. Create and run thread with unique name.
      thread_create(:example_thread_run, &method(:run))
    end

    def run
      # ...
    end
  end
end
```

The launched thread is managed by the plugin helper. No need of thread shutdown
code in plugin's `shutdown` method. It shutdowns the launched threads
automatically.


## Methods


### `thread_create(title)`

This method creates thread and run thread with the given routine.

`title` must be unique.

```rb
# Pass block directly
thread_create(:example_plugin_main) {
  # ...
}

# Pass method object with existing method
thread_create(:foo_plugin_body, &method(:run))
def run
  # ...
end
```


### `thread_current_running?`

Checks whether the current thread is running or not. This method is available in
the running block.

```rb
thread_create(:example_plugin_main) {
  while thread_current_running?
    # ...
  end
}
```


## Plugins using `thread`

-   [`out_forward`](/plugins/output/forward.md)
-   [`in_monitor_agent`](/plugins/input/monitor_agent.md)
-   [`in_sample`](/plugins/input/sample.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under
[Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are
available under the Apache 2 License.