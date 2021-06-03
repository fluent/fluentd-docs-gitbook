# Plugin Helper: Timer

The `timer` plugin helper manages event timers.

Here is an example:

```ruby
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_input('example', self)

    # 1. Load timer helper
    helpers :timer

    # Omit `configure`, `shutdown` and other plugin APIs

    def start
      super

      # 2. Execute timer with unique name and second unit interval
      timer_execute(:example_timer, 10) {
        # ...
      }
    end
  end
end
```

The launched timer is managed by the plugin helper. No need of timer shutdown code in plugin's `shutdown` method. The plugin shutdowns the launched timers automatically.

## Methods

### `timer_execute(title, interval, repeat: true, &block)`

This method executes the timer with the given parameters and routine.

* `title`: unique symbol value
* `interval`: second unit `integer`/`float` value.
* `repeat`: `true`/`false` \(default: `true`\). If `false`, timer is one-shot.

Code examples:

```ruby
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

## Plugins using `timer`

* [`out_forward`](../output/forward.md)
* [`in_monitor_agent`](../input/monitor_agent.md)
* [`in_sample`](../input/sample.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

