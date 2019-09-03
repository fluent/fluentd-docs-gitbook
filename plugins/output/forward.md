# forward Output Plugin

![](/images/plugins/output/forward.png)

The `out_forward` Buffered Output plugin forwards events to other
fluentd nodes. This plugin supports load-balancing and automatic
fail-over (a.k.a. active-active backup). For replication, please use the
[out\_copy](/plugins/output/copy.md) plugin.

The `out_forward` plugin detects server faults using a "φ accrual
failure detector" algorithm. You can customize the parameters of the
algorithm. When a server fault recovers, the plugin makes the server
available automatically after a few seconds.

The `out_forward` plugin supports at-most-once and at-least-once
semantics. The default is at-most-once.


## Example Configuration

`out_forward` is included in Fluentd's core. No additional installation
process is required.

```
<match pattern>
  @type forward
  send_timeout 60s
  recover_wait 10s
  hard_timeout 60s

  <server>
    name myserver1
    host 192.168.1.3
    port 24224
    weight 60
  </server>
  <server>
    name myserver2
    host 192.168.1.4
    port 24224
    weight 60
  </server>
  ...

  <secondary>
    @type file
    path /var/log/fluent/forward-failed
  </secondary>
</match>
```

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.


## Supported modes

-   Synchronous
-   Asynchronous

See [Output Plugin Overview](/plugins/output/README.md) for more details.


## Plugin helpers

-   [socket](/developer/api-plugin-helper-socket.md)
-   [server](/developer/api-plugin-helper-server.md)
-   [timer](/developer/api-plugin-helper-timer.md)
-   [thread](/developer/api-plugin-helper-thread.md)
-   [compat\_parameters](/developer/api-plugin-helper-compat_parameters.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

### @type

The value must be `forward`.


### &lt;server&gt; (at least one is required)

| required | multi | version |
|:---------|:------|:--------|
| true     | true  | 0.14.5  |

The destination servers. Each server has following parameters.

- host
- name
- port
- shared\_key
- username
- password
- standby
- weight
 
#### host

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.5  |

The IP address or host name of the server.

#### name

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.5  |

The name of the server. Used for logging and certificate verification in
TLS transport (when host is address).

#### port

| type    | default | version |
|:--------|:--------|:--------|
| integer | 24224   | 0.14.5  |

The port number of the host. Note that both TCP packets (event stream)
and UDP packets (heartbeat message) are sent to this port.

#### shared\_key

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.5  |

The shared key per server.

#### username

| type   | default           | version |
|:-------|:------------------|:--------|
| string | "" (empty string) | 0.14.5  |

The username for authentication.

#### password

| type   | default           | version |
|:-------|:------------------|:--------|
| string | "" (empty string) | 0.14.5  |

The password for authentication.

#### standby

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.5  |

Marks a node as the standby node for an Active-Standby model between
Fluentd nodes. When an active node goes down, the standby node is
promoted to an active node. The standby node is not used by the
`out_forward` plugin until then.

```
<match pattern>
  @type forward
  ...

  <server>
    name myserver1
    host 192.168.1.3
    weight 60
  </server>
  <server>  # forward doesn't use myserver2 until myserver1 goes down
    name myserver2
    host 192.168.1.4
    weight 60
    standby
  </server>
  ...
</match>
```

#### weight

| type    | default | version |
|:--------|:--------|:--------|
| integer | 60      | 0.14.5  |

The load balancing weight. If the weight of one server is 20 and the
weight of the other server is 30, events are sent in a 2:3 ratio. The
default weight is 60.


### require\_ack\_response

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.0  |

Change the protocol to at-least-once. The plugin waits the ack from
destination's in\_forward plugin.


### ack\_response\_timeout

| type | default | version |
|:-----|:--------|:--------|
| time | 190     | 0.14.0  |

This option is used when `require_ack_response` is `true`. This default
value is based on popular `tcp_syn_retries`.

If set `0`, this plugin doesn't wait the ack response.


### send\_timeout

| type | default | version |
|:-----|:--------|:--------|
| time | 60      | 0.14.0  |

The timeout time when sending event logs.

### connect\_timeout

| type | default | version |
|:-----|:--------|:--------|
| time | nil(no timeout) | 1.6.0 |

The timeout time for socket connect. When the connection timed out during establishment, Errno::ETIMEDOUT is raised.

### recover\_wait

| type | default | version |
|:-----|:--------|:--------|
| time | 10      | 0.14.0  |

The wait time before accepting a server fault recovery.


### heartbeat\_type

| type | default   | available                 | version |
|:-----|:----------|:--------------------------|:--------|
| enum | transport | transport, tcp, udp, none | 0.14.12 |

The transport protocol to use for heartbeats. Set "none" to disable
heartbeat.


### heartbeat\_interval

| type | default | version |
|:-----|:--------|:--------|
| time | 1       | 0.14.0  |

The interval of the heartbeat packer.


### phi\_failure\_detector

| type | default | version |
|:-----|:--------|:--------|
| bool | true    | 0.14.0  |

Use the "Phi accrual failure detector" to detect server failure.


### phi\_threshold

| type    | default | version |
|:--------|:--------|:--------|
| integer | 16      | 0.14.0  |

The threshold parameter used to detect server faults.

\`phi\_threshold\` is deeply related to \`heartbeat\_interval\`. If you
are using longer \`heartbeat\_interval\`, please use the larger
\`phi\_threshold\`. Otherwise you will see frequent detachments of
destination servers. The default value 16 is tuned for
\`heartbeat\_interval\` 1s.


### hard\_timeout

| type | default | version |
|:-----|:--------|:--------|
| time | 60      | 0.14.0  |

The hard timeout used to detect server failure. The default value is
equal to the `send_timeout` parameter.


### expire\_dns\_cache

| type | default                | version |
|:-----|:-----------------------|:--------|
| time | nil (persistent cache) | 0.14.0  |

Set TTL to expire DNS cache in seconds. Set 0 not to use DNS Cache.


### dns\_round\_robin

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.0  |

Enable client-side DNS round robin. Uniform randomly pick an IP address
to send data when a hostname has several IP addresses.

\`heartbeat\_type udp\` is not available with \`dns\_round\_robin
true\`. Use \`heartbeat\_type tcp\` or \`heartbeat\_type none\`.


### ignore\_network\_errors\_at\_startup

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.12 |

Ignore DNS resolution and errors at startup time.


### tls\_version

| type | default  | available          | version |
|:-----|:---------|:-------------------|:--------|
| enum | TLSv1\_2 | TLSv1\_1, TLSv1\_2 | 0.14.12 |

The default version of TLS transport.


### tls\_ciphers

| type   | default                                             | version |
|:-------|:----------------------------------------------------|:--------|
| string | ALL:!aNULL:!eNULL:!SSLv2 (OpenSSL \> 1.0.0 default) | 0.14.12 |

The cipher configuration of TLS transport.


### tls\_insecure\_mode

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.12 |

Skip all verification of certificates or not.


### tls\_allow\_self\_signed\_cert

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.12 |

Allow self signed certificates or not.


### tls\_verify\_hostname

| type | default | version |
|:-----|:--------|:--------|
| bool | true    | 0.14.12 |

Verify hostname of servers and certificates or not in TLS transport.


### tls\_cert\_path

| type            | default | version |
|:----------------|:--------|:--------|
| array of string | nil     | 0.14.12 |

The additional CA certificate path for TLS.

### tls\_client\_cert\_path

| type   | default | version |
|:------:|:-------:|:-------:|
| string | nil     | 1.3.2   |

The client certificate path for TLS

### tls\_client\_private\_key\_path

| type   | default | version |
|:------:|:-------:|:-------:|
| string | nil     | 1.3.2   |

The client private key path for TLS.

### tls\_client\_private\_key\_passphrase

| type   | default | version |
|:------:|:-------:|:-------:|
| string | nil     | 1.3.2   |

The client private key passphrase for TLS.

### tls\_cert\_thumbprint

| type   | default | version |
|:------:|:-------:|:-------:|
| string | nil     | 1.7.1   |

The certificate thumbprint for searching from Windows system certstore
This parameter is for Windows only.

### tls\_cert\_logical\_store\_name,

| type   | default | version |
|:------:|:-------:|:-------:|
| string | nil     | 1.7.1   |

The certificate logical store name on Windows system certstore.
This parameter is for Windows only.

### tls\_cert\_use\_enterprise\_store

| type   | default | version |
|:------:|:-------:|:-------:|
| string | true    | 1.7.1   |

Enable to use certificate enterprise store on Windows system certstore.
This parameter is for Windows only.

### keepalive

| type | default | version |
|:----:|:-------:|:-------:|
| bool | fales    | 1.5.0  |

Enable keepalive connection.

### keepalive\_timeout

| type | default | version |
|:----:|:-------:|:-------:|
| time | nil     | 1.5.0   |

Expired time of keepalive. Default value is nil, which means to keep connection
as long as possible.

### &lt;security&gt; section

| required | multi | version |
|:---------|:------|:--------|
| false    | false | 0.14.5  |

This section contains parameters related to authentication.

- self\_hostname
- shared\_key

#### self\_hostname

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.5  |

The hostname.

#### shared\_key

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.5  |

Shared key for authentication. If you want to specify `shared_key`
for specific server, use `<server>` section.

### &lt;secondary&gt;

| required | multi | version |
|:---------|:------|:--------|
| false    | false | 0.14.0  |

The backup destination that is used when all servers are unavailable.

For more details, see [Secondary Output](/plugins/output/README.md/#secondary-output).

### verify\_connection\_at\_startup

| type | default | version |
|:----:|:-------:|:-------:|
| bool | false   | 1.3.1   |

Verify that a connection can be made with one of `out_forward` nodes
at the time of startup.

## Tips & Tricks


### How to connect to a TLS/SSL enabled server

If you've [set up TLS/SSL encryption in the receiving server](/plugins/input/forward.md/#how-to-enable-tls/ssl-encryption), you need to tell
the output forwarder to use encryption by setting the `transport`
parameter:

```
<match debug.**>
  @type forward
  transport tls
  <server>
    host 192.168.1.2
    port 24224
  </server>
</match>
```

If you're using a self-singed certificate, copy the certificate file to
the forwarding server, then add the following settings:

```
<match debug.**>
  @type forward
  transport tls
  tls_cert_path /path/to/fluentd.crt # Set the path to the certificate file.
  tls_verify_hostname true           # Set false to ignore cert hostname.
  <server>
    host 192.168.1.2
    port 24224
  </server>
</match>
```

After updating the settings, please confirm that the forwarded data is
being received by the destination node properly.

### How to connect to a TLS/SSL enabled server with Windows Certstore Certificate

If you've [set up TLS/SSL encryption in the receiving server](/plugins/input/forward.md/#how-to-enable-tls/ssl-encryption), you need to tell
the output forwarder to use encryption by setting the `transport`
parameter.

Valid logical store name are:

* MY
* CA
* ROOT
* AUTHROOT
* DISALLOWED
* SPC
* TRUST
* TRUSTEDPEOPLE
* TRUSTEDPUBLISHER
* CLIENTAUTHISSUER
* TRUSTEDDEVICES
* SMARTCARDROOT
* WEBHOSTING
* REMOTE DESKTOP

Logical store name is case-insensitive.
Note that this section configurations work on only Windows.

```
<match debug.**>
  @type forward
  transport tls
  # Set valid logical store name.
  tls_cert_logical_store_name Trust
  tls_verify_hostname true # Set false to ignore cert hostname.
  <server>
    host 192.168.1.2
    port 24224
  </server>
</match>
```

If you're using a self-signed certificate, export the certificate file
from Windows Certstore and copy to the forwarding server,
then add the following settings:

```
<match debug.**>
  @type forward
  transport tls
  # Set certificate SHA1 hash which is usually called as thumbprint.
  tls_cert_thumbprint <YOUR CERTIFICATE THUMBPRINT>
  tls_cert_logical_store_name Trust
  tls_verify_hostname true # Set false to ignore cert hostname.
  tls_cert_use_enterprise_store true # Set false to use non-enterprise certificate.
  <server>
    host 192.168.1.2
    port 24224
  </server>
</match>
```

Note that these configuration works for root certificate which is put in Windows Certstore.
Currently, chained certificate is not supported.

### How to Enable Password Authentication

If you want to connect to [a server that requires password authentication](/plugins/input/forward.md/#how-to-enable-password-authentication), you
need to set your credentials in the configuration file.

```
<match debug.**>
  @type forward
  <server>
    host 192.168.1.2
    port 24224
  </server>
  <security>
    self_hostname HOSTNAME
    shared_key secret
  </security>
</match>
```

Note that, as to the option `self_hostname`, you need to set the name of
the server on which your `out_forward` instance is running. In the
current implementation, it is considered invalid if your `in_forward`
and `out_forward` shares the same hostname.


### How to enable gzip compression

Since v0.14.7, Fluentd supports transparent data compression. You can
use this feature to reduce the transferred payload size.

To enable this feature, set the `compress` option as follows:

```
<match debug.**>
  @type forward
  compress gzip
  <server>
    host 192.168.1.2
    port 24224
  </server>
</match>
```

You don't need any configuration in the receiving server. Data
compression is auto-detected and handled transparently by the
destination node.


### What is a Phi accrual failure detector?

Fluentd implements an adaptive failure detection mechanism called "Phi
accrual failure detector". Here is how it works:

1.  Each `in_forward` node sends heartbeat packets to its `out_foward`
    server at a regular interval.
2.  The `out_forward` server records the arrival time of heartbeat
    packets sent by each node.
3.  If the server does not receive a heartbeat from one of its nodes for
    "a long time", it assumes the node is down.

But how long should the server wait before detaching a node? The phi
accrual failure detector answers this question by computing the
probability of a node being down based on the assumption that heartbeat
intervals follow normal distribution. Internally it represent the
confidence of a node being down by a continuous function *φ(t)* which
grows as the time from the last packet increases.

For example, suppose that the historical average interval is 1 seconds
and the standard deviation is 1, it's not likely that the node is still
being active when its heartbeat does not arrive for the last 10 seconds.

For details, please read the original paper: [Hayashibara, Naohiro, et al. "The φ accrual failure detector." IEEE, 2004.](https://scholar.google.com/scholar?cluster=12946656837229314866)


## Troubleshooting


### "no nodes are available"

Please make sure that you can communicate with port 24224 using **not
only TCP, but also UDP**. These commands will be useful for checking the
network configuration.

```
$ telnet host 24224
$ nmap -p 24224 -sU host
```

Please note that there is one [known issue](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2019944)
where VMware will occasionally lose small UDP packets used for
heartbeat.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
