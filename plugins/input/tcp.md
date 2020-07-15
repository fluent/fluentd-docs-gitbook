# TCP Input Plugin

![tcp.png](/images/plugins/input/tcp.png)

The `in_tcp` Input plugin enables Fluentd to accept TCP payload.

It is included in Fluentd's core.

Don't use this plugin for receiving logs from Fluentd client
libraries. Use `in_forward` for such cases.


## Example Configuration

```
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

```
$ echo '123456:awesome' | netcat 0.0.0.0 5170
```

Parsed result:

```
{"field1":"123456","field2":"awesome"}
```

Refer to the [Configuration File](/configuration/config-file.md) article for the
basic structure and syntax of the configuration file.

For `<parse>`, see [Parse Section](/configuration/parse-section.md).

We have observed drastic performance improvements on Linux, with
proper kernel parameter settings. If you have high-volume TCP traffic, follow [Before Installing Fluentd](/install/before-install.md) instructions.


## Plugin Helpers

-   [`server`](/developer/api-plugin-helper-server.md)
-   [`parser`](/developer/api-plugin-helper-parser.md)
-   [`extract`](/developer/api-plugin-helper-extract.md)
-   [`compat_parameters`](/developer/api-plugin-helper-compat_parameters.md)


## Parameters

See [Common Parameters](/configuration/plugin-common-parameters.md).

### `@type`

The value must be `tcp`.


### `tag`

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.0  |

The tag of output events.


### `port`

| type    | default | version |
|:--------|:--------|:--------|
| integer | 5170    | 0.14.0  |

The port to listen to.


### `bind`

| type   | default                 | version |
|:-------|:------------------------|:--------|
| string | 0.0.0.0 (all addresses) | 0.14.0  |

The bind address to listen to.


### `source_hostname_key`

| type   | default                  | version |
|:-------|:-------------------------|:--------|
| string | nil (no adding hostname) | 0.14.10 |

The field name of the client's hostname. If set, the client's hostname will be
set to its key. The default is `nil` (no adding hostname).

With this configuration:

```
source_hostname_key client_host
```

The client's hostname is set to `client_host` field:

```
{
    ...
    "foo": "bar",
    "client_host": "client.hostname.org"
}
```


### `source_address_key`

| type   | default                        | version |
|:------:|:------------------------------:|:-------:|
| string | nil (no adding source address) | 1.4.2   |

The field name for the client's IP address. If set, Fluentd automatically adds
the remote address to each data record.

For example, if you have the following configuration:

```
<source>
  @type tcp
  source_address_key client_addr
  # ...
</source>
```

You will get something like below:

```
{
    ...
    "client_addr": "192.168.10.10"
    ...
}
```


### `<transport>` Section

| type | default | available values | version |
|:-----|:--------|:-----------------|:--------|
| enum | udp     | tls              | 0.14.12 |

This section is for using TLS transport.

```
<transport tls>
  cert_path /path/to/fluentd.crt
  # ...
</transport>
```

Without `<transport tls>`, `in_tcp` uses raw TCP.


### `<security>` Section

| required | multi | version |
|:---------|:------|:--------|
| false    | false |  1.7.2  |

Adds `<security>/<client>` section to allow access by Host/IP/Network.


#### `<client>` Section


##### `host`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.2   |

The IP address or host name of the client.

This is exclusive with `network`.


##### `network`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.7.2   |

Network address specification.

This is exclusive with `host`.


### `<parse>` Section

| required | multi | version |
|:---------|:------|:--------|
| true     | false | 0.14.10 |

`in_tcp` uses parser plugin to parse the payload.

For more details:

-   [Parser Plugin Overview](/plugins/parser/README.md)
-   [Parse Section Configurations](/configuration/parse-section.md)


## Code Example

Here is a Ruby example to send event to `in_tcp`:

```
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

```
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

Fluentd supports [TLS mutual authentication](https://en.wikipedia.org/wiki/Mutual_authentication)
(i.e. client certificate auth). If you want to use this feature,
please set the `client_cert_auth` and `ca_path` options like this:

```
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

When this feature is enabled, Fluentd will check all the incoming requests for a
client certificate signed by the trusted CA. Requests with an invalid client
certificate will fail.

To check if mutual authentication is working properly, issue these commands:

```
$ openssl s_client -connect localhost:20001 \
  -key path/to/client.key \
  -cert path/to/client.crt \
  -CAfile path/to/ca.crt
```

If the connection gets established successfully, your setup is working fine.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
