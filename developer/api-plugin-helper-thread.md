# Thread Plugin Helper API

`thread` helper manages threads and these threads are integrated with
plugins. No need manual run / shutdown in the plugin.

Here is the code example with `thread` helper:

```
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. load thread helper
    helpers :thread

    # omit configure, shutdown and other plugin API

    def start
      super

      # 2. create and run thread with unique name.
      thread_create(:example_thread_run, &method(:run))
    end

    def run
      # ...
    end
  end
end
```

Launched thread is managed by the plugin. No need thread shutdown code
in plugin's `shutdown`. The plugin shutdowns launched threads
automatically.


## Methods


### thread\_create(title)

This method creats thread and run thread with given routine. `title`
must be unique.

```
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


### thread\_current\_running?

Check current thread is running or not. This method is available in
running block.

```
thread_create(:example_plugin_main) {
  while thread_current_running?
    # ...
  end
}
```


## thread used plugins

-   [Forward output](/plugins/output/forward.md)
-   [Monitor Agent input](/plugins/input/monitor_agent.md)
-   [Dummy input](/plugins/input/dummy.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
