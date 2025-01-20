# Python

The [`fluent-logger-python`](http://github.com/fluent/fluent-logger-python) library is used to post records from Python applications to Fluentd.

This article explains how to use it.

## Prerequisites

* Basic knowledge of Python
* Basic knowledge of Fluentd
* Python 2.6 or higher

## Installing Fluentd

Please refer to the following document to install Fluentd:

* [Installation](../installation/)

## Modifying the Config File

Configure Fluentd to use the [`forward`](../input/forward.md) input plugin as its data source:

```text
<source>
  @type forward
  port 24224
</source>
<match fluentd.test.**>
  @type stdout
</match>
```

Restart agent after configuring.

```text
# for rpm/deb only
$ sudo /etc/init.d/td-agent restart

# or systemd
$ sudo systemctl restart td-agent.service
```

## Using `fluent-logger-python`

Install `fluent-logger` library via `pip`:

```text
$ pip install fluent-logger
```

Initialize and post the records as shown below:

```text
# test.py
from fluent import sender
from fluent import event
sender.setup('fluentd.test', host='localhost', port=24224)
event.Event('follow', {
  'from': 'userA',
  'to':   'userB'
})
```

Executing the script will send the logs to Fluentd:

```text
$ python test.py
```

The logs should be output to `/var/log/td-agent/td-agent.log` or the standard output of the Fluentd process via the [`stdout`](../output/stdout.md) output plugin.

## Production Deployments

### Output Plugins

Various [output plugins](../output/) are available for writing records to other destinations:

* Examples
  * [Store Apache Logs into Amazon S3](../how-to-guides/apache-to-s3.md)
  * [Store Apache Logs into MongoDB](../how-to-guides/apache-to-mongodb.md)
  * [Data Collection into HDFS](../how-to-guides/http-to-hdfs.md)
* List of Plugin References
  * [Output to Another Fluentd](../output/forward.md)
  * [Output to MongoDB](../output/mongo.md) or [MongoDB ReplicaSet](../output/mongo_replset.md)
  * [Output to Hadoop](../output/webhdfs.md)
  * [Output to File](../output/file.md)
  * [etc...](http://fluentd.org/plugin/)

### High-Availability Configurations of Fluentd

For high-traffic websites \(more than 5 application nodes\), we recommend using the high-availability configuration for `td-agent`. This will improve the reliability of data transfer and query performance.

* [High-Availability Configurations of Fluentd](../deployment/high-availability.md)

### Monitoring

Monitoring Fluentd itself is also important. The article below describes the general monitoring methods for `td-agent`.

* [Monitoring Fluentd](../monitoring-fluentd/overview.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

