# Send Server Logs to Sematext

[Sematext](https://sematext.com/) is a tool for managing logs, and considered
an alternative to Splunk, but with cheaper and more flexible [pricing](https://sematext.com/pricing).
In this article, we present an alternative to Splunk by combining Fluentd with
the Sematext open Elasticsearch API.

![](/images/sematext-dashboard.png)


[Elasticsearch](https://www.elastic.co/products/elasticsearch) is an
open source search engine known for its ease of use.
[Sematext](https://sematext.com/) runs and manages Elasticsearch
in the cloud. You also have the option to use [Kibana](https://www.elastic.co/products/kibana)
alongside the dashboards in the Sematext UI.


By combining Fluentd and Sematext's managed Elasticsearch + Kibana we get
a scalable, flexible, easy to use log search engine with a great Native Web UI.
You also get Kibana, if you want to use it. This provides a managed Splunk alternative,
for a fraction of the cost.

In this guide, we will go over installation, setup, and basic use of
this combined log search solution. This article was tested on Ubuntu
18.04 and CentOS 7.4. **If you're not familiar with Fluentd**, please
learn more about Fluentd first.

## Prerequisites

## Set Up Sematext

You need to sign up and create an App. Read more in the docs [here](https://sematext.com/docs/).

## Set Up Fluentd (td-agent)

In this guide We'll install td-agent, the stable release of Fluentd.
Please refer to the guides below for detailed installation steps.

-   [Debian Package](/install/install-by-deb.md)
-   [RPM Package](/install/install-by-rpm.md)
-   [Ruby gem](/install/install-by-gem.md)

Next, we'll install the Elasticsearch plugin for Fluentd:
fluent-plugin-elasticsearch. Then, install fluent-plugin-elasticsearch
as follows.

```
$ sudo /usr/sbin/td-agent-gem install fluent-plugin-elasticsearch --no-document
```

We'll configure td-agent (Fluentd) to interface properly with
Elasticsearch. Please modify `/etc/td-agent/td-agent.conf` as shown
below:

```
Switch to debug if you need to debug
# Switch to debug if you need to debug
<system>
  log_level debug
</system>

# get logs from syslog
<source>
  @type syslog
  port 42185
  tag syslog
</source>

# get logs from fluent-logger, fluent-cat or other fluentd instances
<source>
  @type forward
</source>

<filter **>
  @type stdout
</filter>

<match syslog.**>
  @type elasticsearch
  host logsene-receiver.sematext.com
  # for EU
  # host logsene-receiver.eu.sematext.com
  port 443
  scheme https
  index_name <LOGS_TOKEN>
  reload_connections false
  reconnect_on_error true
  reload_on_failure true
  default_elasticsearch_version 6
  <buffer>
    @type file
    path /tmp/fluent/es-buffer/es.all.*.buffer
    chunk_limit_size 250k
    flush_interval 50s
    retry_limit 5
    retry_wait 60
  </buffer>
  num_threads 1
</match>
```

Once everything has been set up and configured, we'll start td-agent.

```
# init
$ sudo /etc/init.d/td-agent start
# or systemd
$ sudo systemctl start td-agent.service
```

## Store and Search Event Logs

Once Fluentd receives some logs from rsyslog and ships them
to Sematext, you can view, search and visualize the log data using
Dashboards or Kibana.

First of all, open up the Seamtext UI and access your App. You'll se prebuilt
dashboards with full-text search and alerts out-of-the-box.

![](/images/sematext-configure-logs.png)


Sematext will automatically figure out hosts, idents, pids, timestamps,
and the origin of the logs. In this case the origing is Fluentd.

After you start receiving logs, you can create custom charts, reports,
and alerts to fine-tune your own personal use-case.


If you're used to Kibana, you can still use it as well.
For the detail on how to use Kibana, please read [the official manual](https://www.elastic.co/guide/en/kibana/current/index.html).

![](/images/sematext-logs-overview.png)


### Debugging

To manually send logs to Elasticsearch, please use the `logger` command.

```
$ logger -t test foobar
```

When debugging your td-agent configuration, using
[filter\_stdout](/plugins/filter/stdout.md) will be useful. All the logs including
errors can be found at `/etc/td-agent/td-agent.log`.

```
<filter **>
  @type stdout
</filter>

<match **>
  @type elasticsearch
  host logsene-receiver.sematext.com
  # for EU
  # host logsene-receiver.eu.sematext.com
  port 443
  scheme https
  index_name <LOGS_TOKEN>
  <buffer>
    flush_interval 5s # for testing
  </buffer>
</match>
```

## Conclusion

This how-to guide introduced an alternative SaaS tool to use instead of Splunk.
The combination of Fluentd and Sematext, with an open Elasticsearch API and Kibana,
gives you tooling you're used to, with the added benefit of not having to manage
an Elasticsearch cluster.

You'll get access to storing and searching logs from infrastructure,
apps, and software. The example provided in this article had been
tested for the current production env of Sematext

## Learn More

-   [Fluentd Architecture](https://www.fluentd.org/architecture)
-   [Fluentd Get Started](/overview/quickstart.md)
-   [Downloading Fluentd](http://www.fluentd.org/download)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
