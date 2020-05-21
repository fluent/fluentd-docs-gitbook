# Transport section configurations

Fluentd's input, output, and filter plugins which use `server`/`http_server` plugin
helper support the `<transport>` section to specify how to handle
connection.


## Transport section overview

Transport section must be in `<match>`, `<source>`, and `<filter>`
sections. It's specifying transport protocol, its version, and
certificates.

```
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
  # ... other parameters ...
</transport>
```

## Parameters

-   `protocol` \[enum\]
    -   Default: :tcp
    -   Specify like `<transport tls>`. Supported values are `tcp`, `udp` and `tls`

### TLS setting

-   `version` \[enum\]
    -   Default: `'TLSv1_2'`
-   `min_version` \[enum\]
    -   Default: nil
    -   Specify the lower bound of the supported SSL/TLS protocol. Supported values are `TLS1_1`, `TLS1_2` and `TLS1_3`
-   `max_version` \[enum\]
    -   Default: nil
    -   Specify the upper bound of the supported SSL/TLS protocol. Supported values are `TLS1_1`, `TLS1_2` and `TLS1_3`
-   `ciphers` \[string\]
    -   Default: `"ALL:!aNULL:!eNULL:!SSLv2"`
    -   OpenSSL 1.0.0 or higher default.
-   `insecure` \[bool\]
    -   Default: false (use secure connection when use tls)

If you want to accept multiple TLS protocols, use `min_version`/`max_version` instead of `version`.
To support old style, fluentd accepts `TLS1_1` and `TLSv1_1` value.

NOTE: `TLS1_3` is available when your system supports TLS 1.3.

### Signed public CA parameters

For `<transport tls>`:

-   `ca_path`: \[string\]
    -   Default: nil
    -   Specify path to CA certificate file
-   `cert_path`: \[string\]
    -   Default: nil
    -   Specify path to Certificate file
-   `private_key_path`: \[string\]
    -   Default: nil
    -   Specify path to private Key file
-   `private_key_passphrase`: \[string\]
    -   Default: nil
    -   public CA private key passphrase contained path
-   `client_cert_auth`: \[bool\]
    -   Default: false
    -   When this is set Fluentd will check all incoming HTTPS requests
        for a client certificate signed by the trusted CA, requests that
        don't supply a valid client certificate will fail.
-   `cert_verifier `[string\]
    -   Default: nil
    -   Specify code path for cert verification. See also [server article](/developer/api-plugin-helper-server.md#cert_verifier-example)


### Generated and signed by private CA parameters

For `<transport tls>`:

-   `ca_cert_path`: \[string\]
    -   Default: nil
    -   Specify private CA contained path
-   `ca_private_key_path`: \[string\]
    -   Default: nil
    -   private CA private key contained path
-   `ca_private_key_passphrase`: \[string\]
    -   Default: nil
    -   private CA private key passphrase contained path


### Generated and signed by private CA certs or self-signed parameters

For `<transport tls>`:

-   `generate_private_key_length`: \[integer\]
    -   Default: 2048
-   `generate_cert_country`: \[string\]
    -   Default: US
-   `generate_cert_state`: \[string\]
    -   Default: CA
-   `generate_cert_locality`: \[string\]
    -   Default: Mountain View
-   `generate_cert_common_name`: \[string\]
    -   Default: nil
-   `generate_cert_expiration`: \[integer\]
    -   Default: (60 \* 60 \* 24 = 86400) \* 365 \* 10 = 10 years


## Cert digest algorithm parameter

For `<transport tls>`:

-   `generate_cert_digest`: \[enum\]
    -   Default: :sha256
    -   Supported values are `sha1`, `sha256`, `sha384` and `sha512`

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
