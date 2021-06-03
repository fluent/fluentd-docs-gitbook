# Plugin Helper: Socket

The `socket` plugin helper creates various types of socket instances.

Here is an example:

```ruby
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. Load socket helper
    helpers :socket

    config_param :host, :string
    config_param :port, :integer

    # Omit `configure`, `shutdown` and other plugin APIs

    def try_write(chunk)
      # 2. Create socket
      socket = socket_create(:tcp, @host, @port)
      chunk.each do |time, record|
        # 3. Write data to socket
        socket.write(record.to_json)
      end
    ensure
      # 4. Close socket
      socket.close if socket
    end
  end
end
```

The `socket` plugin helper does not manage the lifecycle of the socket. User must close the socket when it is no longer needed.

## Methods

### `socket_create(proto, host, port, **kwargs, &block)`

This method creates a socket instance with the given protocol type.

If the block is given, it will be invoked with the socket instance as a parameter, and the socket will automatically be closed when the block terminates.

* `proto`: protocol type. { `:tcp`, `:udp`, `:tls` }
* `host`: host name or IP address
* `port`: port number
* `kwargs`: extra options. For more details, see methods below.
* `block`: customize socket

Code example:

```ruby
# TCP
socket = socket_create(:tcp, 'example.com', 12340)
socket.write(data)
socket.close

# UDP
socket = socket_create(:udp, 'example.com', 12341)
socket.write(data)
socket.close

# TLS
socket = socket_create(:tls, 'example.com', 12342, insecure: true)
socket.write(data)
socket.close

# close socket automatically
socket_create(:udp, 'example.com', 12341) do |sock|
  sock.write(data)
end
```

### `socket_create_tcp(host, port, **kwargs, &block)`

This method creates socket instance for TCP.

If the block is given, it will be invoked with the socket instance as a parameter, and the socket will automatically be closed when the block terminates.

* `host`: hostname or IP address
* `port`: port number
* `kwargs`: extra options
  * `resolve_name`: if `true`, resolve the hostname
  * `nonblock`: if `true`, use non-blocking I/O
  * `linger_timeout`: the timeout \(seconds\) to set `SO_LINGER`
  * `recv_timeout`: the timeout \(seconds\) to set `SO_RECVTIMEO`
  * `send_timeout`: the timeout \(seconds\) to set `SO_SNDTIMEO`
  * `send_keepalive_packet`: if `true`, enable TCP keep-alive via `SO_KEEPALIVE`
  * `connect_timeout`: the timeout for socket connect. When the connection

    timed out during establishment, `Errno::ETIMEDOUT` is raised.

#### `send_keepalive_packet` Use Case

If you set `true` to `send_keepalive_packet`, you also need to configure keep-alive related kernel parameters:

```ruby
net.ipv4.tcp_keepalive_intvl = 75
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_time = 7200
```

This parameter mitigates half-open connection issue with load balancers. Check also [this issue](https://github.com/fluent/fluentd/pull/2352) for AWS NLB case.

### `socket_create_udp(host, port, **kwargs, &block)`

This method creates socket instance for UDP.

If block is given, it will be invoked with the socket instance as a parameter, and socket will automatically be closed when the block terminates.

* `host`: host name or IP address
* `port`: port number
* `kwargs`: extra options
  * `resolve_name`: if `true`, resolve the hostname
  * `connect`: if `true`, connect to host
  * `nonblock`: if `true`, use non-blocking I/O
  * `linger_timeout`: the timeout \(seconds\) to set `SO_LINGER`
  * `recv_timeout`: the timeout \(seconds\) to set `SO_RECVTIMEO`
  * `send_timeout`: the timeout \(seconds\) to set `SO_SNDTIMEO`

### `socket_create_tls(host, port, **kwargs, &block)`

This method creates socket instance for TLS.

If block is given, it will be invoked with the socket instance as a parameter, and socket will automatically be closed when the block terminates.

* `host`: host name or IP address
* `port`: port number
* `kwargs`: extra options
  * `version`: set TLS version `:TLSv1_1` or `:TLSv1_2`. \(default: `:TLSv1_2`\)
  * `ciphers`: set the list of available cipher suites. \(default:

    `"ALL:!aNULL:!eNULL:!SSLv2"`\)

  * `insecure`: if `true`, set TLS verify mode `NONE`
  * `verify_fqdn`: if `true`, validate the server certificate for the hostname
  * `fqdn`: set FQDN
  * `enable_system_cert_store`: if `true`, enable system default cert store
  * `allow_self_signed_cert`: if `true`, allow self-signed certificate
  * `cert_paths`: files contain PEM-encoded certificates
  * `private_key_path`: set the client private key path
  * `private_key_passphrase`: set the client private key passphrase
  * `cert_thumbprint`: set the certificate thumbprint for searching from Windows system certstore
  * `cert_logical_store_name`: set the certificate logical store name on Windows system certstore
  * `cert_use_enterprise_store`: if `true`, enable to use certificate enterprise store on Windows system certstore
  * Support more parameters same as socket\_create\_tcp's `kwargs`

## Plugins using `socket`

* [`out_forward`](../output/forward.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

