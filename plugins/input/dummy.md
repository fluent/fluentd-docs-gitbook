# `dummy` Input Plugin

`in_dummy` has been renamed `in_sample` since Fluentd v1.11.12.
See [`sample` input plugin](/plugins/input/sample.md) article for more details.

You can keep to use following configuration in v1:

```text
<source>
  @type dummy
  dummy {"hello":"world"}
</source>
```

Fluentd v2 will remove this plugin name.


------------------------------------------------------------------------

{% include "../../.gitbook/assets/footer.txt" %}
