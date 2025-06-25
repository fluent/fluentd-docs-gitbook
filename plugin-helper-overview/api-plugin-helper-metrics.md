# Plugin Helper: Metrics

The `metrics` plugin helper manages the metrics values in plugins.

Here is an example:

```ruby
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_input('example', self)

    # 1. Load metrics helper
    helpers :metrics

    def configure(conf)
      super

      # 2. Create parser plugin instance
      @metrics = metrics_create(namespace: "fluentd", subsystem: "input", name: "example", help_text: "Example metrics")
    end

    def start
      super

      # 3. Increase metrics value
      @metrics.inc

    end

    def statistics
      stats = super

      # 4. Retrieve metrics value
      stats = {
        'input' => stats["input"].merge({ 'example' => @metrics.get })
      }
      stats
    end
end
```

For more details, see the following articles:

* [Metrics Plugins Overview](../metrics/)

## Methods

### `metrics_create(namespace: "fluentd", subsystem: "metrics", name:, help_text:, labels: {}, prefer_gauge: false)`

This method creates a metrics instance.

* `namespace`: The namespace for the metrics.
* `subsystem`: The names that represent specific functions or components.
* `name`: The metrics name.
* `help_text`: The description for metrics.
* `labels`: The key/value pair for metrics labels.
* `prefer_gauge`: Use gauge instead of counter for the metrics if `true`.

Since  1.19.0, `metrics_create` method generates a getter method with the specified `name` on the calling instance.

## Plugins using `metrics`

* [`buffer`](../buffer/)
* [`filter`](../filter/)
* [`input`](../input/)
* [`output`](../output/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

