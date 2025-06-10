# Data Collection with Hadoop \(HDFS\)

This article explains how to use [Fluentd](http://fluentd.org/)'s [WebHDFS Output plugin](http://github.com/fluent/fluent-plugin-webhdfs/) to aggregate semi-structured logs into Hadoop HDFS.

## Background

[Fluentd](http://fluentd.org/) is an advanced open-source log collector originally developed at [Treasure Data, Inc](http://www.treasuredata.com/). Fluentd is specifically designed to solve the big-data log collection problem. A lot of users are using Fluentd with MongoDB, and have found that it doesn't scale well for now.

HDFS \(Hadoop\) is a natural alternative for storing and processing a huge amount of data. It supports an HTTP interface called WebHDFS in addition to its Java library.

This article will show you how to use [Fluentd](http://fluentd.org/) to receive data from HTTP and stream it into HDFS.

## Architecture

The figure below shows the high-level architecture:

![HTTP-to-HDFS Overview](../.gitbook/assets/http-to-hdfs.png)

## Prerequisites

The following software/services are required to be set up correctly:

* [Fluentd](https://www.fluentd.org/)
* Apache HDFS
* [WebHDFS Output Plugin](https://github.com/fluent/fluent-plugin-webhdfs/) ([`out_webhdfs`](../output/webhdfs.md))

For simplicity, this article will describe how to set up a one-node configuration. Please install the following software on the same node:

You can install Fluentd via major packaging systems.

* [Installation](../installation/)

For Cloudera CDH, please refer to the [downloads page](https://www.cloudera.com/downloads.html)

{% hint style='info' %}
NOTE: CDH (Cloudera Distributed Hadoop) was discontinued. Superseded by Cloudera's CDP Private Cloud.
{% endhint %}


### Install plugin

If `out_webhdfs` (fluent-plugin-webhdfs) is not installed yet, please install it manually.

See [Plugin Management](../installation/post-installation-guide#plugin-management) section how to install fluent-plugin-webhdfs on your environment.

{% hint style='info' %}
If you use `fluent-package`, out_webhdfs (fluent-plugin-webhdfs) is bundled by default.
{% endhint %}

## Fluentd Configuration

Let's start configuring Fluentd. If you used the deb/rpm package, Fluentd's config file is located at `/etc/fluent/fluentd.conf`.

### HTTP Input

For the input source, we will set up Fluentd to accept records from HTTP. The Fluentd configuration file should look like this:

```text
<source>
  @type http
  port 8888
</source>
```

### WebHDFS Output

The output destination will be WebHDFS. The output configuration should look like this:

```text
<match hdfs.*.*>
  @type webhdfs
  host namenode.your.cluster.local
  port 50070
  path "/log/%Y%m%d_%H/access.log.#{Socket.gethostname}"
  <buffer>
    flush_interval 10s
  </buffer>
</match>
```

The `<match>` section specifies the regexp used to look for matching tags. If a tag in a log is matched, the respective `match` configuration is used \(i.e. the log is routed accordingly\).

The `flush_interval` parameter specifies how often the data is written to HDFS. An append operation is used to append the incoming data to the file specified by the `path` parameter.

Placeholders for both time and hostname can be used with the `path` parameter. This prevents multiple Fluentd instances from appending data to the same file, which must be avoided for append operations.

Other options specify HDFS's NameNode host and port.

## HDFS Configuration

Append operations are not enabled by default. Please put these configurations into your `hdfs-site.xml` file and restart the whole cluster:

```text
<property>
  <name>dfs.webhdfs.enabled</name>
  <value>true</value>
</property>

<property>
  <name>dfs.support.append</name>
  <value>true</value>
</property>

<property>
  <name>dfs.support.broken.append</name>
  <value>true</value>
</property>
```

Please confirm that the HDFS user has the write access to the `path` specified as the WebHDFS output.

## Test

To test the configuration, just post the JSON to Fluentd \(we use the `curl` command in this example\). Sending a `USR1` signal flushes Fluentd's buffer into WebHDFS:

```text
$ curl -X POST -d 'json={"action":"login","user":2}' \
  http://localhost:8888/hdfs.access.test
$ kill -USR1 `cat /var/run/fluent/fluentd.pid`
```

We can then access HDFS to see the stored data:

```text
$ sudo -u hdfs hadoop fs -lsr /log/
drwxr-xr-x   - 1 supergroup          0 2012-10-22 09:40 /log/20121022_14/access.log.dev
```

## Conclusion

Fluentd with WebHDFS makes the realtime log collection simple, robust and scalable! [@tagomoris](http://github.com/tagomoris) has already been using this plugin to collect 20,000 msgs/sec, 1.5 TB/day without any major problems for several months now.

## Learn More

* [Fluentd Architecture](https://www.fluentd.org/architecture)
* [Fluentd Get Started](../quickstart/)
* [WebHDFS Output Plugin](../output/webhdfs.md)
* [Slides: Fluentd and WebHDFS](http://www.slideshare.net/tagomoris/fluentd-and-webhdfs)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

