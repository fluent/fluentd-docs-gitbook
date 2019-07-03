# Http Server Plugin Helper API

`http_server` helper creates http server.
This helper was introduced since v1.6.0.

Here is the code example with `http_server` helper:

```rb
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_output('example', self)

    # 1. load http_server helper
    helpers :http_server

    config_param :bind, :string
    config_param :port, :integer

    def start
      super

      # 2. create and start http server
      create_http_server(addr: @bind, port: @port, logger: log) do |serv|
        # define endpoint `/hello` with GET method
        serv.get('/hello') { [200, { 'Content-Type' => 'text/plain' }, 'hello!'] }
      end
    end
  end
end
```

Launched http server is managed by the helper. No need to stop http server
in plugin's `stop` method. The plugin stops launched http server automatically.

## Methods

### create\_http\_server(addr:, port:, logger:, default_app: nil, &block)

This method creats and runs http server with given routes which are defined in `&block`.

- `addr`: Adderess to listen to
- `port`: Port to listen to
- `logger`: Logger which is used in server helper
- `default_app`: Use this object when server received a request whose path is not registered. This object must have `#call` or be a `Proc` object.

** Define other HTTP methods

```
create_http_server(addr: @bind, port: @port, logger: log) do |serv|
  # define POST method `/hello`
  serv.post('/hello') { [200, { 'Content-Type' => 'text/plain' }, 'hello!'] }

  # define HEAD method `/hello`
  serv.head('/hello') { [200, { 'Content-Type' => 'text/plain' }, nil] }
end
```

## http_server used plugins

-   [Monitor Agent input](/plugins/input/monitor_agent.md)

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
