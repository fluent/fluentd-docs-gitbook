# Socket Plugin Helper API

`socket` helper creates various types of socket instances.

Here is the code example with `socket` helper:

```
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. load socket helper
    helpers :socket

    config_param :host, :string
    config_param :port, :integer

    # omit configure, shutdown and other plugin API

    def try_write(chunk)
      # 2. create socket
      socket = socket_create(:tcp, @host, @port)
      chunk.each do |time, record|
        # 3. write data to socket
        socket.write(record.to_json)
      end
    ensure
      # 4. close socket
      socket.close if socket
    end
  end
end
```

`socket` helper doesn't manage life cycle of the socket. User must close
the socket when it is no longer needed.


## Methods


### socket\_create(proto, host, port, \*\*kwargs, &block)

This method creates socket instance with given protocol type

If block is given, it will be invoked with the socket instance as a
parameter, and socket will be automatically closed when the block
terminates.

-   `proto`: protocol type. `:tcp`, `:udp`, `:tls`
-   `host`: host name or IP address
-   `port`: port number
-   `kwargs`: extra options. for more details, see below methods.
-   `block`: customize created socket

Code example:

```
# TCP
socket = socket_create(:tcp, "example.com", 12340)
socket.write(data)
socket.close

# UDP
socket = socket_create(:udp, "example.com", 12341)
socket.write(data)
socket.close

# TLS
socket = socket_create(:tls, "example.com", 12342, insecure: true)
socket.write(data)
socket.close

# close socket automatically
socket_create(:udp, "example.com", 12341) do |sock|
  sock.write(data)
end
```


### socket\_create\_tcp(host, port, \*\*kwargs, &block)

This method creates socket instance for TCP

If block is given, it will be invoked with the socket instance as a
parameter, and socket will be automatically closed when the block
terminates.

-   `host`: hostname or IP address
-   `port`: port number
-   `kwargs`: extra options
    -   `resolve_name`: if true, resolve hostname
    -   `nonblock`: if true, use non-blocking I/O
    -   `linger_timeout`: the timeout time in seconds used to set
        `SO_LINGER`
    -   `recv_timeout`: the timeout time in seconds used to set
        `SO_RECVTIMEO`
    -   `send_timeout`: the timeout time in seconds used to set
        `SO_SNDTIMEO`
    -   `send_keepalive_packet`: if true, enable TCP keepalive via `SO_KEEPALIVE`
    -   `connect_timeout`: the timeout time for socket connect. When the connection timed out during establishment, `Errno::ETIMEDOUT` is raised.

#### send_keepalive_packet usecase

If you set `true` to `send_keepavlie_packet`, you also need to configure keepalive related kernel parameters like below:

```
net.ipv4.tcp_keepalive_intvl = 75
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_time = 7200
```

This parameter mitigates half-open connection issue with load balancers. Check also [this issue](https://github.com/fluent/fluentd/pull/2352) for AWS NLB case.

### socket\_create\_udp(host, port, \*\*kwargs, &block)

This method creates socket instance for UDP

If block is given, it will be invoked with the socket instance as a
parameter, and socket will be automatically closed when the block
terminates.

-   `host`: host name or IP address
-   `port`: port number
-   `kwargs`: extra options
    -   `resolve_name`: if true, resolve hostname
    -   `connect`: if true, connect to host
    -   `nonblock`: if true, use non-blocking I/O
    -   `linger_timeout`: the timeout time in seconds used to set
        `SO_LINGER`
    -   `recv_timeout`: the timeout time in seconds used to set
        `SO_RECVTIMEO`
    -   `send_timeout`: the timeout time in seconds used to set
        `SO_SNDTIMEO`


### socket\_create\_tls(host, port, \*\*kwargs, &block)

This method creates socket instance for TLS

If block is given, it will be invoked with the socket instance as a
parameter, and socket will be automatically closed when the block
terminates.

-   `host`: host name or IP address
-   `port`: port number
-   `kwargs`: extra options
    -   `version`: set TLS version `:'TLSv1_1'` or `:'TLSv1_2'`.
        Default: `:'TLSv1_2'`
    -   `ciphers`: set the list of available cpher suites. Default:
        `"ALL:!aNULL:!eNULL:!SSLv2"`
    -   `insecure`: if true, set TLS verify mode NONE
    -   `verify_fqdn`: if true, check the server certificate is valid
        for the hostname
    -   `fqdn`: set FQDN
    -   `enable_system_cert_store`: if true, enable system default cert
        store
    -   `allow_self_signed_cert`: if true, allow self signed certificate
    -   `cert_paths`: files contain PEM-encoded certificates
    -   `private_key_path`: set the client private key path
    -   `private_key_passphrase`: set the client private key passphrase
    -   `cert_thumbprint`: set the certificate thumbprint for searching from Windows system certstore
    -   `cert_logical_store_name`: set The certificate logical store name on Windows system certstore
    -   `cert_use_enterprise_store`: if true, enable to use certificate enterprise store on Windows system certstore
    -   Support more parameters same as socket_create_tcp's kwargs

## socket used plugins

-   [Forward output](/plugins/output/forward.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
