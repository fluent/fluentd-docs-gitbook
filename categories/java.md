
Versions \| [v1.0 (td-agent3)](/v1.0/articles/java) \| ***v0.12*(td-agent2) **
------------------------------------------------------------------------

Centralize Logs from Java Applications
======================================

The '[fluent-logger-java](http://github.com/fluent/fluent-logger-java)'
library is used to post records from Java applications to Fluentd.

This article explains how to use the fluent-logger-java library.


### Table of Contents

[Prerequisites](#prerequisites)

[Installing Fluentd](#installing-fluentd)

[Modifying the Config File](#modifying-the-config-file)

[Using fluent-logger-java](#using-fluent-logger-java)

[Production Deployments](#production-deployments)

-   [Output Plugins](#output-plugins)
-   [High-Availability Configurations of
    Fluentd](#high-availability-configurations-of-fluentd)
-   [Monitoring](#monitoring)
Prerequisites
-------------

-   Basic knowledge of Java
-   Basic knowledge of Fluentd
-   Java 6 or higher

Installing Fluentd
------------------

Please refer to the following documents to install fluentd.

-   [Install Fluentd with rpm Package](install-by-rpm)
-   [Install Fluentd with deb Package](install-by-deb)
-   [Install Fluentd with Ruby Gem](install-by-gem)
-   [Install Fluentd from source](install-from-source)

Modifying the Config File
-------------------------

Next, please configure Fluentd to use the [forward Input
plugin](in_forward) as its data source.

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

Using fluent-logger-java
------------------------

First, please add the following lines to pom.xml. The logger's revision
information can be found in
[CHANGES.txt](https://github.com/fluent/fluent-logger-java/blob/master/CHANGES.txt).

``` {.CodeRay}
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

Next, please insert the following lines into your application. Further
information regarding the API can be found
[here](https://github.com/fluent/fluent-logger-java).

``` {.CodeRay}
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

Executing the script will send the logs to Fluentd.

``` {.CodeRay}
$ java -jar test.jar
```

The logs should be output to `/var/log/td-agent/td-agent.log` or stdout
of the Fluentd process via the [stdout Output plugin](out_stdout).

Production Deployments
----------------------

### Output Plugins

Various [output plugins](output-plugin-overview) are available for
writing records to other destinations:

-   Examples
    -   [Store Apache Logs into Amazon S3](apache-to-s3)
    -   [Store Apache Logs into MongoDB](apache-to-mongodb)
    -   [Data Collection into HDFS](http-to-hdfs)
-   List of Plugin References
    -   [Output to Another Fluentd](out_forward)
    -   [Output to MongoDB](out_mongo) or [MongoDB
        ReplicaSet](out_mongo_replset)
    -   [Output to Hadoop](out_webhdfs)
    -   [Output to File](out_file)
    -   [etc...](http://fluentd.org/plugin/)

### High-Availability Configurations of Fluentd

For high-traffic websites (more than 5 application nodes), we recommend
using a high availability configuration of td-agent. This will improve
data transfer reliability and query performance.

-   [High-Availability Configurations of Fluentd](high-availability)

### Monitoring

Monitoring Fluentd itself is also important. The article below describes
general monitoring methods for td-agent.

-   [Monitoring Fluentd](monitoring)


Last updated: 2017-01-30 13:27:02 UTC
------------------------------------------------------------------------
Versions \| [v1.0 (td-agent3)](/v1.0/articles/java) \| ***v0.12*(td-agent2) **
------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
