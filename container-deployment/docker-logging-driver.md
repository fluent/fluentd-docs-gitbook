# Docker Logging Driver

The article describes how to implement a unified logging system for your [Docker](http://www.docker.com) containers. An application in a production environment requires to register certain events or problems during its runtime.

The old-fashioned way is to write these messages into a log file, but that inherits certain problems. Specifically, when we try to perform some analysis over the registers, or on the other hand, if the application has multiple instances running, the scenario becomes even more complex.

On Docker v1.6, the concept of [**logging drivers**](https://docs.docker.com/engine/admin/logging/overview/) was introduced. The Docker engine is aware of the output interfaces that manage the application messages.

![Fluentd Docker](https://www.fluentd.org/assets/img/recipes/fluentd_docker.png)

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

<match *>
  @type stdout
</match>
```

### Step 2: Start Fluentd

Now, start an instance of Fluentd like this:

```text
$ docker run -it -p 24224:24224 -v $(pwd)/demo.conf:/fluentd/etc/demo.conf -e FLUENTD_CONF=demo.conf fluent/fluentd:latest
```

On successful start, you should see the Fluentd startup logs:

```text
2019-08-21 00:51:02 +0000 [info]: parsing config file is succeeded path="/fluentd/etc/demo.conf"
2019-08-21 00:51:02 +0000 [info]: using configuration file: <ROOT>
  <source>
    @type forward
    port 24224
    bind "0.0.0.0"
  </source>
  <match *>
    @type stdout
  </match>
</ROOT>
2019-08-21 00:51:02 +0000 [info]: starting fluentd-1.3.2 pid=6 ruby="2.5.2"
2019-08-21 00:51:02 +0000 [info]: spawn command to main:  cmdline=["/usr/bin/ruby", "-Eascii-8bit:ascii-8bit", "/usr/bin/fluentd", "-c", "/fluentd/etc/demo.conf", "-p", "/fluentd/plugins", "--under-supervisor"]
2019-08-21 00:51:02 +0000 [info]: gem 'fluentd' version '1.3.2'
2019-08-21 00:51:02 +0000 [info]: adding match pattern="*" type="stdout"
2019-08-21 00:51:02 +0000 [info]: adding source type="forward"
2019-08-21 00:51:02 +0000 [info]: #0 starting fluentd worker pid=16 ppid=6 worker=0
2019-08-21 00:51:02 +0000 [info]: #0 listening port port=24224 bind="0.0.0.0"
2019-08-21 00:51:02 +0000 [info]: #0 fluentd worker is now running worker=0
```

### Step 3: Start Docker Container with Fluentd Driver

By default, the Fluentd logging driver will try to find a local Fluentd instance \(Step \# 2\) listening for connections on the TCP port `24224`. Note that the container will not start if it cannot connect to the Fluentd instance.

![Integration of Docker with Fluentd](https://www.fluentd.org/assets/img/recipes/fluentd_docker_integrated.png)

The following command will run a base Ubuntu container and print some messages to the standard output:

```text
$ docker run --log-driver=fluentd ubuntu echo "Hello Fluentd!"
Hello Fluentd!
```

Note that we have launched the container specifying the Fluentd logging driver i.e. `--log-driver=fluentd`.

### Step 4: Confirm

Now, you should see the incoming messages from the container in Fluentd logs:

```text
2019-08-21 00:52:28.000000000 +0000 ece4524df531: {"source":"stdout","log":"Hello Fluentd!","container_id":"ece4524df531ed6ded4253c145a53bead9b049241aa12c5a59ab83e3a14a96b4","container_name":"/inspiring_montalcini"}
```

At this point, you will notice that the incoming messages are in JSON format, have a timestamp, are tagged with the `container_id` and contain general information from the source container along with the message.

### Additional Step 1: Parse Log Message

The application log is stored in the `"log"` field in the record. You can parse this log before sending it to the destinations by using [`filter_parser`](../filter/parser.md).

```text
<filter docker.**>
  @type parser
  key_name log
  reserve_data true
  <parse>
    @type json # apache2, nginx, etc.
  </parse>
</filter>
```

Original Event:

```text
2019-07-22 03:36:39.000000000 +0000 6e8a14315069: {"log":"{\"key\":\"value\"}","container_id":"6e8a1431506936b8568a284f2b0dd4853c250ad85ab7a497f05c4d371f6c3ae6","container_name":"/laughing_beaver","source":"stdout"}
```

Filtered Event:

```text
2019-07-22 03:35:59.395952500 +0000 bac5426337a6: {"container_id":"bac5426337a611fc3b7a0b318c3c45981d2acd80f5c5651088bebb8f1f962583","container_name":"/nostalgic_euler","source":"stdout","log":"{\"key\":\"value\"}","key":"value"}
```

### Additional Step 2: Concatenate Multiple Lines Log Messages

The application log is stored in the `log` field of the record. You can concatenate these logs by using [`fluent-plugin-concat`](https://github.com/fluent-plugins-nursery/fluent-plugin-concat) filter before sending it to the destinations.

```text
<filter docker.**>
  @type concat
  key log
  stream_identity_key container_id
  multiline_start_regexp /^-e:2:in `\/'/
  multiline_end_regexp /^-e:4:in/
</filter>
```

Original Events:

```text
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky","source":"stdout","log":"-e:2:in `/'"}
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"source":"stdout","log":"-e:2:in `do_division_by_zero'","container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky"}
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"source":"stdout","log":"-e:4:in `<main>'","container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky"}
```

Filtered Events:

```text
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky","source":"stdout","log":"-e:2:in `/'\n-e:2:in `do_division_by_zero'\n-e:4:in `<main>'"}
```

If the logs are typical stacktraces, consider using [`detect-exceptions`](https://github.com/GoogleCloudPlatform/fluent-plugin-detect-exceptions) plugin instead.

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

