# Static Service Discovery Plugin

The `static` service discovery plugin set the list of targets.

## Example Configuration

This is the example with out_forward.
It defines the list of targets. it is similer to the server directive in out_forward.

```
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

### @type

The value must be `static`.

#### host

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 1.8.0  |

The IP address or host name of the server.

#### port

| type    | default | version |
|:--------|:--------|:--------|
| integer | 24224   | 1.8.0  |

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

| type   | default                | version |
|:-------|:-----------------------|:--------|
| string | `''`(empty string)     | 1.8.0  |

The password for authentication.

#### standby

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 1.8.0  |

#### weight

| type    | default | version |
|:--------|:--------|:--------|
| integer | 60      | 1.8.0  |


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.

