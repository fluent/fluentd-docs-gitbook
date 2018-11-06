


Secure Forward Input Plugin
===========================

The `in_secure_forward` input plugin accepts messages via **SSL with
authentication** (cf. [out\_secure\_forward](out_secure_forward)).
This document doesn\'t describe all parameters. If you want to know full
features, check the Further Reading section.


### Table of Contents

[Installation](#installation)

[Example Configurations](#example-configurations)

-   [Minimalist Configuration](#minimalist-configuration)
-   [Check username/password from
    Clients](#check-username/password-from-clients)
-   [Deny Unknown Source IP/hosts](#deny-unknown-source-ip/hosts)
-   [Secure Sender-Receiver Setup](#secure-sender-receiver-setup)

[Parameters](#parameters)

-   [\@type](#@type)
-   [port (integer)](#port-(integer))
-   [bind (string)](#bind-(string))
-   [secure (bool)](#secure-(bool))
-   [self\_hostname (string)](#self_hostname-(string))
-   [shared\_key (string)](#shared_key-(string))
-   [allow\_keepalive (bool)](#allow_keepalive-(bool))
-   [allow\_anonymous\_source (bool)](#allow_anonymous_source-(bool))
-   [authentication (bool)](#authentication-(bool))
-   [ca\_cert\_path (string)](#ca_cert_path-(string))
-   [ca\_private\_key\_path (string)](#ca_private_key_path-(string))
-   [ca\_private\_key\_passphrase
    (string)](#ca_private_key_passphrase-(string))
-   [read\_length (size)](#read_length-(size))
-   [read\_interval\_msec (integer)](#read_interval_msec-(integer))
-   [socket\_interval\_msec (integer)](#socket_interval_msec-(integer))

[Further Reading](#further-reading)
Installation
------------

`in_secure_forward` is **not** included in either `td-agent` package or
`fluentd` gem. In order to install it, please refer to the [Plugin
Management](plugin-management) article.

Example Configurations
----------------------

This section provides some example configurations for
`in_secure_forward`.

### Minimalist Configuration

At first, generate private CA file by `secure-forward-ca-generate`, then
copy that file to output plugin side by safe way (scp, or anyway else).

``` {.CodeRay}
<source>
  @type secure_forward
  shared_key      secret_string
  self_hostname   server.fqdn.local  # This fqdn is used as CN (Common Name) of certificates
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
</source>
```

### Check username/password from Clients

``` {.CodeRay}
<source>
  @type secure_forward
  shared_key         secret_string
  self_hostname      server.fqdn.local
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
  authentication     yes # Deny clients without valid username/password
  <user>
    username tagomoris
    password foobar012
  </user>
  <user>
    username frsyuki
    password yakiniku
  </user>
</source>
```

### Deny Unknown Source IP/hosts

``` {.CodeRay}
<source>
  @type secure_forward
  shared_key         secret_string
  self_hostname      server.fqdn.local
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
  allow_anonymous_source no  # Allow to accept from nodes of <client>
  <client>
    host 192.168.10.30
    # network address (ex: 192.168.10.0/24) NOT Supported now
  </client>
  <client>
    host your.host.fqdn.local
    # wildcard (ex: *.host.fqdn.local) NOT Supported now
  </client>
</source>
```

You can use the username/password check and client check together:

``` {.CodeRay}
<source>
  @type secure_forward
  shared_key         secret_string
  self_hostname      server.fqdn.local
  secure true
  ca_cert_path        /path/to/certificate/ca_cert.pem
  ca_private_key_path /path/to/certificate/ca_key.pem
  ca_private_key_passphrase passphrase_for_private_CA_secret_key
  allow_anonymous_source no  # Allow to accept from nodes of <client>
  authentication         yes # Deny clients without valid username/password
  <user>
    username tagomoris
    password foobar012
  </user>
  <user>
    username frsyuki
    password sukiyaki
  </user>
  <user>
    username repeatedly
    password sushi
  </user
  <client>
    host 192.168.10.30      # allow all users to connect from 192.168.10.30
  </client>
  <client>
    host  192.168.10.31
    users tagomoris,frsyuki # deny repeatedly from 192.168.10.31
  </client>
  <client>
    host 192.168.10.32
    shared_key less_secret_string # limited shared_key for 192.168.10.32
    users      repeatedly         # and repeatedly only
  </client>
</source>
```

### Secure Sender-Receiver Setup

Please refer to the **Secure Sender-Receiver Setup** [sample
documentation](out_secure_forward#Secure-Sender-Receiver-Setup).

Parameters
----------

### \@type

This parameter is required. Its value must be `secure_forward`.

### port (integer)

The default value is 24284.

### bind (string)

The default value is 0.0.0.0.

### secure (bool)

Indicate published connection is secure or not. Specify `yes` (or
`true`) if secure encryption needed.

### self\_hostname (string)

Default value of the auto-generated certificate common name (CN).

### shared\_key (string)

Shared key between nodes.

### allow\_keepalive (bool)

Accept keepalive connection. The default value is `true`.

### allow\_anonymous\_source (bool)

Accept connections from unknown hosts.

### authentication (bool)

Require password authentication. The default value is `false`.

### ca\_cert\_path (string)

The path to the private CA certificate file, which is required to use
private CA. (One of this parameter or `cert_path` is required for
`secure yes` configuration.)

### ca\_private\_key\_path (string)

The path to the private key for private CA certificate key file.

### ca\_private\_key\_passphrase (string)

The passphrase string for private key file, specified by
`ca_private_key_path`.

### read\_length (size)

The number of bytes read per nonblocking read. The default value is
8MB=8*1024*1024 bytes.

### read\_interval\_msec (integer)

The interval between the non-blocking reads, in milliseconds. The
default value is 50.

### socket\_interval\_msec (integer)

The interval between SSL reconnects in milliseconds. The default value
is 200.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.

Further Reading
---------------

-   [fluent-plugin-secure-forward
    repository](https://github.com/tagomoris/fluent-plugin-secure-forward)


------------------------------------------------------------------------


If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
