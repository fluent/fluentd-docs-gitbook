# Java

The [`fluent-logger-java`](https://github.com/fluent/fluent-logger-java) library is used to post records from Java applications to Fluentd.

{% hint style='warning' %}
`fluent-logger-java` is not actively maintained. It has not been updated since 2019, and the Fluentd maintainers are looking for someone to maintain it \(see [fluent/fluent-logger-java#99](https://github.com/fluent/fluent-logger-java/issues/99)\). For new applications, consider [Fluency](https://github.com/komamitsu/fluency) instead.
{% endhint %}

This article explains how to use Fluency and `fluent-logger-java`.

## Prerequisites

* Basic knowledge of Java
* Basic knowledge of Fluentd
* Java 8 or higher \(Fluency\) or Java 7 or higher \(`fluent-logger-java`\)

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

Restart Fluentd after configuring.

```text
# for fluent-package (rpm/deb)
$ sudo systemctl restart fluentd
```

## Using Fluency

[Fluency](https://github.com/komamitsu/fluency) is a logger which sends records to Fluentd with the [forward protocol](../input/forward.md). It buffers the records in memory and sends them asynchronously. It also supports failover between multiple Fluentd instances, ack responses, and TLS.

Add the following dependency configuration to `pom.xml`. The latest version can be found in [CHANGELOG.md](https://github.com/komamitsu/fluency/blob/master/CHANGELOG.md):

```text
<dependencies>
  ...
  <dependency>
    <groupId>org.komamitsu</groupId>
    <artifactId>fluency-core</artifactId>
    <version>${fluency.version}</version>
  </dependency>
  <dependency>
    <groupId>org.komamitsu</groupId>
    <artifactId>fluency-fluentd</artifactId>
    <version>${fluency.version}</version>
  </dependency>
  ...
</dependencies>
```

Here's a sample Java test application:

```text
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import org.komamitsu.fluency.Fluency;
import org.komamitsu.fluency.fluentd.FluencyBuilderForFluentd;

public class Main {
    public static void main(String[] args) throws IOException {
        // Sends records to localhost:24224
        Fluency fluency = new FluencyBuilderForFluentd().build();

        Map<String, Object> data = new HashMap<String, Object>();
        data.put("from", "userA");
        data.put("to", "userB");
        fluency.emit("fluentd.test.follow", data);

        // Flushes the buffered records and releases the resources
        fluency.close();
    }
}
```

Executing the above program will send the record with the `fluentd.test.follow` tag to Fluentd, and it will be output via the [`stdout`](../output/stdout.md) output plugin.

`Fluency#emit` does not send the record at once. Call `Fluency#close` before the application exits, or the buffered records may be lost. If the buffer is full, `Fluency#emit` throws `org.komamitsu.fluency.BufferFullException`.

More information on Fluency, such as the buffer and retry settings, can be found [here](https://github.com/komamitsu/fluency).

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

The logs should be output to `/var/log/fluent/fluentd.log` or the standard output of the Fluentd process via [`stdout`](../output/stdout.md) output plugin.

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
  * [etc...](https://www.fluentd.org/plugins/)

### High-Availability Configurations of Fluentd

For high-traffic websites \(more than 5 application nodes\), we recommend using the high-availability configuration for Fluentd. This will improve the reliability of data transfer and query performance.

* [High-Availability Configurations of Fluentd](../deployment/high-availability.md)

### Monitoring

Monitoring Fluentd itself is also important. The article below describes the general monitoring methods for Fluentd:

* [Monitoring Fluentd](../monitoring-fluentd/overview.md)
