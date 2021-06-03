# srv

The `srv` service discovery plugin updates the targets by [SRV Record](https://tools.ietf.org/html/rfc2782).

## Example Configuration

Here is an example of `out_forward` updating the targets to get the SRV record from `_fluentd._tcp.example.com`:

```text
<match pattern>
  @type forward

  <service_discovery>
    @type srv
    service fluentd
    proto tcp
    hostname example.com
  </service_discovery>
</source>
```

## Parameters

### `@type`

The value must be `srv`.

### `service` \(required\)

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.10.0 |

Service without the underscore in [RFC2782](https://tools.ietf.org/html/rfc2782).

### `proto`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.10.0 |

Proto without the underscore in [RFC2782](https://tools.ietf.org/html/rfc2782).

It is a required parameter.

### `hostname`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameters | 1.10.0 |

The name in [RFC2782](https://tools.ietf.org/html/rfc2782).

### `dns_server_host`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.10.0 |

The hostname of the DNS server to request the SRV record.

### `interval`

| type | default | version |
| :--- | :--- | :--- |
| integer | 60 | 1.10.0 |

The interval of sending requests to DNS server.

### `dns_lookup`

| type | default | version |
| :--- | :--- | :--- |
| bool | `true` | 1.10.0 |

Resolves the hostname to IP address of the SRV's Target.

#### `shared_key`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.10.0 |

The shared key per server.

#### `username`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.10.0 |

The username for authentication.

#### `password`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.10.0 |

The password for authentication.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

