# SRV Service Discovery Plugin

The `srv` serivce discovery plugin updates targets by [SRV Record](https://tools.ietf.org/html/rfc2782)

## Example Configuration

This is an exmple with out\_forward.
It udpates targets to get SRV record from `_fluentd._tcp.exmaple.com`.

```
<source>
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

### @type

The value must be `srv`.

### service

| type   | default                 | version |
|:-------|:------------------------|:--------|
| string | required parameters     | 1.10.0  |

Service without underscore in [RFC2782](https://tools.ietf.org/html/rfc2782)

### proto

| type   | default                 | version |
|:-------|:------------------------|:--------|
| string | required parameters     | 1.10.0  |

Proto without underscore in [RFC2782](https://tools.ietf.org/html/rfc2782)

### hostname

| type   | default                 | version |
|:-------|:------------------------|:--------|
| string | required parameters     | 1.10.0  |

Name in [RFC2782](https://tools.ietf.org/html/rfc2782)


### dns\_server\_host

| type   | default | version |
|:-------|:------------------------|:--------|
| string | nil     | 1.10.0  |

Hostname of DNS server to request the SRV record

### interval

| type   | default | version |
|:-------|:--------|:--------|
| integer | 60     | 1.10.0  |

Interval of requesting to DNS server

### dns\_lookup

| type   | default | version |
|:-------|:------------------------|:--------|
| integer | 60     | 1.10.0  |

Resolve hostname to IP addr of SRV's Target

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

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
