# File Service Discovery Plugin

The `file` serivce discovery plugin updates targets by reading local file.
YAML and JSON are allowed as the file formats.

## Example Configuration

This is the exmple with out_forward.
It udpates targets to send data by out_forward.

```
<source>
  @type forward

  <service_discovery>
    @type file
    path "/etc/fluentd/sd.yaml"
  </service_discovery>
</source>
```

Here is the example of target list file(`/etc/fluentd/sd.yaml`).

```
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

### @type

The value must be `file`.

### path

| type   | default                 | version |
|:-------|:------------------------|:--------|
| string | `'/etc/fluent/sd.yaml'` | 1.8.0  |

The path of target list.

### conf_encoding

| type   | default   | version |
|:-------|:----------|:--------|
| string | `'utf-8'` | 1.8.0  |

The encoding of config file.

### Parameters in target list file

Each target has following parameters.

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
| string | required parameter | 1.8.0  |

The IP address or host name of the server.

#### port

| type    | default            | version |
|:--------|:-------------------|:--------|
| integer | required parameter | 1.8.0  |

The port number of the host.

#### name

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.8.0  |

The name of the server.

#### shared\_key

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.8.0  |

The shared key per server.

#### username

| type   | default  | version |
|:-------|:---------|:--------|
| string | nil      | 1.8.0  |

The username for authentication.

#### password

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.8.0  |

The password for authentication.

#### standby

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 1.8.0  |

#### weight

| type    | default | version |
|:--------|:--------|:--------|
| integer | 60      | 1.8.0  |


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
