# relabel

The `relabel` output plugin re-labels events.

It is included in Fluentd's core.

## Example Configuration

```text
<match pattern>
  @type relabel
  @label @foo
</match>

<label @foo>
  <match pattern>
  # ...
  </match>
</label>
```

In the above example, the `relabel` output plugin uses a label `@foo` to route the matched events, and then the respective `label` directive takes care of these events.

NOTE: All the input and output plugins support the `@label` parameter provided by the Fluentd core. The `relabel` plugin is a plugin that does nothing other than supporting the `@label` parameter.

## Supported Modes

* Non-Buffered
* See also: [Output Plugin Overview](./)

## Plugin Helpers

* [`event_emitter`](../plugin-helper-overview/api-plugin-helper-event_emitter.md)

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type`

The value must be `relabel`.

### `@label`

| type | default | version |
| :--- | :--- | :--- |
| string | `nil` | 0.14.0 |

Specifies the label. It is a required parameter.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

