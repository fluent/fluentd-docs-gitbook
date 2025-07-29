# stdout

![](../.gitbook/assets/stdout.png)

The `stdout` output plugin prints events to the standard output \(or logs if launched as a daemon\). This output plugin is useful for debugging purposes.

It is included in Fluentd's core.

## Example Configuration

```text
<match pattern>
  @type stdout
</match>
```

Please see the [Config File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

Sample output:

```text
2017-11-28 11:43:13.814351757 +0900 tag: {"field1":"value1","field2":"value2"}
```

where the first part shows the output `time`, the second part shows the `tag`, and the third part shows the `record`.

## Supported Modes

* Non-Buffered
* Synchronous

## Plugin Helpers

* [`inject`](../plugin-helper-overview/api-plugin-helper-inject.md)
* [`formatter`](../plugin-helper-overview/api-plugin-helper-formatter.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type`

The value must be `stdout`.

### `use_logger`

| type | default | version |
| :--- | :---    | :---    |
| bool | true    | 1.19.0  |

If [Fluentd logger](../deployment/logging.md) outputs logs to a file, this plugin outputs events to the file as well.

If setting `false`, this plugin outputs events to STDOUT independently of Fluentd logger.

### `<buffer>` Section

See [Buffer Section Configurations](../configuration/buffer-section.md) for more details.

#### `chunk_keys`

| type | default | version |
| :--- | :--- | :--- |
| array | tag | 0.14.5 |

Overwrites the default value in this plugin.

#### `flush_at_shutdown`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.5 |

Overwrites the default value in this plugin.

#### `chunk_limit_size`

| type | default | version |
| :--- | :--- | :--- |
| size | 10240 | 0.14.5 |

Overwrites the default value in this plugin.

### `<format>` Section

See [Format Section Configurations](../configuration/format-section.md) for more details.

#### `@type`

| type | default | version |
| :--- | :--- | :--- |
| string | stdout | 0.14.5 |

The format of the output.

#### `output_type`

| type | default | version |
| :--- | :--- | :--- |
| string | json | 0.14.5 |

This is the option for the `stdout` format. Configure the format of the record \(third part\). Any formatter plugins can be specified.

### `<inject>` Section

See [Inject Section Configurations](../configuration/inject-section.md) for more details.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

