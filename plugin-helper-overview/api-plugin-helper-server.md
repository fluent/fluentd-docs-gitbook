# Plugin Helper: Server

The `server` plugin helper manages various types of servers.

Here is an example:

```ruby
require 'fluent/plugin/input'

module Fluent::Plugin
  class ExampleInput < Input
    Fluent::Plugin.register_input('example', self)

    # 1. Load server helper
    helpers :server

    # Omit `configure`, `shutdown` and other plugin APIs

    def start
      # 2. Create server
      server_create(:title, @port) do |data|
        #3. Process data
      end
    end
  end
end
```

The launched server is managed by the plugin helper. No need of server shutdown code in plugin's `shutdown` method. The plugin shutdowns the launched servers automatically.

For more details, see [Transport Section](../configuration/transport-section.md).

## Methods

### `server_create_connection(title, port, proto: nil, bind: '0.0.0.0', shared: true, backlog: nil, tls_options: nil, **socket_options, &block)`

This method creates a server instance for various protocols.

The `&block` is invoked with the new connection as a parameter.

* `title`: unique symbol
* `port`: the port to listen to
* `proto`: protocol type. { `:tcp`, `:tls` }
* `bind`: the bind address to listen to
* `shared`: if `true`, share socket via server engine for multiple workers
* `backlog`: the maximum length of the queue for pending connections
* `tls_options`: options for TLS
  * `version`: set TLS version `:TLSv1_1` or `:TLSv1_2`.

    Default: `:TLSv1_2`

  * `ciphers`: set the list of available cipher suites. \(default:

    `"ALL:!aNULL:!eNULL:!SSLv2"`\)

  * `insecure`: if `true`, set TLS verify mode `NONE`
  * `cert_verifier`: if specified, pass evaluated object to OpenSSL's [`verify_callback`](https://ruby-doc.org/stdlib-2.7.0/libdoc/openssl/rdoc/OpenSSL/X509/Store.html#verify_callback-attribute-method). See also "`cert_verifier` example" section.
  * `verify_fqdn`: if `true`, validate the server certificate for the hostname
  * `fqdn`: set FQDN
  * `enable_system_cert_store`: if `true`, enable system default cert store
  * `allow_self_signed_cert`: if `true`, allow self-signed certificate
  * `cert_paths`: files contain PEM-encoded certificates
* `socket_options`: options for socket
  * `resolve_name`: if `true`, resolve the hostname
  * `connect`: if `true`, connect to host
  * `nonblock`: if `true`, use non-blocking I/O
  * `linger_timeout`: the timeout \(seconds\) to set `SO_LINGER`
  * `recv_timeout`: the timeout \(seconds\) to set `SO_RECVTIMEO`
  * `send_timeout`: the timeout \(seconds\) to set `SO_SNDTIMEO`
  * `send_keepalive_packet`: if `true`, enable TCP keep-alive via `SO_KEEPALIVE`. See also [socket article](api-plugin-helper-socket.md#send_keepalive_packet-use-case).

Example:

```ruby
# TCP
server_create_connection(:title, @port) do |conn|
  # on connection
  # conn is Fluent::PluginHelper::Server::TCPCallbackSocket
  source_addr = conn.remote_host
  source_port = conn.remote_port
  conn.data do |data|
    conn.write(something)
  end
end
```

### `server_create(title, port, proto: nil, bind: '0.0.0.0', shared: true, socket: nil, backlog: nil, tls_options: nil, max_bytes: nil, flags: 0, **socket_options, &callback)`

This method creates a server instance for various protocols.

The `&block` is invoked with parameter\(s\) on data.

* `title`: unique symbol
* `port`: the port to listen to
* `proto`: protocol type. { `:tcp`, `:udp`, `:tls` }
* `bind`: the bind address to listen to
* `shared`: if `true`, share socket via server engine for multiple workers
* `socket`: socket instance for UDP \(only for UDP\)
* `backlog`: the maximum length of the queue for pending connections
* `tls_options`: options for TLS
  * `version`: set TLS version `:TLSv1_1` or `:TLSv1_2`. \(default: `:TLSv1_2`\)
  * `ciphers`: set the list of available cipher suites. \(default:

    `"ALL:!aNULL:!eNULL:!SSLv2"`\)

  * `insecure`: if `true`, set TLS verify mode `NONE`
  * `cert_verifier`: if specified, pass evaluated object to OpenSSL's [`verify_callback`](https://ruby-doc.org/stdlib-2.7.0/libdoc/openssl/rdoc/OpenSSL/X509/Store.html#verify_callback-attribute-method). See also "`cert_verifier` example" section.
  * `verify_fqdn`: if `true`, validate the server certificate for the hostname
  * `fqdn`: set FQDN
  * `enable_system_cert_store`: if `true`, enable system default cert store
  * `allow_self_signed_cert`: if `true`, allow self signed certificate
  * `cert_paths`: files contain PEM-encoded certificates
* `max_bytes`: the maximum number of bytes to receive \(required for  UDP\)
* `flags`: zero or more of the `MSG_` options \(UDP-only\)
* `socket_options`: options for socket
  * `resolve_name`: if `true`, resolve the hostname
  * `connect`: if `true`, connect to host
  * `nonblock`: if `true`, use non-blocking I/O
  * `linger_timeout`: the timeout \(seconds\) to set `SO_LINGER`
  * `recv_timeout`: the timeout \(seconds\) to set `SO_RECVTIMEO`
  * `send_timeout`: the timeout \(seconds\) to set `SO_SNDTIMEO`
  * `send_keepalive_packet`: if `true`, enable TCP keep-alive via `SO_KEEPALIVE`. See also [socket article](api-plugin-helper-socket.md#send_keepalive_packet-use-case).

Code example:

```ruby
# UDP (w/o socket)
server_create(:title, @port, proto: :udp, max_bytes: 2048) do |data|
  # data is received data
end

# UDP (w/ socket)
server_create(:title, @port, proto: :udp, max_bytes: 2048) do |data, sock|
  # data is received data
  # sock is UDPSocket
end

# TCP (w/o connection)
server_create(:title, @port) do |data|
  # data is received data
end

# TCP (w/ connection)
server_create(:title, @port) do |data, conn|
  # data is received data
  # conn is Fluent::PluginHelper::Server::TCPCallbackSocket
end

# TLS (w/o connection)
server_create(:title, @port, proto: :tls) do |data|
  # data is received data
end

# TLS (w/ connection)
server_create(:title, @port, proto: :tls) do |data, conn|
  # data is received data
  # conn is Fluent::PluginHelper::Server::TLSCallbackSocket
end
```

## Configuration example

### General configuration

#### `linger_timeout`

| type | default | available transport type | version |
| :--- | :--- | :--- | :--- |
| integer | 0 | tcp, tls | 1.14.6 |

The timeout \(seconds\) to set `SO_LINGER`.

The default value `0` is to send RST rather than FIN to avoid lots of connections sitting in TIME_WAIT on closing on non-Windows.

You can set positive value to send FIN on closing on non-Windows.

{% hint style='info' %}
On Windows, Fluentd sends FIN without depending on this setting.
{% endhint %}

```text
<source>
  @type tcp
  # other plugin parameters
  <transport tcp>
    linger_timeout 1
  </transport>
</source>
```

### TLS configuration: Basic examples

1. Use existing certs \(signed by public CA or self signed CA\)
2. Use certs automatically generated by Fluentd

Case 1. Use existing certs \(signed by public CA or self signed CA\)

If `cert_path` and `private_key_path` are specified, certs generation is disabled. The existing certs are loaded.

```text
<source>
  @type forward
  # other plugin parameters
  <transport tls>
    version TLSv1_2
    ciphers ALL:!aNULL:!eNULL:!SSLv2
    insecure false

    # For Cert signed by public CA
    ca_path /path/to/ca_file
    cert_path /path/to/cert_path
    private_key_path /path/to/priv_key
    private_key_passphrase "passphrase"
    client_cert_auth false

    # For Cert signed by self signed CA
    ca_path /path/to/ca_path
    cert_path /path/to/cert_path
    private_key_path /path/to/priv_key
    private_key_passphrase "passphrase"
    client_cert_auth false

  </transport>
</source>
```

Case 2. Use certs automatically generated by Fluentd

If `ca_cert_path` and `ca_private_key_path` are specified, certs generation is enabled. You can customize cert generation behavior via `generation_...` parameters. See [Generated and Signed by Private CA Certs or Self-signed Parameters](../configuration/transport-section.md#generated-and-signed-by-private-ca-certs-or-self-signed-parameters) about parameter details.

```text
<source>
  @type forward
  # other plugin parameters
  <transport tls>
    version TLSv1_2
    ciphers ALL:!aNULL:!eNULL:!SSLv2
    insecure false

    # For Cert generated
    ca_cert_path /path/to/ca_cert
    ca_private_key_path /path/to/ca_priv_key
    ca_private_key_passphrase "ca_passphrase"

  </transport>
</source>
```

### TLS configuration: `cert_verifier` example

`cert_verifier` is supported since v1.10.0.

Configuration example:

```text
<source>
  @type forward
  <transport tls>
    # other parameters
    client_cert_auth true
    cert_verifier /path/to/my_verifier.rb
  </transport>
</source>
```

* `my_verifier.rb` example

The code must return a callable object that has a `call` method with two arguments. This object is used as OpenSSL's [`verify_callback`](https://ruby-doc.org/stdlib-2.7.0/libdoc/openssl/rdoc/OpenSSL/X509/Store.html#verify_callback-attribute-method).

#### `Proc` or `lambda` Object for the Simple Scenario

```ruby
Proc.new { |ok, ctx|
  # check code

  if cond
    true
  else
    false
  end
}
```

#### Use `class` for the Complicated Scenario

This is CN check example:

```ruby
module Fluent
  module Plugin
    class InForwardCNChecker
      def initialize
        # Modify for actual common names
        @allow_list = ['fluentd', 'fluentd-client', 'other-org']
      end

      def call(ok, ctx)
        subject = ctx.chain.first.subject.to_a.find { |entry| entry.first == 'CN' }
        if subject
          @allow_list.include?(subject[1])
        else
          false
        end
      end
    end
  end
end

Fluent::Plugin::InForwardCNChecker.new
```

## Plugins using `server`

* [`in_forward`](../input/forward.md)
* [`in_syslog`](../input/syslog.md)
* [`in_tcp`](../input/tcp.md)
* [`in_udp`](../input/udp.md)
* [`out_forward`](../output/forward.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
