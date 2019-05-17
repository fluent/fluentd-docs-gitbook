# Timer Plugin Helper API

`timer` helper manages event timers.

Here is the code example with `timer` helper:

```
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_input('example', self)

    # 1. load timer helper
    helpers :timer

    # omit configure, shutdown and other plugin API

    def start
      super

      # 2. execute timer with unique name and second unit interval
      timer_execute(:example_timer, 10) {
        # ...
      }
    end
  end
end
```

Launched timer is managed by the plugin. No need timer shutdown code in
plugin's `shutdown`. The plugin shutdowns launched timers automatically.


## Methods


### timer\_execute(title, interval, repeat: true, &block)

This method executes timer with given parameters and routine

-   `title`: unique symbol value
-   `interval`: Second unit `integer`/`float` value.
-   `repeat`: `true`/`false`. Default is `true`. If pass `false`, timer
    is one-shot.

Code examples:

```
# Pass block directly. block is executed in 10 second interval.
timer_execute(:example_timer, 10) {
  # ...
}

# Pass block with existing method. block is executed in 5 second and one-shot.
timer_execute(:example_timer_run, 5s, repeat: false, &method(:run))
def run
  # ...
end
```


## timer used plugins

-   [Forward output](/plugins/output/forward.md)
-   [Monitor Agent input](/plugins/input/monitor_agent.md)
-   [Dummy input](/plugins/input/dummy.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
