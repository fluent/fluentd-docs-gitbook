# Free Alternative to Splunk Using Fluentd

[Splunk](http://www.splunk.com/) is a great tool for searching logs, but
its high cost makes it prohibitive for many teams. In this article, we
present a free and open source alternative to Splunk by combining three
open source projects: Elasticsearch, Kibana, and Fluentd.

![](/images/kibana6-screenshot-visualize.png)


[Elasticsearch](https://www.elastic.co/products/elasticsearch) is an
open source search engine known for its ease of use.
[Kibana](https://www.elastic.co/products/kibana) is an open source Web
UI that makes Elasticsearch user friendly for marketers, engineers and
data scientists alike.

By combining these three tools (Fluentd + Elasticsearch + Kibana) we get
a scalable, flexible, easy to use log search engine with a great Web UI
that provides an open-source Splunk alternative, all for free.

![](/images/fluentd-elasticsearch-kibana.png)


In this guide, we will go over installation, setup, and basic use of
this combined log search solution. This article was tested on Ubuntu
16.04 and CentOS 7.4. **If you're not familiar with Fluentd**, please
learn more about Fluentd first.

## Prerequisites


### Java for Elasticsearch

Please confirm that your Java version is 8 or higher.

```
$ java -version
openjdk version "1.8.0_151"
OpenJDK Runtime Environment (build 1.8.0_151-b12)
OpenJDK 64-Bit Server VM (build 25.151-b12, mixed mode)
```

Now that we've checked for prerequisites, we're now ready to install and
set up the three open source tools.


## Set Up Elasticsearch

To install Elasticsearch, please download and extract the Elasticsearch
package as shown below.

```
$ curl -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.1.0.tar.gz
$ tar -xf elasticsearch-6.1.0.tar.gz
$ cd elasticsearch-6.1.0
```

Once installation is complete, start Elasticsearch.

```
$ ./bin/elasticsearch
```

Note: You can also install ElasticSearch (and Kibana) using RPM/DEB
packages. For details, please refer to [the official instructions](https://www.elastic.co/downloads).


## Set Up Kibana

To install Kibana, download it via the official webpage and extract it.
Kibana is a HTML / CSS / JavaScript application. Dowload page is
[here](https://www.elastic.co/downloads/kibana). In this article, we use
the binary for 64-bit Linux systems. Download page is
[here](https://www.elastic.co/downloads/kibana). In this article, we
download Mac OS X binary.

```
$ curl -O https://artifacts.elastic.co/downloads/kibana/kibana-6.1.0-linux-x86_64.tar.gz
$ tar -xf kibana-6.1.0-linux-x86_64.tar.gz
$ cd kibana-6.1.0-linux-x86_64
```

Once installation is complete, start Kibana and run `./bin/kibana`. You
can modify Kibana's configuration via `config/kibana.yml`.

```
$ ./bin/kibana
```

Access `http://localhost:5601` in your browser.


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

<match syslog.**>
  @type elasticsearch
  logstash_format true
  <buffer>
    flush_interval 10s # for testing
  </buffer>
</match>
```

fluent-plugin-elasticsearch comes with a logstash\_format option that
allows Kibana to search stored event logs in Elasticsearch.

Once everything has been set up and configured, we'll start td-agent.

```
# init
$ sudo /etc/init.d/td-agent start
# or systemd
$ sudo systemctl start td-agent.service
```


## Set Up rsyslogd

In our final step, we'll forward the logs from your rsyslogd to Fluentd.
Please add the following line to your `/etc/rsyslog.conf`, and restart
rsyslog. This will forward your local syslog to Fluentd, and Fluentd in
turn will forward the logs to Elasticsearch.

```
*.* @127.0.0.1:42185
```

Please restart the rsyslog service once the modification is complete.

```
# init
$ sudo /etc/init.d/rsyslog restart
# or systemd
$ sudo systemctl restart rsyslog
```


## Store and Search Event Logs

Once Fluentd receives some event logs from `rsyslog` and has flushed them
to Elasticsearch, you can view, search and visualize the log data using
Kibana.

For starters, let's access `http://localhost:5601` and click the `Set
up index patters` button in the upper-right corner of the screen.

![kibana6-screenshot-topmenu.png](/images/kibana6-screenshot-topmenu.png)

Kibana will start a wizard that guides you through configuring the data
sets to visualize. If you want a quick start, use `logstash-*` as the
index pattern, and select `@timestamp` as the time-filter field.

After setting up an index pattern, you can view the system logs as they
flow in:

![kibana6-screenshot.png](/images/kibana6-screenshot.png)

For more detail on how to use Kibana, please read the official
[manual](https://www.elastic.co/guide/en/kibana/current/index.html).

To manually send logs to Elasticsearch, please use the `logger` command:

```
$ logger -t test foobar
```

When debugging your `td-agent` configuration, using
[`filter_stdout`](/plugins/filter/stdout.md) will be useful. All the logs
including errors can be found at `/etc/td-agent/td-agent.log`.

```
<filter syslog.**>
  @type stdout
</filter>

<match syslog.**>
  @type elasticsearch
  logstash_format true
  <buffer>
    flush_interval 10s # for testing
  </buffer>
</match>
```


## Conclusion

This article introduced the combination of Fluentd and Kibana (with
Elasticsearch) which achieves a free alternative to Splunk: storing and
searching machine logs. The examples provided in this article have not
been tuned.

If you will be using these components in production, you may want to
modify some of the configurations (e.g. JVM, Elasticsearch, Fluentd
buffer, etc.) according to your needs.


## Learn More

-   [Fluentd Architecture](https://www.fluentd.org/architecture)
-   [Fluentd Get Started](/overview/quickstart.md)
-   [Downloading Fluentd](http://www.fluentd.org/download)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
