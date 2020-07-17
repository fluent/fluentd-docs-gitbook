# `relabel` Output Plugin

The `relabel` output plugin re-labels events.

It is included in Fluentd's core.


## Example Configuration

```
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

The above example puts a label `@foo` to matched events, and the `label`
directive can take care of these events.

**FYI**: All of input and output plugins also have `@label` parameter
provided by Fluentd core. The `relabel` plugin is a plugin which
actually does nothing, but supports only `@label` parameter.


## Supported Modes

-   Non-Buffered

-   See also: [Output Plugin Overview](/plugins/output/README.md)


## Plugin Helpers

-   [`event_emitter`](/developer/api-plugin-helper-event_emitter.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)


### `@type`

The value must be `relabel`.


### `@label`

The label.

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.0  |


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under
[Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are
available under the Apache 2 License.
