# roundrobin Output Plugin

The `roundrobin` Output plugin distributes events to multiple outputs
using a weighted round-robin algorithm.


## Example Configuration

`out_roundrobin` is included in Fluentd's core. No additional
installation process is required.

```
<match pattern>
  @type roundrobin

  <store>
    @type tcp
    host 192.168.1.21
    weight 3
    ...
  </store>
  <store>
    @type tcp
    host 192.168.1.22
    weight 2
    ...
  </store>
  <store>
    @type tcp
    host 192.168.1.23
    weight 1
    ...
  </store>
</match>
```

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.


## Supported modes

-   Non-Buffered


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

### @type

The value must be `roundrobin`.


### &lt;store&gt;

Specifies the storage destinations. The format is the same as the
`<match>` directive.

#### weight

| type    | default | version |
|:--------|:--------|:--------|
| integer | 1       | 0.14.1  |

Weight to distribute events to multiple outputs.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
