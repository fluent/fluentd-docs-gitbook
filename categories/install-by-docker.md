::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| ***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

Installing Fluentd with Docker
==============================

This article explains how to use [Fluentd's official Docker
image](https://hub.docker.com/r/fluent/fluentd/), maintained by
[Treasure Data, Inc](http://www.treasuredata.com/).

-   [Fluentd's official Docker
    image](https://hub.docker.com/r/fluent/fluentd/)
-   [Fluentd's official Docker image
    (Source)](https://github.com/fluent/fluentd-docker-image)


### Table of Contents

-   [Step 0: Install Docker](#step-0:-install-docker)
-   [Step 1: Pull Fluentd's Docker
    image](#step-1:-pull-fluentd%E2%80%99s-docker-image)
-   [Step 2: Launch Fluentd
    Container](#step-2:-launch-fluentd-container)
-   [Step3: Post Sample Logs via
    HTTP](#step3:-post-sample-logs-via-http)
-   [Next Steps](#next-steps)
:::

Step 0: Install Docker
----------------------

Please download and install [Docker](https://www.docker.com/) from here.

-   [Docker Installation](https://docs.docker.com/engine/installation/)

[]{#step-1:-pull-fluentd%E2%80%99s-docker-image}

Step 1: Pull Fluentd's Docker image
-----------------------------------

Then, please download Fluentd v0.12's image by `docker pull` command.

``` {.CodeRay}
$ docker pull fluent/fluentd:v0.12-debian
```
:::
:::
:::

Debian and Alpine Linux version is available for Fluentd image. Debian
version is recommended officially since it has jemalloc support, however
Alpine image is smaller.

[]{#step-2:-launch-fluentd-container}

Step 2: Launch Fluentd Container
--------------------------------

To make the test simple, create the example config below at
`/tmp/fluentd.conf`. This example accepts records from http, and output
to stdout.

``` {.CodeRay}
# /tmp/fluentd.conf
<source>
  @type http
  port 9880
  bind 0.0.0.0
</source>
<match **>
  @type stdout
</match>
```

Finally, you can run Fluentd with `docker run` command.

``` {.CodeRay}
$ docker run -d \
  -p 9880:9880 -v /tmp:/fluentd/etc -e FLUENTD_CONF=fluentd.conf \
  fluent/fluentd
2017-01-30 11:52:23 +0000 [info]: reading config file path="/fluentd/etc/fluentd.conf"
2017-01-30 11:52:23 +0000 [info]: starting fluentd-0.12.31
2017-01-30 11:52:23 +0000 [info]: gem 'fluentd' version '0.12.31'
2017-01-30 11:52:23 +0000 [info]: adding match pattern="**" type="stdout"
2017-01-30 11:52:23 +0000 [info]: adding source type="http"
2017-01-30 11:52:23 +0000 [info]: using configuration file: <ROOT>
  <source>
    @type http
    port 9880
    bind 0.0.0.0
  </source>
  <match **>
    @type stdout
  </match>
</ROOT>
```

[]{#step3:-post-sample-logs-via-http}

Step3: Post Sample Logs via HTTP
--------------------------------

Let's post sample logs via HTTP and confirm it's working. `curl` command
is always your friend.

``` {.CodeRay}
$ curl -X POST -d 'json={"json":"message"}' http://localhost:9880/sample.test
```

Use `docker ps` command to retrieve container ID, and use `docker logs`
command to check the specific container's log.

``` {.CodeRay}
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                         NAMES
b495e527850c        fluent/fluentd      "/bin/sh -c 'exec ..."   2 hours ago         Up 2 hours          5140/tcp, 24224/tcp, 0.0.0.0:9880->9880/tcp   awesome_mcnulty
$ docker logs b495e527850c | tail -n 1
2017-01-30 14:04:37 +0000 sample.test: {"json":"message"}
```

[]{#next-steps}

Next Steps
----------

Now you know how to use Fluentd via Docker. Here're a couple of Docker
related documentations for Fluentd.

-   [Fluentd's official Docker
    image](https://hub.docker.com/r/fluent/fluentd/)
-   [Fluentd's official Docker image
    (Source)](https://github.com/fluent/fluentd-docker-image)
-   [Docker Logging Driver and Fluentd](docker-logging)
-   [Docker Logging via EFK (Elasticsearch + Fluentd + Kibana) Stack
    with Docker Compose](docker-logging-efk-compose)

Also, please see the following tutorials to learn how to collect your
data from various data sources.

-   Basic Configuration
    -   [Config File](config-file)
-   Application Logs
    -   [Ruby](ruby), [Java](java), [Python](python), [PHP](php),
        [Perl](perl), [Node.js](nodejs), [Scala](scala)
-   Examples
    -   [Store Apache Log into Amazon S3](apache-to-s3)
    -   [Store Apache Log into MongoDB](apache-to-mongodb)
    -   [Data Collection into HDFS](http-to-hdfs)

::: {style="text-align:right"}
Last updated: 2017-02-10 20:45:52 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| ***v0.12* (td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
