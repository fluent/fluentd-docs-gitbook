# Plugin Helper: Service Discovery

The `service_discovery` plugin helper provides users with the service discovery functionality.

Example:

```ruby
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. Load service_discovery helper
    helpers :service_discovery

    def configure(conf)
      super

      config = conf.elements(name: 'service_discovery').map do |s|
        { type: :static, conf: s }
      end

      # 2. Create and start service discovery manager
      service_discovery_create_manager(
        :out_example_service_discovery_watcher,
        configurations: config,
      )
    end

    def write(chunk)
      # 3. Select service to send data
      discovery_manager.select_service do |node|
        send_data(node, chunk)
      end
    end

    def send_data(node, chunk)
      # Send data
    end
  end
end
```

**NOTE**: The launched plugin itself is managed by its plugin helper which stops it automatically. No need to stop it in the `stop` method.

## Methods

### `service_discovery_create_manager(title, configurations:, load_balancer: nil, custom_build_method: nil, interval: 3)`

This method creates `service_discovery_manager`.

#### Parameters

* `title`: Thread name. Must be unique. \(required\)
* `configurations`: Configuration of target service. \(required\)
* `load_balancer`: Balancing load to target servers. \(default: Round-Robin\)
* `custom_build_method`: The custom method to build the service.
* `interval`: Time interval for updating target service.

### `discovery_manager`

It manages service discovery functionalities such as updating target services and selecting target services. It provides the `select_service` method that returns a target service to send data.

## Plugins using `service_discovery`

* [`out_forward`](../output/forward.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

