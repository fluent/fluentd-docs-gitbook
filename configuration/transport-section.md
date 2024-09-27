# Config: Transport Section

Some Fluentd input, output, and filter plugins, that use `server`/`http_server` plugin helper, also support the `<transport>` section to specify how to handle the connections.

## Transport Section Overview

The **`transport`** section must be under `<match>`, `<source>`, and `<filter>` sections. It specifies the transport protocol, version, and certificates.

```text
# tcp
<transport tcp>
</transport>

# udp
<transport udp>
</transport>

# tls
<transport tls>
  cert_path /path/to/fluentd.crt
  private_key_path /path/to/fluentd.key
  private_key_passphrase YOUR_PASSPHRASE
  # ...
</transport>
```

## Parameters

### Protocol

The protocol is specified as the argument of `<transport>` section.

```
<transport PROTOCOL>
</transport>
```

* \[enum: `tcp`/`udp`/`tls`\]
  * Default: `tcp`

### General Setting

#### `linger_timeout`

| type | default | available transport type | version |
| :--- | :--- | :--- | :--- |
| integer | 0 | tcp, tls | 1.14.6 |

The timeout \(seconds\) to set `SO_LINGER`.

The default value `0` is to send RST rather than FIN to avoid lots of connections sitting in TIME_WAIT on closing.

You can set positive value to send FIN on closing.

{% hint style='info' %}
On Windows, Fluentd sends FIN without depending on this setting.
{% endhint %}

```
<transport tcp>
  linger_timeout 1
</transport>
```

### TLS Setting

* `version`: \[enum: `TLS1_1`/`TLS1_2`/`TLS1_3`\]
  * Default: `TLSv1_2`
* `min_version`: \[enum: `TLS1_1`/`TLS1_2`/`TLS1_3`\]
  * Default: `nil`
  * Specifies the lower bound of the supported SSL/TLS protocol.
* `max_version`: \[enum: `TLS1_1`/`TLS1_2`/`TLS1_3`\]
  * Default: `nil`
  * Specifies the upper bound of the supported SSL/TLS protocol.
* `ciphers` \[string\]
  * Default: `"ALL:!aNULL:!eNULL:!SSLv2"`
  * OpenSSL 1.0.0 or higher default.
* `insecure` \[bool\]
  * Default: `false` \(uses secure connection with `tls`\)

If you want to accept multiple TLS protocols, use `min_version`/`max_version` instead of `version`. To support the old style, fluentd accepts `TLS1_1` and `TLSv1_1` values.

NOTE: `TLS1_3` is available when your system supports TLS 1.3.

### Signed Public CA Parameters

For `<transport tls>`:

* `ca_path`: \[string\]
  * Default: `nil`
  * Specifies the path of CA certificate file
* `cert_path`: \[string\]
  * Default: `nil`
  * Specifies the path of Certificate file
* `private_key_path`: \[string\]
  * Default: `nil`
  * Specifies the path of Private Key file
* `private_key_passphrase`: \[string\]
  * Default: `nil`
  * Specifies the public CA private key passphrase
* `client_cert_auth`: \[bool\]
  * Default: `false`
  * If `true`, Fluentd will check all the incoming HTTPS requests for a

    client certificate signed by the trusted CA. The requests that don't

    supply a valid client certificate will fail.
* `cert_verifier`: \[string\]
  * Default: `nil`
  * Specifies the code path for cert verification. See also \[server

    article\]\(/developer/api-plugin-helper-server.md\#cert\_verifier-example\).

### Generated and Signed by Private CA Parameters

For `<transport tls>`:

* `ca_cert_path`: \[string\]
  * Default: `nil`
  * Specifies the private CA cert path
* `ca_private_key_path`: \[string\]
  * Default: `nil`
  * Specifies the private CA private key path
* `ca_private_key_passphrase`: \[string\]
  * Default: `nil`
  * Specifies the private CA private key passphrase

### Generated and Signed by Private CA Certs or Self-signed Parameters

For `<transport tls>`:

* `generate_private_key_length`: \[integer\]
  * Default: 2048
* `generate_cert_country`: \[string\]
  * Default: US
* `generate_cert_state`: \[string\]
  * Default: CA
* `generate_cert_locality`: \[string\]
  * Default: Mountain View
* `generate_cert_common_name`: \[string\]
  * Default: `nil`
* `generate_cert_expiration`: \[integer\]
  * Default: \(60 \* 60 \* 24 = 86400\) \* 365 \* 10 = 10 years

## Cert Digest Algorithm Parameter

For `<transport tls>`:

* `generate_cert_digest`: \[enum: `sha1`/`sha256`/`sha384`/`sha512`\]
  * Default: `sha256`

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

