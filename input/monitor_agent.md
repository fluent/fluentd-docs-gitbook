# monitor\_agent

The `in_monitor_agent` Input plugin exports Fluentd's internal metrics via REST API.

It is included in Fluentd's core.

## Example Configuration

```text
<source>
  @type monitor_agent
  bind 0.0.0.0
  port 24220
</source>
```

This configuration launches HTTP server with 24220 port and gets metrics:

```text
$ curl http://host:24220/api/plugins.json
```

Also you can fetch the same data in LTSV format:

```text
$ curl http://host:24220/api/plugins
```

Refer to the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

### `@type` \(required\)

The value must be `monitor_agent`.

### `port`

| type | default | version |
| :--- | :--- | :--- |
| integer | 24220 | 0.14.0 |

The port to listen to.

### `bind`

| type | default | version |
| :--- | :--- | :--- |
| string | 0.0.0.0 \(all addresses\) | 0.14.0 |

The bind address to listen to.

### `tag`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.0 |

If you set this parameter, this plugin emits metrics as records. See "Reuse plugins" section.

### `emit_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | 60 | 0.12.17 |

The interval time between event emits. This will be used when `tag` is configured.

### `include_config`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

You can set this option to true to add the `config` field to the response.

Since v1.19.3, the default value is changed to `false`.

{% hint style='danger' %}
Note that the `config` field may contain sensitive values such as passwords. Enable this option only if you understand the risk.
{% endhint %}

### `include_retry`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.11 |

You can set this option to true to add the `retry` field to the response.

Since v1.19.3, the default value is changed to `false`.

### `include_debug_info`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.19.3 |

You can set this option to true to allow the debug information to be exposed via the `debug` and `with_ivars` query parameters.

Unless this option is enabled, those query parameters are ignored.

{% hint style='danger' %}
Note that the debug information exposes the internal states of each plugin, including sensitive configuration values without obfuscating. Enable this option only if you understand the risk.
{% endhint %}

## Configuration Example

Here is a configuration example using `in_monitor_agent`:

```text
<source>
  @type monitor_agent
  @id in_monitor_agent
  include_retry true
</source>

<source>
  @type forward
  @id in_forward
</source>

<match test.**>
  @type elasticsearch
  @id out_es
</match>
```

When using this plugin, we strongly recommend setting `@id` on **each** plugin in use. This makes the task to identify which record corresponds to which plugin much easier. Without `@id`, Fluentd uses `object_id` as the unique identifier, so you cannot identify a record just by looking at its `plugin_id` field.

## Output Example

Here is how the output looks like in JSON:

```text
{
  "plugins": [
    {
      "plugin_id": "in_monitor_agent",
      "plugin_category": "input",
      "type": "monitor_agent",
      "output_plugin": false,
      "retry_count": null,
      "emit_records": 0,
      "emit_size": 0
    },
    {
      "plugin_id": "in_forward",
      "plugin_category": "input",
      "type": "forward",
      "output_plugin": false,
      "retry_count": null,
      "emit_records": 0,
      "emit_size": 0
    },
    {
      "plugin_id": "out_es",
      "plugin_category": "output",
      "type": "elasticsearch",
      "output_plugin": true,
      "buffer_queue_length": 0,
      "buffer_timekeys": [],
      "buffer_total_queued_size": 0,
      "retry_count": 0,
      "emit_records": 0,
      "emit_size": 0,
      "emit_count": 0,
      "write_count": 0,
      "write_secondary_count": 0,
      "rollback_count": 0,
      "slow_flush_count": 0,
      "flush_time_count": 0,
      "drop_oldest_chunk_count": 0,
      "buffer_stage_length": 0,
      "buffer_stage_byte_size": 0,
      "buffer_queue_byte_size": 0,
      "buffer_available_buffer_space_ratios": 100.0,
      "retry": {}
    }
  ]
}
```

If the plugin is an output plugin with the buffer settings, the metrics include the buffer related fields.

### `retry`

The `retry` field is included only when `include_retry` is set to `true`.

If the output plugin is in retry status, additional fields are added to `retry`. For example, if the Elasticsearch plugin fails to flush the buffer.

Here is the response:

```text
{
  "plugin_id": "out_es",
  "plugin_category": "output",
  "type": "elasticsearch",
  "output_plugin": true,
  "buffer_queue_length": 1,
  "buffer_timekeys": [],
  "buffer_total_queued_size": 117,
  "retry_count": 4,
  "emit_records": 1,
  "emit_size": 0,
  "emit_count": 1,
  "write_count": 4,
  "write_secondary_count": 0,
  "rollback_count": 4,
  "slow_flush_count": 0,
  "flush_time_count": 0,
  "drop_oldest_chunk_count": 0,
  "buffer_stage_length": 0,
  "buffer_stage_byte_size": 0,
  "buffer_queue_byte_size": 117,
  "buffer_available_buffer_space_ratios": 100.0,
  "retry": {
    "start": "2025-05-29 16:05:36 +0900",
    "steps": 3,
    "next_time": "2025-05-29 16:05:52 +0900"
  }
}
```

`steps` field in `retry` shows the number of flush failures, so next is the third try. `retry_count` is the total number of flush failures. This value is cleared when `fluentd` restarts, not when retry succeeds.

## Tips and Tricks

### How to use query parameters to tune outputs

This plugin supports a number of query parameters with which you can customize the output format of HTTP responses. For example, you can append `debug=1` to the request URL to get the verbose internal metrics:

```text
$ curl http://localhost:24220/api/plugins.json?debug=1
```

The following list shows the available query parameters:

| Parameter | Value | Explanation |
| :--- | :--- | :--- |
| `debug` | Constant | Expose additional internal metrics. Requires `include_debug_info true` |
| `with_ivars` | Variable names | Expose the specified instance variables of each plugin. Requires `include_debug_info true` |
| `tag` | Event tag | Only show plugins that match the specified tag |
| `@id` | Plugin id | Filter plugins by plugin id |
| `@type` | Plugin type | Filter plugins by plugin type |

Since v1.19.3, `debug` and `with_ivars` are ignored unless `include_debug_info` is set to `true` in the configuration.

Since v1.19.3, the `with_config` and `with_retry` query parameters are no longer available. The `config` and `retry` fields are controlled only by the `include_config` and `include_retry` parameters in the configuration file.

### How to emit metrics as events

You can emit the internal metrics as events by setting the `tag`.

For example:

```text
<source>
  @type monitor_agent
  tag debug.monitor
  emit_interval 60
  port 24230
</source>
```

Note that `in_monitor_agent` produces separate records for each plugin. Thus, using this configuration, you will receive events like below once per minute:

```text
2018-01-30 22:53:29.591560000 +0900 debug.monitor: { "plugin_id":"object:3ffd9988bea0","plugin_category":"input","type":"monitor_agent","output_plugin":false,"retry_count":null}
2018-01-30 22:53:29.591560000 +0900 debug.monitor: { "plugin_id":"in_forward","plugin_category":"input","type":"forward","output_plugin":false,"retry_count":null}
2018-01-30 22:53:29.591560000 +0900 debug.monitor: { "plugin_id":"out_out","plugin_category":"output","type":"stdout","output_plugin":true,"retry_count":0}
```

### Multi-Process Environment

If you use this plugin under the multi-process environment, the HTTP server will be launched in each worker. Port is assigned sequentially. For example, with this configuration:

```text
<system>
  workers 3
</system>

<source>
  @type monitor_agent
  port 24230
</source>
```

Three \(3\) HTTP servers will be launched with:

* port 24230 for worker 0
* port 24231 for worker 1
* port 24232 for worker 2

Note that you may need to set `worker_id` to `@id` parameter. See [config article](../configuration/config-file.md#embedded-ruby-code).

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
