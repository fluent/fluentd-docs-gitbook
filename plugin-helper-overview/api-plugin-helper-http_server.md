# Plugin Helper: Http Server

The `http_server` helper creates an HTTP server. This helper was introduced in v1.6.0.

It supports [`async-http`](https://github.com/socketry/async-http)-based server to improve the performance.

Here is an example:

```ruby
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_output('example', self)

    # 1. Load http_server helper
    helpers :http_server

    config_param :bind, :string
    config_param :port, :integer

    def start
      super

      # 2. Create and start HTTP server
      create_http_server(:example_http_server, addr: @bind, port: @port, logger: log) do |serv|
        # Define endpoint `/hello` with GET method
        serv.get('/hello') { [200, { 'Content-Type' => 'text/plain' }, 'hello!'] }
      end
    end
  end
end
```

**NOTE**: The launched plugin itself is managed by its plugin helper which stops it automatically. No need to stop it in the `stop` method.

## Methods

### `create_http_server(title, addr:, port:, logger:, default_app: nil, &block)` \(deprecated\)

**This method is deprecated! Use `http_server_create_http_server` method instead.**

### `http_server_create_http_server(title, addr:, port:, logger:, default_app: nil, proto: nil, tls_opts: nil, &block)`

It creates and starts an HTTP server with the given routes defined in `&block`.

* `title`: The name of the listening thread. Must be unique!
* `addr`: The address to listen to.
* `port`: The port to listen to.
* `logger`: The logger used in the server helper.
* `default_app`: The object to handle the requests with unregistered paths. This

  object must have a `#call` method or must be a `Proc` object.

* `proto`: Protocol type. Supported values: {`:tcp`, `:tls`} \(default: `:tcp`\)
* `tls_opts`: TLS options. Same as the Server Helper's

  [`server_create_connection` `tls_options`](api-plugin-helper-server.md).

### `http_server_create_https_server(title, addr:, port:, logger:, default_app: nil, tls_opts: nil, &block)`

It creates and starts an HTTPS server with the given routes defined in `&block`.

* `title`: The name of the listening thread. Must be unique!
* `addr`: The address to listen to.
* `port`: The port to listen to.
* `logger`: The logger used in the server helper.
* `default_app`: The object to handle the requests with unregistered paths. This

  object must have a `#call` method or must be a `Proc` object.

* `tls_opts`: TLS options. Same as the Server Helper's

  [`server_create_connection` `tls_options`](api-plugin-helper-server.md).

## Handling of other HTTP Methods

```ruby
create_http_server(:example_http_server, addr: @bind, port: @port, logger: log) do |serv|
  # define POST method `/hello`
  serv.post('/hello') { [200, { 'Content-Type' => 'text/plain' }, 'hello!'] }

  # define HEAD method `/hello`
  serv.head('/hello') { [200, { 'Content-Type' => 'text/plain' }, nil] }
end
```

## Request and Response

#### Request

Request supports these following methods:

* `query_string`: returns query string like `hoge=v1&fuga=v2`
* `query`: returns query which is `query_string` parsed by `CGI.parse`
* `body`: returns the request body
* `path`: returns the request path
* `headers`: returns `Protocol::HTTP::Headers` object to read the request headers (since v1.19.0)

#### Response

The `http_server` helper expects an array as the return value i.e.:

```ruby
[${response_status}, ${headers}, ${body}]
```

* `${response_status}` should be an `Integer`
* `${headers}` should be a `Hash`
* `${body}` should be a `String` or `nil`

#### Example

Here is an example of request and response in JSON format:

```ruby
create_http_server(:example_json_http_server, addr: @bind, port: @port, logger: log) do |serv|
  serv.post('/hello.json') do |req|
    body = JSON.parse(req.body)
    log.info(body)

    [code, { 'Content-Type' => 'application/json' }, { 'status' => 'success' }.to_json]
  end
end
```

## Plugins using `http_server`

* [`in_monitor_agent`](../input/monitor_agent.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

