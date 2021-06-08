# roundrobin

The `roundrobin` Output plugin distributes events to multiple outputs using a weighted round-robin algorithm.

It is included in Fluentd's core.

## Example Configuration

```text
<match pattern>
  @type roundrobin

  <store>
    @type http
    endpoint http://192.168.1.21
    weight 3
    # ...
  </store>
  <store>
    @type http
    endpoint http://192.168.1.22
    weight 2
    # ...
  </store>
  <store>
    @type http
    endpoint http://192.168.1.23
    weight 1
    # ...
  </store>
</match>
```

Refer to [Configuration File](../configuration/config-file.md) for the basic structure and syntax of the configuration file.

## Supported Modes

* Non-Buffered

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type`

The value must be `roundrobin`.

### `<store>`

Specifies the storage destinations. The format is the same as the `<match>` directive.

#### `weight`

| type | default | version |
| :--- | :--- | :--- |
| integer | 1 | 0.14.1 |

Weight to distribute events to multiple outputs.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

