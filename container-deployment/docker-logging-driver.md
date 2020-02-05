# Docker Logging Driver and Fluentd

The following article describes how to implement an unified logging
system for your [Docker](http://www.docker.com) containers. Any
production application requires to register certain events or problems
during runtime.

The old fashioned way is to write these messages to a log file, but that
inherits certain problems specifically when we try to perform some
analysis over the registers, or in the other side, if the application
has multiple instances running, the scenario becomes even more
complex.

On Docker v1.6, the concept of **[logging drivers](https://docs.docker.com/engine/admin/logging/overview/)** was
introduced, basically the Docker engine is aware about output interfaces
that manage the application messages.

![](http://www.fluentd.org/assets/img/recipes/fluentd_docker.png)

For Docker v1.8, we have implemented a native **[Fluentd Docker logging driver](https://docs.docker.com/engine/admin/logging/fluentd/)**, now
you are able to have an unified and structured logging system with the
simplicity and high performance of [Fluentd](http://fluentd.org).

Currently, Fluentd logging driver doesn't support sub-second precision.


## Getting Started

Using the Docker logging mechanism with
[Fluentd](http://www.fluentd.org) is a straightforward step, to get
started make sure you have the following prerequisites:

-   A basic understanding of [Fluentd](http://www.fluentd.org)
-   A basic understanding of Docker
-   A basic understanding of [Docker logging drivers](https://docs.docker.com/engine/admin/logging/overview/)
-   Docker v1.8+

This article launches Fluentd as standard process, not a container. Please refer
to [Docker Logging via EFK (Elasticsearch + Fluentd + Kibana) Stack with Docker Compose](/articles/docker-logging-efk-compose.md)
for a fully containerized environment tutorial.

### Step 1: Create the Fluentd configuration file

The first step is to prepare Fluentd to listen for the messsages that
it will receive from the Docker containers. For demonstration purposes, we
will instruct Fluentd to write the messages to the standard output; In a
later step you will find how to accomplish the same aggregating the logs
into a MongoDB instance.

Create a simple file called demo.conf which contains the following
entries:

``` {.CodeRay}
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

With this simple command start an instance of Fluentd:

``` {.CodeRay}
$ docker run -it -p 24224:24224 -v $(pwd)/demo.conf:/fluentd/etc/demo.conf -e FLUENTD_CONF=demo.conf fluent/fluentd:latest
```

If the service started you should see an output like this:

``` {.CodeRay}
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

### Step 3: Start Docker container with Fluentd driver

By default, the Fluentd logging driver will try to find a local Fluentd
instance (step \#2) listening for connections on the TCP port 24224.
Note that the container will not start if it cannot connect to the
Fluentd instance.

![](https://www.fluentd.org/assets/img/recipes/fluentd_docker_integrated.png)

The following command will run a base Ubuntu container and print some
messages to the standard output. Note that we have launched the
container specifying the Fluentd logging driver:

``` {.CodeRay}
$ docker run --log-driver=fluentd ubuntu echo "Hello Fluentd!"
Hello Fluentd!
```

### Step 4: Confirm

Now, in the Fluentd output, you will see the incoming message from the
container, i.e:

``` {.CodeRay}
2019-08-21 00:52:28.000000000 +0000 ece4524df531: {"source":"stdout","log":"Hello Fluentd!","container_id":"ece4524df531ed6ded4253c145a53bead9b049241aa12c5a59ab83e3a14a96b4","container_name":"/inspiring_montalcini"}
```

At this point you will notice something interesting, the incoming
messages have a timestamp, are tagged with the container\_id and
contain general information from the source container along with the
message, everything in JSON format.

### Additional Step 1: Parse log message

Application log is stored in the `"log"` field in the record. You can
parse this log by using
[filter\_parser](/plugins/filter/parser.md) filter
before sending it to destinations.

``` {.CodeRay}
<filter docker.**>
  @type parser
  format json # apache2, nginx, etc...
  key_name log
  reserve_data true
</filter>
```

Original event:

``` {.CodeRay}
2019-07-22 03:36:39.000000000 +0000 6e8a14315069: {"log":"{\"key\":\"value\"}","container_id":"6e8a1431506936b8568a284f2b0dd4853c250ad85ab7a497f05c4d371f6c3ae6","container_name":"/laughing_beaver","source":"stdout"}
```

Filtered event:

``` {.CodeRay}
2019-07-22 03:35:59.395952500 +0000 bac5426337a6: {"container_id":"bac5426337a611fc3b7a0b318c3c45981d2acd80f5c5651088bebb8f1f962583","container_name":"/nostalgic_euler","source":"stdout","log":"{\"key\":\"value\"}","key":"value"}
```

### Additional Step 2: Concatenate multiple lines log messages

Application log is stored in the `"log"` field in the records. You can
concatenate these logs by using
[fluent-plugin-concat](https://github.com/fluent-plugins-nursery/fluent-plugin-concat)
filter before sending it to destinations.

``` {.CodeRay}
<filter docker.**>
  @type concat
  key log
  stream_identity_key container_id
  multiline_start_regexp /^-e:2:in `\/'/
  multiline_end_regexp /^-e:4:in/
</filter>
```

Original events:

``` {.CodeRay}
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky","source":"stdout","log":"-e:2:in `/'"}
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"source":"stdout","log":"-e:2:in `do_division_by_zero'","container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky"}
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"source":"stdout","log":"-e:4:in `<main>'","container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky"}
```

Filtered events:

``` {.CodeRay}
2016-04-13 14:45:55 +0900 docker.28cf38e21204: {"container_id":"28cf38e212042225f5f80a56fac08f34c8f0b235e738900c4e0abcf39253a702","container_name":"/romantic_dubinsky","source":"stdout","log":"-e:2:in `/'\n-e:2:in `do_division_by_zero'\n-e:4:in `<main>'"}
```

If the logs are typical stacktraces, consider using [detect-exceptions plugin](https://github.com/GoogleCloudPlatform/fluent-plugin-detect-exceptions)
instead.

## Driver options

The [Fluentd logging driver](https://docs.docker.com/engine/admin/logging/fluentd/) supports
more options through the *--log-opt* Docker command line argument:

-   fluentd-address
-   tag

#### fluentd-address

Specify an optional address for Fluentd. It allows setting the host and
TCP port, e.g:

``` {.CodeRay}
$ docker run --log-driver=fluentd --log-opt fluentd-address=192.168.2.4:24225 ubuntu echo "..."
```

#### tag

[Log tags](https://docs.docker.com/engine/admin/logging/log_tags/) are a
major requirement for Fluentd, as they allow for identifying the source of
incoming data and take routing decisions. By default, the Fluentd logging
driver uses the container\_id as a tag (64 character ID). You can change
it value with the *tag* option as follows:

``` {.CodeRay}
$ docker run --log-driver=fluentd --log-opt tag=docker.my_new_tag ubuntu echo "..."
```

Additionally, this option allows specifying some internal variables:
\{\{.ID\}\}, \{\{.FullID\}\} or \{\{.Name\}\}. e.g:

``` {.CodeRay}
$ docker run --log-driver=fluentd --log-opt tag=docker.{{.ID}} ubuntu echo "..."
```

## Development Environments

In a more real-world use case, you would want to use something other
than the Fluentd standard output to store Docker container messages,
such as Elasticsearch, MongoDB, HDFS, S3, Google Cloud Storage and so
on.

This document describes how to set up a multi-container logging
environment via EFK (Elasticsearch, Fluentd, Kibana) with Docker
Compose.

-   [Docker Logging via EFK (Elasticsearch + Fluentd + Kibana) Stack with Docker Compose](/container-deployment/docker-compose.md)

## Production Environments

In a production environment, you must use one of the container
orchestration tools. Currently, Kubernetes has better integration with
Fluentd, and we're working on making better integrations with other
tools as well.

-   [Kubernetes's Logging Overview](https://kubernetes.io/docs/user-guide/logging/overview/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
