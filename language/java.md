# Centralize Logs from Java Applications

The [`fluent-logger-java`](http://github.com/fluent/fluent-logger-java)
library is used to post records from Java applications to Fluentd.

This article explains how to use it.


## Prerequisites

-   Basic knowledge of Java
-   Basic knowledge of Fluentd
-   Java 7 or higher


## Installing Fluentd

Please refer to the following documents to install fluentd:

-   [Install Fluentd with rpm Package](/install/install-by-rpm.md)
-   [Install Fluentd with deb Package](/install/install-by-deb.md)
-   [Install Fluentd with Ruby Gem](/install/install-by-gem.md)
-   [Install Fluentd from source](/install/install-from-source.md)


## Modifying the Config File

Configure Fluentd to use the [`forward`](/plugins/input/forward.md) input plugin
as its data source:

```
<source>
  @type forward
  port 24224
</source>
<match fluentd.test.**>
  @type stdout
</match>
```

Restart agent after configuring.

```
# for rpm/deb only
$ sudo /etc/init.d/td-agent restart

# or systemd
$ sudo systemctl restart td-agent.service
```


## Using `fluent-logger-java`

Add the following dependency configuration to `pom.xml`. The logger's revision
information can be found in
[CHANGES.txt](https://github.com/fluent/fluent-logger-java/blob/master/CHANGES.txt):

```
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

```
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

More information on the Java API can be found 
[here](https://github.com/fluent/fluent-logger-java).

Executing the above program will send the logs to Fluentd:

```
$ java -jar test.jar
```

The logs should be output to `/var/log/td-agent/td-agent.log` or the standard
output of the Fluentd process via [`stdout`](/plugins/output/stdout.md) output
plugin.


## Production Deployments


### Output Plugins

Various [output plugins](/plugins/output/README.md) are available for writing
records to other destinations:

-   Examples
    -   [Store Apache Logs into Amazon S3](/guides/apache-to-s3.md)
    -   [Store Apache Logs into MongoDB](/guides/apache-to-mongodb.md)
    -   [Data Collection into HDFS](/guides/http-to-hdfs.md)
-   List of Plugin References
    -   [Output to Another Fluentd](/plugins/output/forward.md)
    -   [Output to MongoDB](/plugins/output/mongo.md) or [MongoDB ReplicaSet](/plugins/output/mongo_replset.md)
    -   [Output to Hadoop](/plugins/output/webhdfs.md)
    -   [Output to File](/plugins/output/file.md)
    -   [etc...](http://fluentd.org/plugin/)


### High-Availability Configurations of Fluentd

For high-traffic websites (more than 5 application nodes), we recommend using
high-availability configuration for `td-agent`. This will improve the
reliability of data transfer and query performance.

-   [High-Availability Configurations of Fluentd](/deployment/high-availability.md)


### Monitoring

Monitoring Fluentd itself is also important. The article below describes
general monitoring methods for `td-agent`:

-   [Monitoring Fluentd](/deployment/monitoring.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
