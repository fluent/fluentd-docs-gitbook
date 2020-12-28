# static

The `static` service discovery plugin sets the list of targets.

## Example Configuration

Here is an example with `out_forward` that defines the list of targets similar to the `server` directive:

```text
<source>
  @type forward

  <service_discovery>
    @type static
    <server>
      host 127.0.0.1
    </server>
  </service_discovery>
</source>
```

## Parameters

### `@type`

The value must be `static`.

#### `host`

| type | default | version |
| :--- | :--- | :--- |
| string |  | 1.8.0 |

The IP address or hostname of the server. It is a required parameter.

#### `port`

| type | default | version |
| :--- | :--- | :--- |
| integer | 24224 | 1.8.0 |

The port number of the host.

#### `name`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.8.0 |

The name of the server.

#### `shared_key`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.8.0 |

The shared key per server.

#### `username`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.8.0 |

The username for authentication.

#### `password`

| type | default | version |
| :--- | :--- | :--- |
| string | `''`\(empty string\) | 1.8.0 |

The password for authentication.

#### `standby`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.8.0 |

#### `weight`

| type | default | version |
| :--- | :--- | :--- |
| integer | 60 | 1.8.0 |

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

