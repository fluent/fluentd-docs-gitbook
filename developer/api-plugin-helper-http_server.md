# Http Server Plugin Helper API

`http_server` helper creates http server. This helper was introduced since v1.6.0.

`http_server` helper supports [async-http](https://github.com/socketry/async-http) based server to improve the performance.
If you install `async-http` gem, `http_server` helper uses it instead of standard [webrick](https://github.com/ruby/webrick) server.

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
      create_http_server(:example_http_server, addr: @bind, port: @port, logger: log) do |serv|
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

### create\_http\_server(title, addr:, port:, logger:, default\_app: nil, &block)

__this method is deprecated. Use http\_server\_create\_http\_server method instead__

### http\_server\_create\_http\_server(title, addr:, port:, logger:, default\_app: nil, proto: nil, tls_opts: nil, &block)

This method creats and runs http server with given routes which are defined in `&block`.

- `title`: the name of listen thread. this name must be unique
- `addr`: Address to listen to
- `port`: Port to listen to.
- `logger`: Logger which is used in server helper
- `default_app`: Use this object when server received a request whose path is not registered. This object must have `#call` or be a `Proc` object.
- `proto`: protocol type. `:tcp`, `:tls`.  default value is tcp
- `tls_opts`: options for TLS. same as the [Server Helper's  server_create_connection tls_options](/developer/api-plugin-helper-server)

### http\_server\_create\_https\_server(title, addr:, port:, logger:, default\_app: nil, tls_opts: nil, &block)

This method creats and runs http server with given routes which are defined in `&block`.

- `title`: the name of listen thread. this name must be unique
- `addr`: Address to listen to
- `port`: Port to listen to
- `logger`: Logger which is used in server helper
- `default_app`: Use this object when server received a request whose path is not registered. This object must have `#call` or be a `Proc` object.
- `tls_opts`: options for TLS. same as the [Server Helper's  server_create_connection tls_options](/developer/api-plugin-helper-server)


## Define other HTTP methods

```rb
create_http_server(:example_http_server, addr: @bind, port: @port, logger: log) do |serv|
  # define POST method `/hello`
  serv.post('/hello') { [200, { 'Content-Type' => 'text/plain' }, 'hello!'] }

  # define HEAD method `/hello`
  serv.head('/hello') { [200, { 'Content-Type' => 'text/plain' }, nil] }
end
```

## Detail of request and send response

#### Request

request has following methods.

* `query_string`: query string like `hoge=v1&fuga=v2`
* `query`: query which is `query_string` parsed with `CGI.parse`
* `body`: request body
* `path`: request path

#### Response

http server helper expects an array as return value like below.

`[${response_status}, ${headers}, ${body}]`

* `${response_status}` should be an Integer
* `${headers}` should be a Hash
* `${body}` should be a String or nil

#### Example of recieving json request and return json response

```rb
create_http_server(:example_json_http_server, addr: @bind, port: @port, logger: log) do |serv|
  serv.post('/hello.json') do |req|
    body = JSON.parse(req.body)
    log.info(body)

    [code, { 'Content-Type' => 'application/json' }, { 'status' => 'success' }.to_json]
  end
end
```

## http\_server used plugins

-   [Monitor Agent input](/plugins/input/monitor_agent.md)

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
