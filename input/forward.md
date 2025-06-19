# forward

![](../.gitbook/assets/forward.png)

The `in_forward` Input plugin listens to a TCP socket to receive the event stream. It also listens to a UDP socket to receive heartbeat messages. See also the **protocol** section for implementation details.

This plugin is mainly used to receive event logs from other Fluentd instances, the `fluent-cat` command, or Fluentd client libraries. This is by far the most efficient way to retrieve the records.

If you want to receive events from raw TCP payload, use `in_tcp` plugin instead.

It is included in Fluentd's core.

## Example Configuration

```text
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>
```

Refer to the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

## Plugin Helpers

* [`server`](../plugin-helper-overview/api-plugin-helper-server.md)

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Transport Section](../configuration/transport-section.md)

### `@type`

The value must be `forward`.

### `port`

| type | default | version |
| :--- | :--- | :--- |
| integer | 24224 | 0.14.0 |

The port to listen to.

### `bind`

| type | default | version |
| :--- | :--- | :--- |
| string | 0.0.0.0 \(all addresses\) | 0.14.0 |

The bind address to listen to.

### `tag`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.5.0 |

`in_forward` uses incoming event's tag by default \(See Protocol Section\). If the `tag` parameter is set, its value is used instead.

### `add_tag_prefix`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.5.0 |

Adds the prefix to the incoming event's tag.

Here is an example:

```text
<source>
  @type forward
  add_tag_prefix prod
</source>
```

With this configuration, the emitted tag is `prod.INCOMING_TAG`, e.g. `prod.app.log`.

### `linger_timeout`

| type | default | version |
| :--- | :--- | :--- |
| integer | 0 | 0.14.0 |

The timeout used to set the linger option.

This parameter is deprecated since v1.14.6. Use `<transport>` directive instead.

### `resolve_hostname`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.10 |

Tries to resolve hostname from IP addresses or not.

### `deny_keepalive`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.5 |

The connections will be disconnected right after receiving a message, if `true`.

### `send_keepalive_packet`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.4.2 |

Enables the TCP keepalive for sockets. See [socket article](../plugin-helper-overview/api-plugin-helper-socket.md#send_keepalive_packet-use-case) for more details.

### `chunk_size_limit`

| type | default | version |
| :--- | :--- | :--- |
| size | nil \(no limit\) | 0.14.0 |

The size limit of the received chunk. If the chunk size is larger than this value, the received chunk is dropped.

### `chunk_size_warn_limit`

| type | default | version |
| :--- | :--- | :--- |
| size | nil \(no warning\) | 0.14.0 |

The warning size limit of the received chunk. If the chunk size is larger than this value, a warning message will be sent.

### `skip_invalid_event`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.0 |

Skips the invalid incoming event.

This option is useful for forwarder, not aggregator.
Since v1.19.0, the default value is changed to `true`.

### `source_address_key`

| type | default | version |
| :--- | :--- | :--- |
| string | nil \(no adding address\) | 0.14.11 |

The field name of the client's source address. If set, the client's address will be set to its key.

### `source_hostname_key`

| type | default | version |
| :--- | :--- | :--- |
| string | nil \(no adding hostname\) | 0.14.4 |

The field name of the client's hostname. If set, the client's hostname will be set to its key.

This iterates incoming events. So, if you send larger chunks to `in_forward`, it needs additional processing time.

### `<transport>` Section

This section is for setting TLS transport or some general transport configurations.

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
<transport tcp>
  linger_timeout 1
</transport>
```

#### TLS configuration

```text
<transport tls>
  cert_path /path/to/fluentd.crt
  # other parameters
</transport>
```

See [**How to Enable TLS Encryption**](#how-to-enable-tls-encryption) section for how to use and see [Configuration Example](../plugin-helper-overview/api-plugin-helper-server.md#configuration-example) for all supported parameters.

Without `<transport tls>`, `in_forward` uses raw TCP.

### `<security>` Section

| required | multi | version |
| :--- | :--- | :--- |
| false | false | 0.14.5 |

This section contains parameters related to authentication:

* `self_hostname`
* `shared_key`
* `user_auth`
* `allow_anonymous_source`

#### `self_hostname`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.5 |

The hostname.

#### `shared_key`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.5 |

The shared key for authentication.

#### `user_auth`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.5 |

If `true`, user-based authentication is used.

#### `allow_anonymous_source`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.5 |

Allows the anonymous source. `<client>` sections are required, if disabled.

#### `<user>` section

| required | multi | version |
| :--- | :--- | :--- |
| false | true | 0.14.5 |

This section contains user-based authentication:

* `username`
* `password`

This section can be used in `<security>`.

**username**

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.5 |

The username for authentication.

**password**

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.5 |

The password for authentication.

#### `<client>` section

| required | multi | version |
| :--- | :--- | :--- |
| false | true | 0.14.5 |

This section contains client IP/Network authentication and shared key per host:

* `host`
* `network`
* `shared_key`
* `users`

This section can be used in `<security>`

**host**

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.5 |

The IP address or hostname of the client.

This is exclusive with `network`.

**network**

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.5 |

The network address specification.

This is exclusive with `host`.

**shared\_key**

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.5 |

The shared key per client.

**users**

| type | default | version |
| :--- | :--- | :--- |
| array | `[]` | 0.14.5 |

The array of usernames.

## Protocol

This plugin accepts both JSON or [MessagePack](http://msgpack.org/) messages and automatically detects which one is used. Internally, Fluentd uses MessagePack as it is more efficient than JSON.

The time value is an `EventTime` or a platform-specific integer and is based on the output of Ruby's `Time.now.to_i` function. On Linux, BSD, and Mac systems, this is the number of seconds since 1970.

Multiple messages may be sent on the same connection:

```text
stream:
  message...

message:
  [tag, time, record]
  or
  [tag, [[time,record], [time,record], ...]]

example:
  ["myapp.access", 1308466941, {"a":1}]["myapp.messages", 1308466942, {"b":2}]
  ["myapp.access", [[1308466941, {"a":1}], [1308466942, {"b":2}]]]
```

For more details, see [Fluentd Forward Protocol Specification \(v1\)](https://github.com/fluent/fluentd/wiki/Forward-Protocol-Specification-v1).

## Tips and Tricks

### How to Enable TLS Encryption

Since v0.14.12, Fluentd includes a built-in TLS support. Here we present a quick tutorial for setting up TLS encryption:

First, generate a self-signed certificate using the following command:

```text
$ openssl req -new -x509 -sha256 -days 1095 -newkey rsa:2048 \
              -keyout fluentd.key -out fluentd.crt
# Note that during the generation, you will be asked for:
#  - a password (to encrypt the private key), and
#  - subject information (to be included in the certificate)
```

Move the generated certificate and private key to a safer place. For example:

```text
# Move files into /etc/td-agent
$ sudo mkdir -p /etc/td-agent/certs
$ sudo mv fluentd.key fluentd.crt /etc/td-agent/certs

# Set strict permissions
$ sudo chown td-agent:td-agent -R /etc/td-agent/certs
$ sudo chmod 700 /etc/td-agent/certs/
$ sudo chmod 400 /etc/td-agent/certs/fluentd.key
```

Then, add the following settings to `td-agent.conf` and restart the service:

```text
<source>
  @type forward
  <transport tls>
    cert_path /etc/td-agent/certs/fluentd.crt
    private_key_path /etc/td-agent/certs/fluentd.key
    private_key_passphrase YOUR_PASSPHRASE
  </transport>
</source>
<match debug.**>
  @type stdout
</match>
```

To test your encryption settings, execute the following command in your terminal. If the encryption is working properly, you should see a line containing `{"foo":"bar"}` in the log file:

```text
$ echo -e '\x93\xa9debug.tls\xceZr\xbc1\x81\xa3foo\xa3bar' | \
  openssl s_client -connect localhost:24224
```

If you can confirm TLS encryption has been set up correctly, please proceed to the configuration of the [`out_forward`](../output/forward.md#how-to-connect-to-a-tls-ssl-enabled-server) server.

### How to Enable TLS Mutual Authentication

Since v1.1.1, Fluentd supports [TLS mutual authentication](https://en.wikipedia.org/wiki/Mutual_authentication) \(i.e. client certificate auth\). If you want to use this feature, please set the `client_cert_auth` and `ca_path` options like this:

```text
<source>
  @type forward
  <transport tls>
    ...
    client_cert_auth true
    ca_path /path/to/ca/cert
  </transport>
</source>
```

When this feature is enabled, Fluentd will check all the incoming requests for a client certificate signed by the trusted CA. Requests with an invalid client certificate will fail.

To check if mutual authentication is working properly, issue the following command:

```text
$ openssl s_client -connect localhost:24224 \
  -key path/to/client.key \
  -cert path/to/client.crt \
  -CAfile path/to/ca.crt
```

If the connection gets established successfully, your setup is working fine.

+For `fluentd` and `fluent-bit` combination, see Banzai Cloud article: [Secure logging on Kubernetes with Fluentd and Fluent Bit](https://banzaicloud.com/blog/k8s-logging-tls/).

### How to Enable Password Authentication

Fluentd is equipped with a password-based authentication mechanism, which allows you to verify the identity of each client using a shared secret key.

To enable this feature, you need to add a `<security>` section to your configuration file like this:

```text
<source>
  @type forward
  <security>
    self_hostname YOUR_SERVER_NAME
    shared_key PASSWORD
  </security>
</source>
```

Once the setup is complete, you have to configure your clients accordingly. For example, if you have an `out_forward` instance running on another server, configure it by following these [instructions](../output/forward.md#how-to-enable-password-authentication).

### Multi-process Environment

If you use this plugin under the multi-process environment, the port will be shared.

```text
<system>
  workers 3
</system>

<source>
  @type forward
  port 24224
</source>
```

With this configuration, the three \(3\) workers share the port `24224`. No need for an additional port. Incoming data will be routed to the workers automatically.

## FAQ

### How to parse incoming events?

`in_forward` does not provide parsing mechanism unlike `in_tail` or `in_tcp` because `in_forward` is mainly for efficient log transfer. If you want to parse an incoming event, use [parser filter](../filter/parser.md) in your pipeline.

See [Docker Logging](http://www.fluentd.org/guides/recipes/docker-logging) driver use case.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
