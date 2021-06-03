# null

![](../.gitbook/assets/null.png)

The `null` output plugin just throws away events.

It is included in Fluentd's core.

## Example Configuration

```text
<match pattern>
  @type null
</match>
```

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

## Supported Modes

* Non-Buffered
* Synchronous
* Asynchronous

See [Output Plugin Overview](./) for more details.

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type`

The value must be `null`.

### `never_flush`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.12 |

The parameter for testing to simulate the output plugin that never succeeds to flush.

### `<buffer>` Section

See [Buffer section configurations](../configuration/buffer-section.md) for more details.

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

## Common Buffer / Output parameters

See [Buffer Plugin Overview](../buffer/) and [Output Plugin Overview](./).

{% include "../.gitbook/assets/footer.txt" %}
