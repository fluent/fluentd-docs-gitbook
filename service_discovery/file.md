# file

The `file` service discovery plugin updates the targets by reading the local file. YAML and JSON are the allowed file formats.

## Example Configuration

Here is an example with `out_forward` updating targets by sending data:

```text
<match pattern>
  @type forward

  <service_discovery>
    @type file
    path "/etc/fluentd/sd.yaml"
  </service_discovery>
</source>
```

Here is an example of target list file \(`/etc/fluentd/sd.yaml`\):

```text
- 'host': 127.0.0.1
  'port': 24224
  'weight': 1
  'name': server1
- 'host': 127.0.0.1
  'port': 24225
  'weight': 1
  'name': server2
```

## Parameters

### `@type`

The value must be `file`.

### `path`

| type | default | version |
| :--- | :--- | :--- |
| string | `'/etc/fluent/sd.yaml'` | 1.8.0 |

The path of the target list.

The `Content-Type` is determined by file extension i.e.:

* YAML: yaml, yml
* JSON: json

### `conf_encoding`

| type | default | version |
| :--- | :--- | :--- |
| string | `'utf-8'` | 1.8.0 |

The encoding of the configuration file.

### Parameters in Target List File

Each target has following parameters:

* `host`
* `name`
* `port`
* `shared_key`
* `username`
* `password`
* `standby`
* `weight`

#### `host`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.8.0 |

The IP address or hostname of the server. It is a required parameter.

#### `port`

| type | default | version |
| :--- | :--- | :--- |
| integer |  | 1.8.0 |

The port number of the host. It is a required parameter.

#### `name`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.8.0 |

The name of the server.

#### `shared_key`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.8.0 |

The shared key per server.

#### `username`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.8.0 |

The username for authentication.

#### `password`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 1.8.0 |

The password for authentication.

#### `standby`

| type | default | version |
| :--- | :--- | :--- |
| bool | `nil` | 1.8.0 |

#### `weight`

| type | default | version |
| :--- | :--- | :--- |
| integer | 60 | 1.8.0 |

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

