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

Debian and Alpine Linux version is available for Fluentd image. Debian version is recommended officially since it has [`jemalloc`](https://github.com/jemalloc/jemalloc) support. However, the Alpine image is smaller.

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
2021-03-16 09:11:32 +0000 [info]: parsing config file is succeeded path="/fluentd/etc/fluentd.conf"
2021-03-16 09:11:32 +0000 [info]: gem 'fluentd' version '1.11.5'
2021-03-16 09:11:32 +0000 [warn]: define <match fluent.**> to capture fluentd logs in top level is deprecated. Use <label @FLUENT_LOG> instead
2021-03-16 09:11:32 +0000 [info]: using configuration file: <ROOT>
  <source>
    @type http
    port 9880
    bind "0.0.0.0"
  </source>
  <match **>
    @type stdout
  </match>
</ROOT>
2021-03-16 09:11:32 +0000 [info]: starting fluentd-1.11.5 pid=7 ruby="2.6.6"
2021-03-16 09:11:32 +0000 [info]: spawn command to main:  cmdline=["/usr/local/bin/ruby", "-Eascii-8bit:ascii-8bit", "/usr/local/bundle/bin/fluentd", "-c", "/fluentd/etc/fluentd.conf", "-p", "/fluentd/plugins", "--under-supervisor"]
2021-03-16 09:11:33 +0000 [info]: adding match pattern="**" type="stdout"
2021-03-16 09:11:33 +0000 [info]: adding source type="http"
2021-03-16 09:11:33 +0000 [warn]: #0 define <match fluent.**> to capture fluentd logs in top level is deprecated. Use <label @FLUENT_LOG> instead
2021-03-16 09:11:33 +0000 [info]: #0 starting fluentd worker pid=16 ppid=7 worker=0
2021-03-16 09:11:33 +0000 [info]: #0 fluentd worker is now running worker=0
2021-03-16 09:11:33.025408358 +0000 fluent.info: {"pid":16,"ppid":7,"worker":0,"message":"starting fluentd worker pid=16 ppid=7 worker=0"}
2021-03-16 09:11:33.026503372 +0000 fluent.info: {"worker":0,"message":"fluentd worker is now running worker=0"}
```

## Step 3: Post Sample Logs via HTTP

Use `curl` command to post sample logs via HTTP like this:

```text
$ curl -X POST -d 'json={"json":"message"}' http://127.0.0.1:9880/sample.test
```

Use `docker ps` command to retrieve container ID and use `docker logs` command to check the specific container's log like this:

```text
$ docker ps -a
CONTAINER ID        IMAGE                          COMMAND                  CREATED              STATUS              PORTS                                         NAMES
775a8e192f2b        fluent/fluentd:edge-debian   "tini -- /bin/entryp…"   About a minute ago   Up About a minute   5140/tcp, 24224/tcp, 0.0.0.0:9880->9880/tcp   tender_leakey

$ docker logs 775a8e192f2b | tail -n 1
2021-03-16 09:12:15.257351750 +0000 sample.test: {"json":"message"}
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

