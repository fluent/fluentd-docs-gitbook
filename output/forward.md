# forward

![](../.gitbook/assets/forward%20%281%29.png)

The `out_forward` Buffered Output plugin forwards events to other fluentd nodes. This plugin supports load-balancing and automatic fail-over \(i.e. active-active backup\). For replication, please use [`out_copy`](copy.md) plugin.

The `out_forward` plugin detects server faults using a **φ accrual failure detector** algorithm. You can customize the parameters of the algorithm. When a server fault recovers, the plugin makes the server available automatically after a few seconds.

The `out_forward` plugin supports **at-most-once** and **at-least-once** semantics. The default is **at-most-once**.

It is included in Fluentd's core.

## Example Configuration

```text
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

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

## Supported Modes

* Synchronous
* Asynchronous

See [Output Plugin Overview](./) for more details.

## Plugin Helpers

* [`socket`](../plugin-helper-overview/api-plugin-helper-socket.md)
* [`server`](../plugin-helper-overview/api-plugin-helper-server.md)
* [`timer`](../plugin-helper-overview/api-plugin-helper-timer.md)
* [`thread`](../plugin-helper-overview/api-plugin-helper-thread.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type`

The value must be `forward`.

### `<server>` \(at least one is required\)

| required | multi | version |
| :--- | :--- | :--- |
| true | true | 0.14.5 |

The destination servers. Each server has the following parameters:

* `host`
* `name`
* `port`
* `shared_key`
* `username`
* `password`
* `standby`
* `weight`

If you want to manage destination servers by flexible approach, use `<service_discovery>` instead.

#### `host`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.5 |

The IP address or host name of the server.

#### `name`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.5 |

The name of the server. Used for logging and certificate verification in TLS transport \(when the host is the address\).

#### `port`

| type | default | version |
| :--- | :--- | :--- |
| integer | 24224 | 0.14.5 |

The port number of the host. Note that both TCP packets \(event stream\) and UDP packets \(heartbeat messages\) are sent to this port.

#### `shared_key`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.5 |

The shared key per server.

#### `username`

| type | default | version |
| :--- | :--- | :--- |
| string | "" \(empty string\) | 0.14.5 |

The username for authentication.

#### `password`

| type | default | version |
| :--- | :--- | :--- |
| string | "" \(empty string\) | 0.14.5 |

The password for authentication.

#### `standby`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.5 |

Marks a node as the standby node for an Active-Standby model between Fluentd nodes. When an active node goes down, the standby node is promoted to an active node. The standby node is not used by the `out_forward` plugin until then.

```text
<match pattern>
  @type forward
  # ...

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
  # ...
</match>
```

#### `weight`

| type | default | version |
| :--- | :--- | :--- |
| integer | 60 | 0.14.5 |

The load balancing weight. If the weight of one server is 20 and the weight of the other server is 30, events are sent in a 2:3 ratio. The default weight is 60.

### `<service_discovery>`

Use service discovery plugin instead of fixed `<server>` list. See also [Service Discovery Plugin Overview](../service_discovery/) for more details.

```text
<match pattern>
  @type forward

  <service_discovery>
    @type file
    path /path/to/servers.yaml
  </service_discovery>
</source>
```

### `require_ack_response`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

Changes the protocol to **at-least-once**. The plugin waits the ack from destination's `in_forward` plugin.

### `ack_response_timeout`

| type | default | version |
| :--- | :--- | :--- |
| time | 190 | 0.14.0 |

This option is used when `require_ack_response` is `true`. This default value is based on popular `tcp_syn_retries`.

If set `0`, this plugin does not wait for the ack response.

### `send_timeout`

| type | default | version |
| :--- | :--- | :--- |
| time | 60 | 0.14.0 |

The timeout time when sending event logs.

### `connect_timeout`

| type | default | version |
| :--- | :--- | :--- |
| time | nil\(no timeout\) | 1.6.0 |

The connection timeout for the socket. When the connection is timed out during the connection establishment, `Errno::ETIMEDOUT` error is raised.

### `recover_wait`

| type | default | version |
| :--- | :--- | :--- |
| time | 10 | 0.14.0 |

The wait time before accepting a server fault recovery.

### `heartbeat_type`

| type | default | available | version |
| :--- | :--- | :--- | :--- |
| enum | transport | transport, tcp, udp, none | 0.14.12 |

Specifies the transport protocol for heartbeats. Set `none` to disable.

### `heartbeat_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | 1 | 0.14.0 |

The interval of the heartbeat packer.

### `phi_failure_detector`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.0 |

Use the "Phi accrual failure detector" to detect server failure.

### `phi_threshold`

| type | default | version |
| :--- | :--- | :--- |
| integer | 16 | 0.14.0 |

The threshold parameter used to detect server faults.

`phi_threshold` is directly related to `heartbeat_interval`. If you are using longer `heartbeat_interval`, please use the larger `phi_threshold`. Otherwise, you will see frequent detachments of destination servers. The default value 16 is tuned for `heartbeat_interval` 1s.

### `hard_timeout`

| type | default | version |
| :--- | :--- | :--- |
| time | 60 | 0.14.0 |

The hard timeout used to detect server failure. The default value is equal to the `send_timeout` parameter.

### `expire_dns_cache`

| type | default | version |
| :--- | :--- | :--- |
| time | nil \(persistent cache\) | 0.14.0 |

Sets TTL to expire DNS cache in seconds. Set 0 not to use DNS Cache.

### `dns_round_robin`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

Enable client-side DNS round robin. Uniform randomly pick an IP address to send data when a hostname has several IP addresses.

`heartbeat_type udp` is not available with `dns_round_robintrue`. Use `heartbeat_type tcp` or `heartbeat_type none`.

### `ignore_network_errors_at_startup`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.12 |

Ignores DNS resolution and errors at startup time.

### `tls_version`

| type | default | available | version |
| :--- | :--- | :--- | :--- |
| enum | `TLSv1_2` | `TLSv1_1`, `TLSv1_2` | 0.14.12 |

The default version of TLS transport.

### `tls_ciphers`

| type | default | version |
| :--- | :--- | :--- |
| string | ALL:!aNULL:!eNULL:!SSLv2 \(OpenSSL &gt; 1.0.0 default\) | 0.14.12 |

The cipher configuration of TLS transport.

### `tls_insecure_mode`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.12 |

Skips all verification of certificates or not.

### `tls_allow_self_signed_cert`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.12 |

Allows self-signed certificates or not.

### `tls_verify_hostname`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.12 |

Verifies hostname of servers and certificates or not in TLS transport.

If the following conditions are met, you must set `tls_verify_hostname false` explicitly to forward events correctly:

* specify `host` in `<server>` section with IP address, not hostname
* specify server certificate file with `tls_cert_path` which contains common name (CN) field with IP address, not hostname

### `tls_cert_path`

| type | default | version |
| :--- | :--- | :--- |
| array of string | nil | 0.14.12 |

The additional CA certificate path for TLS.

### `tls_client_cert_path`

| type | default | version |
| :---: | :---: | :---: |
| string | nil | 1.3.2 |

The client certificate path for TLS.

### `tls_client_private_key_path`

| type | default | version |
| :---: | :---: | :---: |
| string | nil | 1.3.2 |

The client private key path for TLS.

### `tls_client_private_key_passphrase`

| type | default | version |
| :---: | :---: | :---: |
| string | nil | 1.3.2 |

The TLS private key passphrase for the client.

### `tls_cert_thumbprint`

| type | default | version |
| :---: | :---: | :---: |
| string | nil | 1.7.1 |

The certificate thumbprint for searching from Windows system certstore. This parameter is for Windows only.

### `tls_cert_logical_store_name`

| type | default | version |
| :---: | :---: | :---: |
| string | nil | 1.7.1 |

The certificate logical store name on Windows system certstore. This parameter is for Windows only.

### `tls_cert_use_enterprise_store`

| type | default | version |
| :---: | :---: | :---: |
| string | true | 1.7.1 |

Enables the certificate enterprise store on Windows system certstore. This parameter is for Windows only.

### `keepalive`

| type | default | version |
| :---: | :---: | :---: |
| bool | false | 1.5.0 |

Enables the keepalive connection.

### `keepalive_timeout`

| type | default | version |
| :---: | :---: | :---: |
| time | nil | 1.5.0 |

Timeout for keepalive. Default value is `nil` which means to keep the connection alive as long as possible.

### `<security>` Section

| required | multi | version |
| :--- | :--- | :--- |
| false | false | 0.14.5 |

This section contains parameters related to authentication:

* `self_hostname`
* `shared_key`

#### `self_hostname`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.5 |

The hostname.

#### `shared_key`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.5 |

The shared key for authentication. If you want to specify `shared_key` for specific server, use the `<server>` section.

### `<secondary>`

| required | multi | version |
| :--- | :--- | :--- |
| false | false | 0.14.0 |

The backup destination that is used when all servers are unavailable.

For more details, see [Secondary Output](./#secondary-output).

### `verify_connection_at_startup`

| type | default | version |
| :---: | :---: | :---: |
| bool | false | 1.3.1 |

Verify that a connection can be made with one of `out_forward` nodes at the time of startup.

### `<buffer>`

See [Buffer Section Configurations](../configuration/buffer-section.md) for more details.

#### `chunk_keys`

| type | default | version |
| :--- | :--- | :--- |
| array | tag | 0.14.9 |

Overwrites the default value in this plugin.

## Tips and Tricks

### How to connect to a TLS/SSL enabled server?

If you have set up [TLS/SSL encryption](../input/forward.md#how-to-enable-tls/ssl-encryption) for the receiving server, you need to tell the output forwarder to use encryption by setting the `transport` parameter:

```text
<match debug.**>
  @type forward
  transport tls
  <server>
    host example.com
    port 24224
  </server>
</match>
```

If you are using a self-singed certificate, copy the certificate file to the forwarding server, then add the following settings:

```text
<match debug.**>
  @type forward
  transport tls
  tls_cert_path /path/to/fluentd.crt # Set the path to the certificate file.
  <server>
    # Set the remote server name. This name should match the Common Name
    # field in the certificate.
    host example.com
    port 24224
  </server>
</match>
```

After updating the settings, please confirm that the forwarded data is being received by the destination node properly.

### How to connect to a TLS/SSL enabled server with Windows Certstore Certificate?

If you have set up [TLS/SSL encryption](../input/forward.md#how-to-enable-tls/ssl-encryption) in the receiving server, you need to tell the output forwarder to use encryption by setting the `transport` parameter.

Valid logical store names are:

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

Logical store name is case-insensitive. Note that this section configurations work only for Windows.

```text
<match debug.**>
  @type forward
  transport tls
  # Set valid logical store name.
  tls_cert_logical_store_name Trust
  tls_verify_hostname true # Set false to ignore the cert hostname.
  <server>
    host 192.168.1.2
    port 24224
  </server>
</match>
```

If you are using a self-signed certificate, export the certificate file from Windows Certstore and copy to the forwarding server, then add the following settings:

```text
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

Note that these configuration works for root certificate which is put in Windows Certstore. Currently, the chained certificate is not supported.

Certificate thumbprint is able to obtain with [`certutil`](https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/certutil) command.

Here is an example which uses a certificate that is generated by `fluent-ca-generate` command:

```text
PS> certutil -store -enterprise <YOUR CERTIFICATE STORE NAME>
trust "Enterprise Trust"
================ Certificate 0 ================
Serial Number: 01
Issuer: CN=Fluentd Forward CA, L=Mountain View, S=CA, C=US
 NotBefore: 1/1/1970 12:00 AM
 NotAfter: 8/21/2024 7:43 AM
Subject: CN=Fluentd Forward CA, L=Mountain View, S=CA, C=US
Signature matches Public Key
Root Certificate: Subject matches Issuer
Cert Hash(sha1): <YOUR CERTIFICATE THUMBPRINT>
No key provider information
Cannot find the certificate and private key for decryption.
CertUtil: -store command completed successfully.
```

`Cert hash(sha1)` is called as thumbprint in this section.

Note that `-enterprise` flag represents to use enterprise certstore. Please pay attention to using whether enterprise certificates store or not.

### How to Enable Password Authentication?

If you want to connect to a server that requires [password authentication](../input/forward.md#how-to-enable-password-authentication), you need to set your credentials in the configuration file:

```text
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

Note that, as to the option `self_hostname`, you need to set the name of the server on which your `out_forward` instance is running. In the current implementation, it is considered invalid if your `in_forward` and `out_forward` share the same `hostname`.

### How to enable `gzip` compression?

Since v0.14.7, Fluentd supports transparent data compression. You can use this feature to reduce the transferred payload size.

To enable this feature, set the `compress` option as follows:

```text
<match debug.**>
  @type forward
  compress gzip
  <server>
    host 192.168.1.2
    port 24224
  </server>
</match>
```

You do not need any configuration in the receiving server. Data compression is auto-detected and handled transparently by the destination node.

### What is a Phi accrual failure detector?

Fluentd implements an adaptive failure detection mechanism called "Phi accrual failure detector". Here is how it works:

1. Each `in_forward` node sends heartbeat packets to its `out_forward` server

   with a regular interval.

2. The `out_forward` server records the arrival time of heartbeat packets sent

   by each node.

3. If the server does not receive a heartbeat from one of its nodes for "a long

   time", it assumes the node is down.

But how long should the server wait before detaching a node? The phi accrual failure detector answers this question by computing the probability of a node being down based on the assumption that heartbeat intervals follow normal distribution. Internally, it represents the confidence of a node being down by a continuous function **φ\(t\)** which grows as the time from the last packet increases.

For example, suppose that the historical average interval is 1 second and the standard deviation is 1, it is unlikely that the node is still being active when its heartbeat has not been received for the last 10 seconds.

For details, please read the original paper: [Hayashibara, Naohiro, et al. "The φ accrual failure detector." IEEE, 2004.](https://scholar.google.com/scholar?cluster=12946656837229314866)

## Troubleshooting

### "no nodes are available"

Please make sure that you can communicate with port 24224 using **not only TCP, but also UDP**. These commands will be useful for checking the network configuration:

```text
$ telnet host 24224
$ nmap -p 24224 -sU host
```

Please note that there is one [known issue](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2019944) where VMware will occasionally lose small UDP packets used for heartbeat.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

