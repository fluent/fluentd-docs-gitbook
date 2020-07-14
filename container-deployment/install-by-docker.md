# Installing Fluentd with Docker

This article explains how to use the official [Fluentd Docker
image](https://hub.docker.com/r/fluent/fluentd/), maintained by [Treasure Data,
Inc](http://www.treasuredata.com/).

- [Fluentd official Docker image](https://hub.docker.com/r/fluent/fluentd/)
- [Fluentd official Docker image
  (Source)](https://github.com/fluent/fluentd-docker-image)


## Step 0: Install Docker

Please download and install [Docker](https://www.docker.com/) from here:

- [Docker Installation](https://docs.docker.com/engine/installation/)

## Step 1: Pull Fluentd Docker Image

Then, download Fluentd v1.6-debian-1's image by `docker pull` command:

``` {.CodeRay}
$ docker pull fluent/fluentd:v1.6-debian-1
```

Debian and Alpine Linux version is available for Fluentd image. Debian version
is recommended officially since it has
[`jemalloc`](https://github.com/jemalloc/jemalloc) support. However, the Alpine
image is smaller.


## Step 2: Launch Fluentd Container

To make the test simple, create the example config below at `/tmp/fluentd.conf`.
This example accepts records from `http`, and outputs to `stdout`.

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

Finally, you can run Fluentd with `docker run` command:

``` {.CodeRay}
$ docker run -p 9880:9880 -v $(pwd)/tmp:/fluentd/etc -e FLUENTD_CONF=fluentd.conf fluent/fluentd:v1.6-debian-1
2019-08-21 00:30:37 +0000 [info]: parsing config file is succeeded path="/fluentd/etc/fluentd.conf"
2019-08-21 00:30:37 +0000 [info]: using configuration file: <ROOT>
  <source>
    @type http
    port 9880
    bind "0.0.0.0"
  </source>
  <match **>
    @type stdout
  </match>
</ROOT>
2019-08-21 00:30:37 +0000 [info]: starting fluentd-1.6.3 pid=6 ruby="2.6.3"
2019-08-21 00:30:37 +0000 [info]: spawn command to main:  cmdline=["/usr/local/bin/ruby", "-Eascii-8bit:ascii-8bit", "/usr/local/bundle/bin/fluentd", "-c", "/fluentd/etc/fluentd.conf", "-p", "/fluentd/plugins", "--under-supervisor"]
2019-08-21 00:30:38 +0000 [info]: gem 'fluentd' version '1.6.3'
2019-08-21 00:30:38 +0000 [info]: adding match pattern="**" type="stdout"
2019-08-21 00:30:38 +0000 [info]: adding source type="http"
2019-08-21 00:30:38 +0000 [info]: #0 starting fluentd worker pid=13 ppid=6 worker=0
2019-08-21 00:30:38 +0000 [info]: #0 fluentd worker is now running worker=0
2019-08-21 00:30:38.332472611 +0000 fluent.info: {"worker":0,"message":"fluentd worker is now running worker=0"}
```


## Step 3: Post Sample Logs via HTTP

Use `curl` command to post sample logs via HTTP like this:

``` {.CodeRay}
$ curl -X POST -d 'json={"json":"message"}' http://localhost:9880/sample.test
```

Use `docker ps` command to retrieve container ID and use `docker logs` command
to check the specific container's log like this:

``` {.CodeRay}
$ docker ps -a
CONTAINER ID        IMAGE                          COMMAND                  CREATED              STATUS              PORTS                                         NAMES
775a8e192f2b        fluent/fluentd:v1.6-debian-1   "tini -- /bin/entryp…"   About a minute ago   Up About a minute   5140/tcp, 24224/tcp, 0.0.0.0:9880->9880/tcp   tender_leakey

$ docker logs 775a8e192f2b | tail -n 1
2019-08-21 00:33:00.570707843 +0000 sample.test: {"json":"message"}
```


## Next Steps

Now, you know how to use Fluentd via Docker.

Here are some Docker related resources for Fluentd:

- [Fluentd official Docker image](https://hub.docker.com/r/fluent/fluentd/)
- [Fluentd official Docker image
  (Source)](https://github.com/fluent/fluentd-docker-image)
- [Docker Logging Driver and
  Fluentd](/container-deployment/docker-logging-driver.md)
- [Docker Logging via EFK (Elasticsearch + Fluentd + Kibana) Stack with Docker
  Compose](/container-deployment/docker-compose.md)

Also, refer to the following tutorials to learn how to collect data from various
data sources:

- Basic Configuration
  - [Config File](/configuration/config-file.md)
- Application Logs
  - [Ruby](/language/ruby.md), [Java](/language/java.md),
    [Python](/language/python.md), [PHP](/language/php.md),
    [Perl](/language/perl.md), [Node.js](/language/nodejs.md),
    [Scala](/language/scala.md)
- Examples
  - [Store Apache Log into Amazon S3](/guides/apache-to-s3.md)
  - [Store Apache Log into MongoDB](/guides/apache-to-mongodb.md)
  - [Data Collection into HDFS](/guides/http-to-hdfs.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
