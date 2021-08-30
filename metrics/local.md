# local

The `local` metrics plugin stores the values on memory.

## Parameters

### `default_labels`

Specifies the default labels for the metrics. \(default: `{agent: "Fluentd", hostname: "#{Socket.gethostname}"}`\)

### `labels`

Specifies other custom labels for the metrics. \(default: `{}`\)

## Example

With this configuration:

```text
<system>
  <metrics>
    @type local
  </metrics>
</system>
```

The above configuration will save the internal metrics for plugins on memory. As a result, you can retrive metrics from memory and also you can replace with your custom metrics plugin.

Actually, @type local metrics plugin has equivalent functionality for previous single value based Ruby instance variables.
This behavior will be changed by other 3rd party plugins.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
