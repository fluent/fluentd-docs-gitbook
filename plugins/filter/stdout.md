# `stdout` Filter Plugin

The `filter_stdout` filter plugin prints events to the standard output (or logs
if launched as a daemon). This filter plugin is useful for debugging purposes.

It is included in the Fluentd's core.


## Example Configurations

```
<filter pattern>
  @type stdout
</filter>
```

A sample output is as follows:

```
2017-11-28 11:43:13.814351757 +0900 tag: {"field1":"value1","field2":"value2"}
```

where the first part shows the output **time**, the second part shows the
**tag**, and the third part shows the **record**.


## Plugin Helpers

-   [`formatter`](/developer/api-plugin-helper-formatter.md)
-   [`compat_parameters`](/developer/api-plugin-helper-compat_parameters.md)
-   [`inject`](/developer/api-plugin-helper-inject.md)


## Parameters

See [Common Parameters](/configuration/plugin-common-parameters.md).


### `@type` (required)

The value must be `stdout`.


### `<format>` Section

See [Format section configurations](/configuration/format-section.md) for more details.


#### `@type`

| type   | default | version |
|:-------|:--------|:--------|
| string | stdout  | 0.14.5  |

The format of output.


#### `output_type`

| type   | default | version |
|:-------|:--------|:--------|
| string | json    | 0.14.5  |

This is the option of `stdout` format. Configures the format of record
(third part). Any formatter plugins can be specified.


### `<inject>` Section

See [Inject Section Configurations](/developer/inject-section) for more details.


## Learn More

-   [Filter Plugin Overview](/plugins/filter/README.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
