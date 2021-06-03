# memory

The `memory` buffer plugin provides a fast buffer implementation. It uses memory to store buffer chunks. When Fluentd is shut down, buffered logs that cannot be written quickly are deleted.

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Buffer Section Configurations](../configuration/buffer-section.md)

`memory` plugin has no specific parameters.

## Example

```text
<match pattern>
  <buffer>
    @type memory
  </buffer>
</match>
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

