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

{% include "../.gitbook/assets/footer.txt" %}
