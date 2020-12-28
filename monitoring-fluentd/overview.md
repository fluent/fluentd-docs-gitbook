# Overview

This article describes how to monitor Fluentd.

## Fluentd Metrics Monitoring

Fluentd can expose internal metrics via REST API, and works with monitoring tools such as [`Prometheus`](https://prometheus.io/), [`Datadog`](https://www.datadoghq.com/), etc. Our recommendation is to use `Prometheus`, since we will be collaborating more in the future under the [CNCF \(Cloud Native Computing Foundation\)](https://www.cncf.io/).

* [Monitoring Fluentd \(Prometheus\)](monitoring-prometheus.md)
* [Monitoring Fluentd \(Datadog\)](https://docs.datadoghq.com/integrations/fluentd/)
* [Monitoring Fluentd \(REST API\)](monitoring-rest-api.md)

## Process Monitoring

Two `ruby` processes \(parent and child\) are executed. Please make sure that these processes are running.

Here's an example for `td-agent`:

```text
/opt/td-agent/embedded/bin/ruby /usr/sbin/td-agent
  --daemon /var/run/td-agent/td-agent.pid
  --log /var/log/td-agent/td-agent.log
```

For `td-agent` on Linux, check the process statuses like this:

```text
$ ps w -C ruby -C td-agent --no-heading
32342 ?        Sl     0:00 /opt/td-agent/embedded/bin/ruby /usr/sbin/td-agent --daemon /var/run/td-agent/td-agent.pid --log /var/log/td-agent/td-agent.log
32345 ?        Sl     0:01 /opt/td-agent/embedded/bin/ruby /usr/sbin/td-agent --daemon /var/run/td-agent/td-agent.pid --log /var/log/td-agent/td-agent.log
```

There should be two processes if there is no issue.

## Port Monitoring

Fluentd opens several ports according to the configuration file. We recommend checking the availability of these ports. The default port settings are shown below:

* TCP 0.0.0.0 9880 \(HTTP by default\)
* TCP 0.0.0.0 24224 \(Forward by default\)

## Debug Port

A debug port for local communication is recommended for troubleshooting. The following configuration will be required for the debug port:

```text
<source>
  @type debug_agent
  bind 127.0.0.1
  port 24230
</source>
```

You can attach the process using the `fluent-debug` command through `dRuby`.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

