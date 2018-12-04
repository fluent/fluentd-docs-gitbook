# forward Input Plugin

![][image_plugin_in_forward]

The `in_forward` Input plugin listens to a TCP socket to receive the
event stream. It also listens to an UDP socket to receive heartbeat
messages.

This plugin is mainly used to receive event logs from other Fluentd
instances, the fluent-cat command, or client libraries. This is by far
the most efficient way to retrieve the records.


## Example Configuration

`in_forward` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>
```

Please see the [Config FIle](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.


## Plugin helpers

-   [server](/articles/api-plugin-helper-server.md)


## Parameters

-   [Common Parameters](/configuration/plugin-common-parameters.md)
-   [Transport section](/articles/transport-section.md)

[]{#@type}

### \@type

The value must be `forward`.


### port

    type     default   version
  --------- --------- ---------
   integer    24224    0.14.0

The port to listen to.


### bind

    type            default           version
  -------- ------------------------- ---------
   string   0.0.0.0 (all addresses)   0.14.0

The bind address to listen to.


### linger\_timeout

    type     default   version
  --------- --------- ---------
   integer      0      0.14.0

The timeout time used to set linger option.


### resolve\_hostname

   type   default   version
  ------ --------- ---------
   bool    false    0.14.10

Try to resolve hostname from IP addresses or not.


### deny\_keepalive

   type   default   version
  ------ --------- ---------
   bool    false    0.14.5

Connections will be disconnected right after receiving first message if
this value is true.


### chunk\_size\_limit

   type      default       version
  ------ ---------------- ---------
   size   nil (no limit)   0.14.0

The size limit of the the received chunk. If the chunk size is larger
than this value, then the received chunk is dropped.


### chunk\_size\_warn\_limit

   type       default        version
  ------ ------------------ ---------
   size   nil (no warning)   0.14.0

The warning size limit of the received chunk. If the chunk size is
larger than this value, a warning message will be sent.


### skip\_invalid\_event

   type   default   version
  ------ --------- ---------
   bool    false    0.14.0

Skip an event if incoming event is invalid.

This option is useful at forwarder, not aggragator.


### source\_address\_key

    type            default           version
  -------- ------------------------- ---------
   string   nil (no adding address)   0.14.11

The field name of the client's source address. If set the value, the
client's address will be set to its key.


### source\_hostname\_key

    type            default            version
  -------- -------------------------- ---------
   string   nil (no adding hostname)   0.14.4

The field name of the client's hostname. If set the value, the client's
hostname will be set to its key.

This iterates incoming events. So if you sends larger chunks to
`in_forward`, it needs additional processing time.

[]{#<transport>-section}

### \<transport\> section

This section is for using SSL transport.

``` {.CodeRay}
<transport tls>
  cert_path /path/to/fluentd.crt
  # other parameters
</transport>
```

See "How to Enable TLS Encryption" section for how to use and see
["Configuration example" in "Server Plugin Helper" article](/articles/api-plugin-helper-server.md/#configuration-example) for
supported parameters

Without `<transport tls>`, in\_forward uses raw TCP.

[]{#<security>-section}

### \<security\> section

   required   multi   version
  ---------- ------- ---------
    false     false   0.14.5

This section contains parameters related to authentication.

#### self\_hostname

    type         default         version
  -------- -------------------- ---------
   string   required parameter   0.14.5

The hostname.

#### shared\_key

    type         default         version
  -------- -------------------- ---------
   string   required parameter   0.14.5

Shared key for authentication.

#### user\_auth

   type   default   version
  ------ --------- ---------
   bool    false    0.14.5

If true, use user based authentication.

#### allow\_anonymous\_source

   type   default   version
  ------ --------- ---------
   bool    true     0.14.5

Allow anonymous source. `<client>` sections are required if disabled.

#### \<user\> section

   required   multi   version
  ---------- ------- ---------
    false     true    0.14.5

This section contains user based authentication.

##### username

    type         default         version
  -------- -------------------- ---------
   string   required parameter   0.14.5

The username for authentication.

##### password

    type         default         version
  -------- -------------------- ---------
   string   required parameter   0.14.5

The password for authentication.

#### \<client\> section

   required   multi   version
  ---------- ------- ---------
    false     true    0.14.5

This section contains that client IP/Network authentication and shared
key per host.

##### host

    type    default   version
  -------- --------- ---------
   string     nil     0.14.5

The IP address or host name of the client.

This is exclusive with `network`.

##### network

    type    default   version
  -------- --------- ---------
   string     nil     0.14.5

Network address specification.

This is exclusive with `host`.

##### shared\_key

    type    default   version
  -------- --------- ---------
   string     nil     0.14.5

Shared key per client.

##### users

   type    default   version
  ------- --------- ---------
   array    `[]`     0.14.5

Array of username.


## Protocol

This plugin accepts both JSON or [MessagePack](http://msgpack.org/)
messages and automatically detects which is used. Internally, Fluent
uses MessagePack as it is more efficient than JSON.

The time value is a EventTime or a platform specific integer and is
based on the output of Ruby's `Time.now.to_i` function. On Linux, BSD
and MAC systems, this is the number of seconds since 1970.

Multiple messages may be sent in the same connection.

``` {.CodeRay}
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

``` {.CodeRay}
$ openssl req -new -x509 -sha256 -days 1095 -newkey rsa:2048 \
              -keyout fluentd.key -out fluentd.crt
# Note that during the generation, you will be asked for:
#  - a password (to encrypt the private key), and
#  - subject information (to be included in the certificate)
```

Move the generated certificate and private key to a safer place. For
example:

``` {.CodeRay}
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

``` {.CodeRay}
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

``` {.CodeRay}
$ echo -e '\x93\xa9debug.tls\xceZr\xbc1\x81\xa3foo\xa3bar' | \
  openssl s_client -connect localhost:24224
```

If you can confirm TLS encryption has been set up correctly, please proceed to [the configuration of the out\_forward server](/plugins/output/forward.md/#how-to-connect-to-a-tls/ssl-enabled-server).


### How to Enable TLS Mutual Authentication

Since v1.1.1, Fluentd supports [TLS mutual authentication](https://en.wikipedia.org/wiki/Mutual_authentication)
(a.k.a. client certificate auth). If you want to use this feature,
please set the `client_cert_auth` and `ca_path` options as follows.

``` {.CodeRay}
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

``` {.CodeRay}
$ openssl s_client -connect localhost:24224 \
  -key path/to/client.key \
  -cert path/to/client.crt \
  -CAfile path/to/ca.crt
```

If the connection gets established successfully, your setup is working
fine.


### How to Enable Password Authentication

Fluentd is equipped with a password-based authentication mechanism,
which allows you to verify the identity of each client using a shared
secret key.

To enable this feature, you need to add a `<security>` section to your
configuration file as below.

``` {.CodeRay}
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

``` {.CodeRay}
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

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.

[image_plugin_in_forward]:data:image/png;base64,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
