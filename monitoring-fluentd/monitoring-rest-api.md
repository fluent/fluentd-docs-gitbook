# Monitoring by REST API

This article describes how to get the internal Fluentd metrics via the REST API.

## Monitoring Agent

Fluentd has a monitoring agent to retrieve internal metrics in JSON format via HTTP.

Add these lines to your configuration file:

```text
<source>
  @type monitor_agent
  bind 0.0.0.0
  port 24220
</source>
```

Restart the agent and get the metrics via HTTP:

```text
$ curl http://host:24220/api/plugins.json
{
  "plugins":[
    {
      "plugin_id":"object:3fec669d6ac4",
      "plugin_category":"input",
      "type":"forward",
      "output_plugin":false,
      "retry_count":null,
      "emit_records":0,
      "emit_size":0
    },
    {
      "plugin_id":"object:3fec669dfa48",
      "plugin_category":"input",
      "type":"monitor_agent",
      "output_plugin":false,
      "retry_count":null,
      "emit_records":0,
      "emit_size":0
    },
    {
      "plugin_id":"object:3fec66aead48",
      "plugin_category":"output",
      "type":"forward",
      "output_plugin":true,
      "buffer_queue_length":0,
      "buffer_total_queued_size":0,
      "retry_count":0,
      "emit_records":0,
      "emit_size":0
    }
  ]
}
```

Since v1.19.3, the `config` and `retry` fields are not included by default. Set `include_config` or `include_retry` to `true` if you need them.

See [`in_monitor_agent`](../input/monitor_agent.md) article for more detail.

## Monitoring the Event Flow

Use [`flowcounter`](https://github.com/tagomoris/fluent-plugin-flowcounter) or [`flowcounter_simple`](https://github.com/sonots/fluent-plugin-flowcounter-simple) plugin.

## Datadog \(`dd-agent`\) Integration

[`Datadog`](https://www.datadoghq.com/) is a cloud monitoring service, and its monitoring agent `dd-agent` has native integration with Fluentd.

For more details:

* [Datadog-Fluentd Integration](http://docs.datadoghq.com/integrations/fluentd/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

