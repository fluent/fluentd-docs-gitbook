# tcp

![](../.gitbook/assets/tcp.png)

The `in_tcp` Input plugin enables Fluentd to accept TCP payload.

It is included in Fluentd's core.

Don't use this plugin for receiving logs from Fluentd client libraries. Use `in_forward` for such cases.

## Example Configuration

```text
<source>
  @type tcp
  tag tcp.events # required
  <parse>
    @type regexp
    expression /^(?<field1>\d+):(?<field2>\w+)$/
  </parse>
  port 20001   # optional. 5170 by default
  bind 0.0.0.0 # optional. 0.0.0.0 by default
  delimiter "\n" # optional. "\n" (newline) by default
</source>
```

Example input:

```text
$ echo '123456:awesome' | netcat 0.0.0.0 5170
```

Parsed result:

```text
{"field1":"123456","field2":"awesome"}
```

Refer to the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

For `<parse>`, see [Parse Section](../configuration/parse-section.md).

We have observed drastic performance improvements on Linux, with proper kernel parameter settings. If you have high-volume TCP traffic, follow [Before Installing Fluentd](../installation/before-install.md) instructions.

## Plugin Helpers

* [`server`](../plugin-helper-overview/api-plugin-helper-server.md)
* [`parser`](../plugin-helper-overview/api-plugin-helper-parser.md)
* [`extract`](../plugin-helper-overview/api-plugin-helper-extract.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

### `@type`

The value must be `tcp`.

### `tag`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.0 |

The tag of output events.

### `port`

| type | default | version |
| :--- | :--- | :--- |
| integer | 5170 | 0.14.0 |

The port to listen to.

### `bind`

| type | default | version |
| :--- | :--- | :--- |
| string | 0.0.0.0 \(all addresses\) | 0.14.0 |

The bind address to listen to.

### `source_hostname_key`

| type | default | version |
| :--- | :--- | :--- |
| string | nil \(no adding hostname\) | 0.14.10 |

The field name of the client's hostname. If set, the client's hostname will be set to its key. The default is `nil` \(no adding hostname\).

With this configuration:

```text
source_hostname_key client_host
```

The client's hostname is set to `client_host` field:

```text
{
    ...
    "foo": "bar",
    "client_host": "client.hostname.org"
}
```

### `source_address_key`

| type | default | version |
| :---: | :---: | :---: |
| string | nil \(no adding source address\) | 1.4.2 |

The field name for the client's IP address. If set, Fluentd automatically adds the remote address to each data record.

For example, if you have the following configuration:

```text
<source>
  @type tcp
  source_address_key client_addr
  # ...
</source>
```

You will get something like below:

```text
{
    ...
    "client_addr": "192.168.10.10"
    ...
}
```

### `message_length_limit`

| type | default | version |
| :--- | :--- | :--- |
| size | nil \(no limit\) | 1.16.1 |

The maximum number of bytes for the message.

### `<transport>` Section

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | tcp | tcp, tls | 0.14.12 |

This section is for setting TLS transport or some general transport configurations.
See [Config: Transport Section](../configuration/transport-section.md) for all supported parameters.

#### General configuration

##### `linger_timeout`

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

##### `send_keepalive_packet`

| type | default | available transport type | version |
| :--- | :--- | :--- | :--- |
| bool | false | tcp, tls | 1.16.0 |

Enable `SO_KEEPALIVE` on the underlying TCP sockets.

This is useful when you connect to Fluentd over firewalls or proxies and
want to prevent connections from being closed automatically.

#### TLS configuration

```text
<transport tls>
  cert_path /path/to/fluentd.crt
  # ...
</transport>
```

See [**How to Enable TLS Encryption**](#how-to-enable-tls-encryption) section for how to use and see [Configuration Example](../plugin-helper-overview/api-plugin-helper-server.md#configuration-example) for all supported parameters.

Without `<transport tls>`, `in_tcp` uses raw TCP.

### `<security>` Section

| required | multi | version |
| :--- | :--- | :--- |
| false | false | 1.7.2 |

Adds `<security>/<client>` section to allow access by Host/IP/Network.

#### `<client>` Section

**host**

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.7.2 |

The IP address or host name of the client.

This is exclusive with `network`.

**network**

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.7.2 |

Network address specification.

This is exclusive with `host`.

### `<parse>` Section

| required | multi | version |
| :--- | :--- | :--- |
| true | false | 0.14.10 |

`in_tcp` uses the parser plugin to parse the payload.

For more details:

* [Parser Plugin Overview](../parser/)
* [Parse Section Configurations](../configuration/parse-section.md)

## Code Example

Here is a Ruby example to send an event to `in_tcp`:

```text
require 'socket'

# This example uses json payload.
# In in_tcp configuration, need to configure "@type json" in "<parse>"
TCPSocket.open('127.0.0.1', 5170) do |s|
  s.write('{"k":"v1"}' + "\n")
  s.write('{"k":"v2"}' + "\n")
end
```

## Tips

### How to Enable TLS Encryption

`in_tcp` supports TLS transport.

Example:

```text
<source>
  @type tcp
  port 5140
  bind 0.0.0.0
  <transport tls>
    ca_path /etc/pki/ca.pem
    cert_path /etc/pki/cert.pem
    private_key_path /etc/pki/key.pem
    private_key_passphrase PASSPHRASE
  </transport>
  tag tcp
</source>
```

### How to Enable TLS Mutual Authentication

Fluentd supports [TLS mutual authentication](https://en.wikipedia.org/wiki/Mutual_authentication) \(i.e. client certificate auth\). If you want to use this feature, please set the `client_cert_auth` and `ca_path` options like this:

```text
<source>
  @type tcp
  port 20001
  <transport tls>
    # ...
    client_cert_auth true
    ca_path /path/to/ca/cert
  </transport>
</source>
```

When this feature is enabled, Fluentd will check all the incoming requests for a client certificate signed by the trusted CA. Requests with an invalid client certificate will fail.

To check if mutual authentication is working properly, issue these commands:

```text
$ openssl s_client -connect localhost:20001 \
  -key path/to/client.key \
  -cert path/to/client.crt \
  -CAfile path/to/ca.crt
```

If the connection gets established successfully, your setup is working fine.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

