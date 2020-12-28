# Java

The [`fluent-logger-java`](http://github.com/fluent/fluent-logger-java) library is used to post records from Java applications to Fluentd.

This article explains how to use it.

## Prerequisites

* Basic knowledge of Java
* Basic knowledge of Fluentd
* Java 7 or higher

## Installing Fluentd

Please refer to the following documents to install fluentd:

* [Install Fluentd with rpm Package](../installation/install-by-rpm.md)
* [Install Fluentd with deb Package](../installation/install-by-deb.md)
* [Install Fluentd with Ruby Gem](../installation/install-by-gem.md)
* [Install Fluentd from source](../installation/install-from-source.md)

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

## Using `fluent-logger-java`

Add the following dependency configuration to `pom.xml`. The logger's revision information can be found in [CHANGES.txt](https://github.com/fluent/fluent-logger-java/blob/master/CHANGES.txt):

```text
<dependencies>
  ...
  <dependency>
    <groupId>org.fluentd</groupId>
    <artifactId>fluent-logger</artifactId>
    <version>${logger.version}</version>
  </dependency>
  ...
</dependencies>
```

Here's a sample Java test application:

```text
import java.util.HashMap;
import java.util.Map;
import org.fluentd.logger.FluentLogger;

public class Main {
    private static FluentLogger LOG = FluentLogger.getLogger("fluentd.test");

    public void doApplicationLogic() {
        // ...
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("from", "userA");
        data.put("to", "userB");
        LOG.log("follow", data);
        // ...
    }
}
```

More information on the Java API can be found [here](https://github.com/fluent/fluent-logger-java).

Executing the above program will send the logs to Fluentd:

```text
$ java -jar test.jar
```

The logs should be output to `/var/log/td-agent/td-agent.log` or the standard output of the Fluentd process via [`stdout`](../output/stdout.md) output plugin.

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

Monitoring Fluentd itself is also important. The article below describes the general monitoring methods for `td-agent`:

* [Monitoring Fluentd](../monitoring-fluentd/overview.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

