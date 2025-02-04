# Docker Image

This article explains how to use the official [Fluentd Docker image](https://hub.docker.com/r/fluent/fluentd/), maintained by [Treasure Data, Inc](http://www.treasuredata.com/).

* [Fluentd official Docker image](https://hub.docker.com/r/fluent/fluentd/)
* [Fluentd official Docker image \(Source\)](https://github.com/fluent/fluentd-docker-image)

## Step 0: Install Docker

Please download and install [Docker](https://www.docker.com/) from here:

* [Docker Installation](https://docs.docker.com/engine/installation/)

## Step 1: Pull Fluentd Docker Image

Then, download Fluentd edge-debian's \(edge-debian means latest version of Fluentd\) image by `docker pull` command:

```text
$ docker pull fluent/fluentd:edge-debian
```

Debian and Alpine Linux versions are available for Fluentd image. Debian version is recommended officially since it has [`jemalloc`](https://github.com/jemalloc/jemalloc) support. However, the Alpine image is smaller.
And, Windows server version is also available.

## Step 2: Launch Fluentd Container

To make the test simple, create the example config below at `$(pwd)/tmp/fluentd.conf`. This example accepts records from `http`, and outputs to `stdout`.

```text
# $(pwd)/tmp/fluentd.conf

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

```text
$ docker run -p 9880:9880 -v $(pwd)/tmp:/fluentd/etc fluent/fluentd:edge-debian -c /fluentd/etc/fluentd.conf
2025-02-04 01:57:09 +0000 [info]: init supervisor logger path=nil rotate_age=nil rotate_size=nil
2025-02-04 01:57:09 +0000 [info]: parsing config file is succeeded path="/fluentd/etc/fluentd.conf"
2025-02-04 01:57:09 +0000 [info]: gem 'fluentd' version '1.16.7'
2025-02-04 01:57:09 +0000 [warn]: define <match fluent.**> to capture fluentd logs in top level is deprecated. Use <label @FLUENT_LOG> instead
2025-02-04 01:57:09 +0000 [info]: using configuration file: <ROOT>
  <source>
    @type http
    port 9880
    bind "0.0.0.0"
  </source>
  <match **>
    @type stdout
  </match>
</ROOT>
2025-02-04 01:57:09 +0000 [info]: starting fluentd-1.16.7 pid=7 ruby="3.2.6"
2025-02-04 01:57:09 +0000 [info]: spawn command to main:  cmdline=["/usr/local/bin/ruby", "-Eascii-8bit:ascii-8bit", "/usr/local/bundle/bin/fluentd", "-c", "/fluentd/etc/fluentd.conf", "--plugin", "/fluentd/plugins", "--under-supervisor"]
2025-02-04 01:57:10 +0000 [info]: #0 init worker0 logger path=nil rotate_age=nil rotate_size=nil
2025-02-04 01:57:10 +0000 [info]: adding match pattern="**" type="stdout"
2025-02-04 01:57:10 +0000 [info]: adding source type="http"
2025-02-04 01:57:10 +0000 [warn]: #0 define <match fluent.**> to capture fluentd logs in top level is deprecated. Use <label @FLUENT_LOG> instead
2025-02-04 01:57:10 +0000 [info]: #0 starting fluentd worker pid=16 ppid=7 worker=0
2025-02-04 01:57:10 +0000 [info]: #0 fluentd worker is now running worker=0
2025-02-04 01:57:10.255688431 +0000 fluent.info: {"pid":16,"ppid":7,"worker":0,"message":"starting fluentd worker pid=16 ppid=7 worker=0"}
2025-02-04 01:57:10.266084977 +0000 fluent.info: {"worker":0,"message":"fluentd worker is now running worker=0"}
```

## Step 3: Post Sample Logs via HTTP

Use `curl` command to post sample logs via HTTP like this:

```text
$ curl -X POST -d 'json={"json":"message"}' http://127.0.0.1:9880/sample.test
```

Use `docker ps` command to retrieve container ID and use `docker logs` command to check the specific container's log like this:

```text
$ docker ps -a
CONTAINER ID   IMAGE                        COMMAND                   CREATED         STATUS         PORTS                                                            NAMES
5f0ac46c5b35   fluent/fluentd:edge-debian   "tini -- /bin/entryp…"   5 minutes ago   Up 5 minutes   5140/tcp, 24224/tcp, 0.0.0.0:9880->9880/tcp, :::9880->9880/tcp   great_mcclintock

$ docker logs 5f0ac46c5b35 | tail -n 1
2025-02-04 02:00:53.842179032 +0000 sample.test: {"json":"message"}
```

## Next Steps

Now, you know how to use Fluentd via Docker.

Here are some Docker related resources for Fluentd:

* [Fluentd official Docker image](https://hub.docker.com/r/fluent/fluentd/)
* [Fluentd official Docker image \(Source\)](https://github.com/fluent/fluentd-docker-image)
* [Docker Logging Driver and Fluentd](docker-logging-driver.md)
* [Docker Logging via EFK \(Elasticsearch + Fluentd + Kibana\) Stack with Docker Compose](docker-compose.md)

Also, refer to the following tutorials to learn how to collect data from various data sources:

* Basic Configuration
  * [Config File](../configuration/config-file.md)
* Application Logs
  * [Ruby](../language-bindings/ruby.md)
  * [Java](../language-bindings/java.md)
  * [Python](../language-bindings/python.md)
  * [PHP](../language-bindings/php.md)
  * [Perl](../language-bindings/perl.md)
  * [Node.js](../language-bindings/nodejs.md)
  * [Scala](../language-bindings/scala.md)
* Examples
  * [Store Apache Log into Amazon S3](../how-to-guides/apache-to-s3.md)
  * [Store Apache Log into MongoDB](../how-to-guides/apache-to-mongodb.md)
  * [Data Collection into HDFS](../how-to-guides/http-to-hdfs.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

