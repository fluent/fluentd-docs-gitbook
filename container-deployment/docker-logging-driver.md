# Docker Logging Driver

The article describes how to implement a unified logging system for your [Docker](http://www.docker.com) containers. An application in a production environment requires to register certain events or problems during its runtime.

The old-fashioned way is to write these messages into a log file, but that inherits certain problems. Specifically, when we try to perform some analysis over the registers, or on the other hand, if the application has multiple instances running, the scenario becomes even more complex.

On Docker v1.6, the concept of [**logging drivers**](https://docs.docker.com/engine/admin/logging/overview/) was introduced. The Docker engine is aware of the output interfaces that manage the application messages.

For Docker v1.8, we have implemented a native [**Fluentd Docker logging driver**](https://docs.docker.com/engine/admin/logging/fluentd/). Now, you are able to have a unified and structured logging system with the simplicity and high performance of [Fluentd](http://fluentd.org).

NOTE: Currently, the Fluentd logging driver doesn't support sub-second precision.

## Getting Started

Using the Docker logging mechanism with [Fluentd](http://www.fluentd.org) is a straightforward step. To get started, make sure you have the following prerequisites:

* A basic understanding of [Fluentd](http://www.fluentd.org)
* A basic understanding of Docker
* A basic understanding of [Docker logging drivers](https://docs.docker.com/engine/admin/logging/overview/)
* Docker v1.8+

For simplicity, the Fluentd is launched as a standard process, not as a container.

Please refer to [Docker Logging via EFK \(Elasticsearch + Fluentd + Kibana\) Stack with Docker Compose](docker-compose.md) for a fully containerized tutorial.

### Step 1: Create the Fluentd Configuration File

The first step is to prepare Fluentd to listen for the messages coming from the Docker containers. For demonstration purposes, we will instruct Fluentd to write the messages to the standard output. Later, you will find how to accomplish the same by aggregating the logs into a MongoDB instance.

Create `demo.conf` with the following configuration:

```text
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<match **>
  @type stdout
</match>
```

### Step 2: Start Fluentd

Now, start an instance of Fluentd like this:

```text
$ docker run -it -p 24224:24224 -v $(pwd)/demo.conf:/fluentd/etc/demo.conf -e FLUENTD_CONF=demo.conf fluent/fluentd:edge-debian
```

On successful start, you should see the Fluentd startup logs:

```text
2025-02-04 07:52:25 +0000 [info]: init supervisor logger path=nil rotate_age=nil rotate_size=nil
2025-02-04 07:52:25 +0000 [info]: parsing config file is succeeded path="/fluentd/etc/demo.conf"
2025-02-04 07:52:26 +0000 [info]: gem 'fluentd' version '1.16.7'
2025-02-04 07:52:26 +0000 [info]: using configuration file: <ROOT>
  <source>
    @type forward
    port 24224
    bind "0.0.0.0"
  </source>
  <match *>
    @type stdout
  </match>
</ROOT>
2025-02-04 07:52:26 +0000 [info]: starting fluentd-1.16.7 pid=7 ruby="3.2.6"
2025-02-04 07:52:26 +0000 [info]: spawn command to main:  cmdline=["/usr/local/bin/ruby", "-Eascii-8bit:ascii-8bit", "/usr/local/bundle/bin/fluentd", "--config", "/fluentd/etc/demo.conf", "--plugin", "/fluentd/plugins", "--under-supervisor"]
2025-02-04 07:52:26 +0000 [info]: #0 init worker0 logger path=nil rotate_age=nil rotate_size=nil
2025-02-04 07:52:26 +0000 [info]: adding match pattern="*" type="stdout"
2025-02-04 07:52:26 +0000 [info]: adding source type="forward"
2025-02-04 07:52:26 +0000 [info]: #0 starting fluentd worker pid=16 ppid=7 worker=0
2025-02-04 07:52:26 +0000 [info]: #0 listening port port=24224 bind="0.0.0.0"
2025-02-04 07:52:26 +0000 [info]: #0 fluentd worker is now running worker=0
```

### Step 3: Start Docker Container with Fluentd Driver

By default, the Fluentd logging driver will try to find a local Fluentd instance \(Step \# 2\) listening for connections on the TCP port `24224`. Note that the container will not start if it cannot connect to the Fluentd instance.

The following command will run a base Ubuntu container and print some messages to the standard output:

```text
$ docker run --log-driver=fluentd ubuntu echo "Hello Fluentd"
Hello Fluentd
```

Note that we have launched the container specifying the Fluentd logging driver i.e. `--log-driver=fluentd`.

### Step 4: Confirm

Now, you should see the incoming messages from the container in Fluentd logs:

```text
2025-02-04 07:52:46.000000000 +0000 a4289c14a0ba: {"container_id":"a4289c14a0ba4716deff4d2aadc2b9a51331c0b9a5d631115060ffda959b2bc3","container_name":"/vigilant_babbage","source":"stdout","log":"Hello Fluentd"}
```

At this point, you will notice that the incoming messages are in JSON format, have a timestamp, are tagged with the `container_id` and contain general information from the source container along with the message.

### Additional Step 1: Parse Log Message

The application log is stored in the `"log"` field in the record. You can parse this log before sending it to the destinations by using [`filter_parser`](../filter/parser.md).

```text
# filter configuration
<filter docker.**>
  @type parser
  key_name log
  reserve_data true
  <parse>
    @type json # apache2, nginx, etc.
  </parse>
</filter>

<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<match **>
  @type stdout
</match>
```

Then you provide the log message with JSON format:

```text
$ docker run --log-driver=fluentd --log-opt tag=docker ubuntu echo "{\"key\":\"value\"}"
```

About `--log-opt tag=...`, please refer at [Driver Options](#driver-options) section.

Original Event (without filter plugin):

```text
2025-02-04 08:20:07.000000000 +0000 docker: {"container_id":"291757f94709abd945ba07c7769c46a5c011f014119c0c56b79e287b00dad4ab","container_name":"/awesome_euler","source":"stdout","log":"{\"key\":\"value\"}"}
```

Filtered Event:

```text
2025-02-04 08:20:37.969077831 +0000 docker: {"container_id":"291757f94709abd945ba07c7769c46a5c011f014119c0c56b79e287b00dad4ab","container_name":"/awesome_euler","source":"stdout","log":"{\"key\":\"value\"}","key":"value"}
```

### Additional Step 2: Concatenate Multiple Lines Log Messages

The application log is stored in the `log` field of the record. You can concatenate these logs by using [`fluent-plugin-concat`](https://github.com/fluent-plugins-nursery/fluent-plugin-concat) filter before sending it to the destinations.

At first, you need to create custom docker image due to install the `fluent-plugin-concat` gem in the Fluentd container.

Create `Dockerfile` with the following content:

```text
# Dockerfile
FROM fluent/fluentd:edge-debian

USER root
RUN fluent-gem install fluent-plugin-concat

USER fluent
```

Build the custom image:

```text
$ docker build . -t fluentd-test
```

Then, create the configuration file `demo.conf` with the following content:

```text
# filter configuration
<filter docker.**>
  @type concat
  key log
  stream_identity_key container_id
  multiline_start_regexp /^-e:2:in `\/'/
  multiline_end_regexp /^-e:4:in/
</filter>

<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<match **>
  @type stdout
</match>
```

Launch the Fluentd container:

```
$ docker run -it -p 24224:24224 -v $(pwd)/demo.conf:/fluentd/etc/demo.conf -e FLUENTD_CONF=demo.conf fluentd-test
```

Then you provide the log message contains newlines:

```text
$ docker run --log-driver=fluentd --log-opt tag=docker ubuntu echo "-e:2:in \`/'"$'\n'"-e:2:in \`do_division_by_zero'"$'\n'"-e:4:in \`<main>'"
```

Original Events (without filter plugin):

```text
2025-02-04 09:18:12.000000000 +0000 docker: {"container_id":"6998df1c3ad699d40abb58ab9f5cd4cd4ee51fb1bf99389deed64c2ffe439418","container_name":"/vigilant_ganguly","source":"stdout","log":"-e:2:in `/'"}
2025-02-04 09:18:12.000000000 +0000 docker: {"container_id":"6998df1c3ad699d40abb58ab9f5cd4cd4ee51fb1bf99389deed64c2ffe439418","container_name":"/vigilant_ganguly","source":"stdout","log":"-e:2:in `do_division_by_zero'"}
2025-02-04 09:18:12.000000000 +0000 docker: {"container_id":"6998df1c3ad699d40abb58ab9f5cd4cd4ee51fb1bf99389deed64c2ffe439418","container_name":"/vigilant_ganguly","source":"stdout","log":"-e:4:in `<main>'"}
```

Filtered Events:

```text
2025-02-04 09:18:30.000000000 +0000 docker: {"container_id":"6998df1c3ad699d40abb58ab9f5cd4cd4ee51fb1bf99389deed64c2ffe439418","container_name":"/vigilant_ganguly","source":"stdout","log":"-e:2:in `/'\n-e:2:in `do_division_by_zero'\n-e:4:in `<main>'"}
```

If the logs are typical stacktraces, consider using [`detect-exceptions`](https://github.com/GoogleCloudPlatform/fluent-plugin-detect-exceptions) plugin instead.

**NOTE**:
For plugins with the simple file structure, such as `fluent-plugin-concat`, `plugins` directory can be used instead of creating custom docker image.

Prepare the `plugins` directory and copy the plugin file:

```text
$ mkdir $(pwd)/plugins

$ git clone https://github.com/fluent-plugins-nursery/fluent-plugin-concat.git /tmp/fluent-plugin-concat
$ cp /tmp/fluent-plugin-concat/lib/fluent/plugin/filter_concat.rb $(pwd)/plugins
```

Launch the Fluentd container with `plugins` directory mounted:

```
$ docker run -it -p 24224:24224 -v $(pwd)/plugins:/fluentd/plugins -v $(pwd)/demo.conf:/fluentd/etc/demo.conf -e FLUENTD_CONF=demo.conf fluent/fluentd:edge-debian
```

## Driver Options

The [Fluentd Logging Driver](https://docs.docker.com/engine/admin/logging/fluentd/) supports following options through the `--log-opt` Docker command-line argument:

* `fluentd-address`
* `tag`

#### `fluentd-address`

Specifies the optional address \(`<ip>:<port>`\) for Fluentd.

Example:

```text
$ docker run --log-driver=fluentd --log-opt fluentd-address=192.168.2.4:24225 ubuntu echo "..."
```

#### `tag`

[Log tags](https://docs.docker.com/engine/admin/logging/log_tags/) are a major requirement for Fluentd as they allow for identifying the source of incoming data and take routing decisions. By default, the Fluentd logging driver uses the `container_id` as a tag \(64 character ID\). You can change its value with the `tag` option like this:

```text
$ docker run --log-driver=fluentd --log-opt tag=docker.my_new_tag ubuntu echo "..."
```

Additionally, this option allows to specify some internal variables such as `{{.ID}}`, `{{.FullID}}` or `{{.Name}}` like this:

```text
$ docker run --log-driver=fluentd --log-opt tag=docker.{{.ID}} ubuntu echo "..."
```

## Development Environments

For a real-world use-case, you would want to use something other than the Fluentd standard output to store Docker container messages, such as Elasticsearch, MongoDB, HDFS, S3, Google Cloud Storage, and so on.

This document describes how to set up a multi-container logging environment via EFK \(Elasticsearch, Fluentd, Kibana\) with Docker Compose.

* [Docker Logging via EFK \(Elasticsearch + Fluentd + Kibana\) Stack with Docker Compose](docker-compose.md)

## Production Environments

In a production environment, you must use one of the container orchestration tools. Currently, Kubernetes has better integration with Fluentd, and we're working on making better integrations with other tools as well.

* [Kubernetes Logging Overview](https://kubernetes.io/docs/user-guide/logging/overview/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

