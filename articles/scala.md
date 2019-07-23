# Centralize Logs from Scala Applications

The '[fluent-logger-scala](http://github.com/oza/fluent-logger-scala)'
library is used to post records from Scala applications to Fluentd.

This article explains how to use the fluent-logger-scala library.


## Prerequisites

-   Basic knowledge of Scala and sbt
-   Basic knowledge of Fluentd
-   Scala 2.9.0 or 2.9.1
-   sbt 0.12.0 or later

## Installing Fluentd

Please refer to the following documents to install fluentd.

-   [Install Fluentd with rpm Package](/articles/install-by-rpm.md)
-   [Install Fluentd with deb Package](/articles/install-by-deb.md)
-   [Install Fluentd with Ruby Gem](/articles/install-by-gem.md)
-   [Install Fluentd from source](/articles/install-from-source.md)

## Modifying the Config File

Next, please configure Fluentd to use the [forward Input plugin](/plugins/input/forward.md) as its data source.

``` {.CodeRay}
<source>
  @type forward
  port 24224
</source>
<match fluentd.test.**>
  @type stdout
</match>
```

Please restart your agent once these lines are in place.

``` {.CodeRay}
# for rpm/deb only
$ sudo /etc/init.d/td-agent restart
```

## Using fluent-logger-scala

First, please add the following lines to build.sbt. The logger's
revision information can be found in the
[ChangeLog](https://github.com/oza/fluent-logger-scala/blob/master/ChangeLog).

``` {.CodeRay}
resolvers += "Apache Maven Central Repository" at "http://repo.maven.apache.org/maven2/"

libraryDependencies += "org.fluentd" %% "fluent-logger-scala" % "0.3.0"
```

or

``` {.CodeRay}
resolvers += "Sonatype Repository" at "http://oss.sonatype.org/content/repositories/releases"

libraryDependencies += "org.fluentd" %% "fluent-logger-scala" % "0.3.0"
```

Next, please insert the following lines into your application. Further
information regarding the API can be found
[here](https://github.com/oza/fluent-logger-scala).

``` {.CodeRay}
import org.fluentd.logger.scala.FluentLoggerFactory
import scala.collection.mutable.HashMap

object Sample {
  val LOG = FluentLoggerFactory.getLogger("fluentd.test")

  def main(args: Array[String]): Unit = {

    ...
    val data = new HashMap[String, String](.md);
    data.put("from", "userA");
    data.put("to", "userB");
    LOG.log("follow", data);
    ...
  }

}
```

Executing the script will send the logs to Fluentd.

``` {.CodeRay}
$ sbt
> run
```

The logs should be output to `/var/log/td-agent/td-agent.log` or stdout
of the Fluentd process via the [stdout Output plugin](/plugins/output/stdout.md).

## Production Deployments

### Output Plugins

Various [output plugins](/plugins/output/README.md) are available for
writing records to other destinations:

-   Examples
    -   [Store Apache Logs into Amazon S3](/articles/apache-to-s3.md)
    -   [Store Apache Logs into MongoDB](/articles/apache-to-mongodb.md)
    -   [Data Collection into HDFS](/articles/http-to-hdfs.md)
-   List of Plugin References
    -   [Output to Another Fluentd](/plugins/output/forward.md)
    -   [Output to MongoDB](/plugins/output/mongo.md) or [MongoDB ReplicaSet](/plugins/output/mongo_replset.md)
    -   [Output to Hadoop](/plugins/output/webhdfs.md)
    -   [Output to File](/plugins/output/file.md)
    -   [etc...](http://fluentd.org/plugin/)

### High-Availability Configurations of Fluentd

For high-traffic websites (more than 5 application nodes), we recommend
using a high availability configuration of td-agent. This will improve
data transfer reliability and query performance.

-   [High-Availability Configurations of Fluentd](/deployment/high-availability.md)

### Monitoring

Monitoring Fluentd itself is also important. The article below describes
general monitoring methods for td-agent.

-   [Monitoring Fluentd](/deployment/monitoring.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
