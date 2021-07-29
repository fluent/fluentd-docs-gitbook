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

      # 2. Create and start service discovery manager
      service_discovery_configure(
        :out_example_service_discovery_watcher,
        static_default_service_directive: 'server'
      )
    end

    def write(chunk)
      # 3. Select service to send data
      service_discovery_select_service do |node|
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

### `service_discovery_configure(title, static_default_service_directive: nil, load_balancer: nil, custom_build_method: nil, interval: 3)`

Since v1.13.0, `discovery_manager` is almost automatically configured only by calling this method.

#### Parameters

* `title`: Thread name. Must be unique. \(required\)
* `static_default_service_directive`: The directive name of each service when "static" service discovery is enabled in default.
* `load_balancer`: object which has two methods \#rebalance and \#select\_service.
* `custom_build_method`: The custom method to build the service.
* `interval`: Time interval for updating target service.

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

## Migration guide from `service_discovery_create_manager` to more simpler helper method

Here is the guide to migrate to newer API which is available since v1.13.0.

Example:

```ruby
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    helpers :service_discovery

    def configure(conf)
      super

      # 1. Remove the following code which parse 'service_discovery' section by yourself
      #
      # config = conf.elements(name: 'service_discovery').map do |s|
      #  { type: :static, conf: s }
      # end

      # 2. Remove the following code and use service_discovery_configure
      #
      # service_discovery_create_manager(
      #  :out_example_service_discovery_watcher,
      #  configurations: config,
      # )
      service_discovery_configure(
        :out_example_service_discovery_watcher,
        static_default_service_directive: 'server'
      )
    end

    def write(chunk)
      # 3. Remove the following code and use service_discovery_select_service to select service
      #
      # @discovery_manager.select_service do |node|
      #  send_data(node, chunk)
      # end
      service_discovery_select_service do |node|
        send_data(node, chunk)
      end
    end

    def send_data(node, chunk)
      # Send data
    end
  end
end
```

You can also use helper methods such as `service_discovery_services` or `service_discovery_rebalance` instead of `@discovery_manager.services` or `@discovery_manager.rebalance`.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

