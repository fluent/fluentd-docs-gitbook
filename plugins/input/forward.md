# forward Input Plugin

![](/images/plugins/input/forward.png)

The `in_forward` Input plugin listens to a TCP socket to receive the
event stream. It also listens to an UDP socket to receive heartbeat
messages. See also "protocol" section for implementation details.

This plugin is mainly used to receive event logs from other Fluentd
instances, the fluent-cat command, or Fluentd client libraries.
This is by far the most efficient way to retrieve the records.

If you want to receive events from raw tcp payload, use `in_tcp`
plugin instead.

## Example Configuration

`in_forward` is included in Fluentd's core. No additional installation
process is required.

```
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>
```

Please see the [Config FIle](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.


## Plugin helpers

-   [server](/developer/api-plugin-helper-server.md)


## Parameters

-   [Common Parameters](/configuration/plugin-common-parameters.md)
-   [Transport section](/configuration/transport-section.md)

### @type

The value must be `forward`.


### port

| type    | default | version |
|:--------|:--------|:--------|
| integer | 24224   | 0.14.0  |

The port to listen to.


### bind

| type   | default                 | version |
|:-------|:------------------------|:--------|
| string | 0.0.0.0 (all addresses) | 0.14.0  |

The bind address to listen to.


### linger\_timeout

| type    | default | version |
|:--------|:--------|:--------|
| integer | 0       | 0.14.0  |

The timeout time used to set linger option.


### resolve\_hostname

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.10 |

Try to resolve hostname from IP addresses or not.


### deny\_keepalive

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.5  |

Connections will be disconnected right after receiving first message if
this value is true.


### chunk\_size\_limit

| type | default        | version |
|:-----|:---------------|:--------|
| size | nil (no limit) | 0.14.0  |

The size limit of the the received chunk. If the chunk size is larger
than this value, then the received chunk is dropped.


### chunk\_size\_warn\_limit

| type | default          | version |
|:-----|:-----------------|:--------|
| size | nil (no warning) | 0.14.0  |

The warning size limit of the received chunk. If the chunk size is
larger than this value, a warning message will be sent.


### skip\_invalid\_event

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.0  |

Skip an event if incoming event is invalid.

This option is useful at forwarder, not aggragator.


### source\_address\_key

| type   | default                 | version |
|:-------|:------------------------|:--------|
| string | nil (no adding address) | 0.14.11 |

The field name of the client's source address. If set the value, the
client's address will be set to its key.


### source\_hostname\_key

| type   | default                  | version |
|:-------|:-------------------------|:--------|
| string | nil (no adding hostname) | 0.14.4  |

The field name of the client's hostname. If set the value, the client's
hostname will be set to its key.

This iterates incoming events. So if you sends larger chunks to
`in_forward`, it needs additional processing time.


### &lt;transport&gt; section

This section is for using SSL transport.

```
<transport tls>
  cert_path /path/to/fluentd.crt
  # other parameters
</transport>
```

See "How to Enable TLS Encryption" section for how to use and see
["Configuration example" in "Server Plugin Helper" article](/developer/api-plugin-helper-server.md#configuration-example) for
supported parameters

Without `<transport tls>`, in\_forward uses raw TCP.


### &lt;security&gt; section

| required | multi | version |
|:---------|:------|:--------|
| false    | false | 0.14.5  |

This section contains parameters related to authentication.

- self\_hostname
- shared\_key
- user\_auth
- allow\_anonymous\_source

#### self\_hostname

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.5  |

The hostname.

#### shared\_key

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.5  |

Shared key for authentication.

#### user\_auth

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.5  |

If true, use user based authentication.

#### allow\_anonymous\_source

| type | default | version |
|:-----|:--------|:--------|
| bool | true    | 0.14.5  |

Allow anonymous source. `<client>` sections are required if disabled.

#### `<user>` section

| required | multi | version |
|:---------|:------|:--------|
| false    | true  | 0.14.5  |

This section contains user based authentication.

- username
- password

This section can be used in `<security>`.

##### username

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.5  |

The username for authentication.

##### password

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.5  |

The password for authentication.

#### `<client>` section

| required | multi | version |
|:---------|:------|:--------|
| false    | true  | 0.14.5  |

This section contains that client IP/Network authentication and shared
key per host.

- host
- network
- shared\_key
- users

This section can be used in `<security>`

##### host

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.5  |

The IP address or host name of the client.

This is exclusive with `network`.

##### network

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.5  |

Network address specification.

This is exclusive with `host`.

##### shared\_key

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.5  |

Shared key per client.

##### users

| type  | default | version |
|:------|:--------|:--------|
| array | `[]`    | 0.14.5  |

Array of username.


## Protocol

This plugin accepts both JSON or [MessagePack](http://msgpack.org/)
messages and automatically detects which is used. Internally, Fluent
uses MessagePack as it is more efficient than JSON.

The time value is a EventTime or a platform specific integer and is
based on the output of Ruby's `Time.now.to_i` function. On Linux, BSD
and MAC systems, this is the number of seconds since 1970.

Multiple messages may be sent in the same connection.

```
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

For more details, see [Fluentd Forward Protocol Specification (v1)](https://github.com/fluent/fluentd/wiki/Forward-Protocol-Specification-v1).


## Tips & Tricks


### How to Enable TLS Encryption

Since v0.14.12, Fluentd includes a built-in TLS support. Here we present
a quick tutorial for setting up TLS encryption:

First, generate a self-signed certificate using the following command:

```
$ openssl req -new -x509 -sha256 -days 1095 -newkey rsa:2048 \
              -keyout fluentd.key -out fluentd.crt
# Note that during the generation, you will be asked for:
#  - a password (to encrypt the private key), and
#  - subject information (to be included in the certificate)
```

Move the generated certificate and private key to a safer place. For
example:

```
# Move files into /etc/td-agent
$ sudo mkdir -p /etc/td-agent/certs
$ sudo mv fluentd.key fluentd.crt /etc/td-agent/certs

# Set strict permissions
$ sudo chown td-agent:td-agent -R /etc/td-agent/certs
$ sudo chmod 700 /etc/td-agent/certs/
$ sudo chmod 400 /etc/td-agent/certs/fluentd.key
```

Then add the following settings to `td-agent.conf`, and then restart the
service:

```
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

To test your encryption settings, execute the following command in your
terminal. If the encryption is working properly, you should see a line
containing `{"foo":"bar"}` in the log file:

```
$ echo -e '\x93\xa9debug.tls\xceZr\xbc1\x81\xa3foo\xa3bar' | \
  openssl s_client -connect localhost:24224
```

If you can confirm TLS encryption has been set up correctly, please proceed to [the configuration of the out\_forward server](/plugins/output/forward.md/#how-to-connect-to-a-tls/ssl-enabled-server).


### How to Enable TLS Mutual Authentication

Since v1.1.1, Fluentd supports [TLS mutual authentication](https://en.wikipedia.org/wiki/Mutual_authentication)
(a.k.a. client certificate auth). If you want to use this feature,
please set the `client_cert_auth` and `ca_path` options as follows.

```
<source>
  @type forward
  <transport tls>
    ...
    client_cert_auth true
    ca_path /path/to/ca/cert
  </transport>
</source>
```

When this feature is enabled, Fluentd will check all incoming requests
for a client certificate signed by the trusted CA. Requests that don't
supply a valid client certificate will fail.

To check if mutual authentication is working properly, issue the
following command:

```
$ openssl s_client -connect localhost:24224 \
  -key path/to/client.key \
  -cert path/to/client.crt \
  -CAfile path/to/ca.crt
```

If the connection gets established successfully, your setup is working
fine.

+For fluentd and fluent-bit combination, see Banzai Cloud article:
[Secure logging on Kubernetes with Fluentd and Fluent Bit](https://banzaicloud.com/blog/k8s-logging-tls/)

### How to Enable Password Authentication

Fluentd is equipped with a password-based authentication mechanism,
which allows you to verify the identity of each client using a shared
secret key.

To enable this feature, you need to add a `<security>` section to your
configuration file as below.

```
<source>
  @type forward
  <security>
    self_hostname YOUR_SERVER_NAME
    shared_key PASSWORD
  </security>
</source>
```

Once you've done the setup, you have to configure your clients
accordingly. For example, if you have an `out_forward` instance running
on another server, please [configure it following the instruction](/plugins/output/forward.md/#how-to-enable-password-authentication).


### Multi-process environment

If you use this plugin under multi-process environment, port will be
shared.

```
<system>
  workers 3
</system>

<source>
  @type forward
  port 24224
</source>
```

With this configuration, 3 workers share 24224 port. No need additional
port. Incoming data will be routed to 3 workers automatically.


## FAQ


### Why in\_forward doesn't have tag parameter?

`in_forward` uses `tag` of incoming events so no fixed `tag` parameter.
See above "Protocol" section.


### How to parse incoming events?

`in_forward` doesn't provide parsing mechanism unlike `in_tail` or
`in_tcp` because `in_forward` is mainly for efficient log transfer. If
you want to parse incoming event, use [parser filter](https://github.com/tagomoris/fluent-plugin-parser) in your
pipeline.\
See Docker logging driver usecase: [Docker Logging](http://www.fluentd.org/guides/recipes/docker-logging)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.

