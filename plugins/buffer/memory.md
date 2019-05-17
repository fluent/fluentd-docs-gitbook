# memory Buffer Plugin

The `memory` buffer plugin provides a fast buffer implementation. It
uses memory to store buffer chunks. When Fluentd is shut down, buffered
logs that can't be written quickly are deleted.


## Parameters

-   [Common Parameters](/configuration/plugin-common-parameters.md)
-   [Buffer section configurations](/configuration/buffer-section.md)

`memory` plugin has no specific parameters.


## Example

```
<match pattern>
  <buffer>
    @type memory
  </buffer>
</match>
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
