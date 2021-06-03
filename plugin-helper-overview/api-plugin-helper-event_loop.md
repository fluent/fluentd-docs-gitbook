# Plugin Helper: Event Loop

The `event_loop` plugin helper manages event loops.

Here is an example:

```ruby
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_input('example', self)

    # 1. Load `event_loop_helper`
    helpers :event_loop

    # Omit `configure`, `shutdown` and other plugin APIs

    def start
      super

      # 2. Attach watcher
      watcher = Coolio::TCPServer.new(...)
      event_loop_attach(watcher)
    end
  end
end
```

The attached watcher is managed by the plugin. No need of watcher detach code in plugin's `shutdown`. The plugin shutdowns the attached watchers automatically.

## Methods

### `event_loop_attach(watcher)`

This method attaches watcher to the event loop.

* `watcher`: `Coolio::Watcher` instances

## Plugins using `event_loop`

* [`in_http`](../input/http.md)
* [`in_tail`](../input/tail.md)

{% include "../.gitbook/assets/footer.txt" %}
