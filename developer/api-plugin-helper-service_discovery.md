# Service Discovery Helper API

`service_discovery` helper provides users with service discovery.

Here is the code example with `service_discovery` helper:

```rb
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. load service_discovery helper
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
      # 3. select service to send data
      discovery_manager.select_service do |node|
        send_data(node, chunk)
      end
    end

    def send_data(node, chunk)
      # send data
    end
  end
end
```

Launched service discovery service is managed by the helper. No need to stop it.
in plugin's `stop` method. The plugin stops launched service discovery automatically.

## Methods

### service\_discovery\_create\_manager(title, configurations:, load\_balancer: nil, custom\_build\_method: nil, interval: 3)

The method creates service `discovery_manager`. Here is the parameter.

- `title`: Thread name. this value must be unique (required)
- `configurations`: Configuration of target service (required)
- `load_balancer`: Balancing load to target servers. default is Round-Robin
- `custom_build_method`: Custom method used when building service
- `interval`: Interval time for updating target service

### discovery\_manager

The value manages all things about service discovery such as updating target services and selecting target services.
The value provides `select_service` method which returns a target service to send data.


## plugins which use service\_discovery

-   [out forward](/plugins/output/forward.md)

------------------------------------------------------------------------

If this article is incorrect or outdated or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
