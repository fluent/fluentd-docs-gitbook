# `dummy` Input Plugin

`in_dummy` has been renamed `in_sample` since Fluentd v1.11.12.
See [`sample` input plugin](/input/sample.md) article for more details.

You can keep to use following configuration in v1:

```text
<source>
  @type dummy
  dummy {"hello":"world"}
</source>
```

Fluentd v2 will remove this plugin name.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
