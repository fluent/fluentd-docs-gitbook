# Monitoring Fluentd (REST API)

This article describes how to get the internal Fluentd metrics via REST
API.


## Monitoring Agent

Fluentd has a monitoring agent to retrieve internal metrics in JSON via
HTTP. Please add the following lines to your configuration file.

``` {.CodeRay}
<source>
  @type monitor_agent
  bind 0.0.0.0
  port 24220
</source>
```

Next, please restart the agent and get the metrics via HTTP.

``` {.CodeRay}
$ curl http://host:24220/api/plugins.json
{
  "plugins":[
    {
      "plugin_id":"object:3fec669d6ac4",
      "type":"forward",
      "output_plugin":false,
      "config":{
        "type":"forward"
      }
    },
    {
      "plugin_id":"object:3fec669dfa48",
      "type":"monitor_agent",
      "output_plugin":false,
      "config":{
        "type":"monitor_agent",
        "port":"24220"
      }
    },
    {
      "plugin_id":"object:3fec66aead48",
      "type":"forward",
      "output_plugin":true,
      "buffer_queue_length":0,
      "buffer_total_queued_size":0,
      "retry_count":0,
      "config":{
        "type":"forward",
        "host":"192.168.0.11"
      }
    }
  ]
}
```

See [in\_monitor\_agent article](/plugins/input/monitor_agent.md) for more detail.


## Monitoring the event flow

Use
[flowcounter](https://github.com/tagomoris/fluent-plugin-flowcounter) or
[flowcounter\_simple](https://github.com/sonots/fluent-plugin-flowcounter-simple)
plugin.


## Datadog (dd-agent) Integration

[Datadog](https://www.datadoghq.com/) is a cloud monitoring service, and
its monitoring agent `dd-agent` has native integration with Fluentd.

Please refer this documentation for more details.

-   [Datadog-Fluentd Integration](http://docs.datadoghq.com/integrations/fluentd/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
