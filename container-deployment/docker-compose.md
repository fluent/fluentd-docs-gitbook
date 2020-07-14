# Docker Logging via EFK (Elasticsearch + Fluentd + Kibana) Stack with Docker Compose

This article explains how to collect [Docker](https://www.docker.com/) logs and
propagate them to EFK (Elasticsearch + Fluentd + Kibana) stack. The example uses
[Docker Compose](https://docs.docker.com/compose/) for setting up multiple
containers.

![Kibana](/images/7.2_kibana-homepage.png)

[Elasticsearch](https://www.elastic.co/products/elasticsearch) is an open-source
search engine known for its ease of use.
[Kibana](https://www.elastic.co/products/kibana) is an open-source Web UI that
makes Elasticsearch user-friendly for marketers, engineers and data scientists
alike.

By combining these three tools EFK (Elasticsearch + Fluentd + Kibana) we get a
scalable, flexible, easy to use log collection and analytics pipeline. In this
article, we will set up four (4) containers, each includes:

-   [Apache HTTP Server](https://hub.docker.com/_/httpd/)
-   [Fluentd](https://hub.docker.com/r/fluent/fluentd/)
-   [Elasticsearch](https://hub.docker.com/_/elasticsearch/)
-   [Kibana](https://hub.docker.com/_/kibana/)

All the logs of `httpd` will be ingested into Elasticsearch + Kibana, via
Fluentd.


## Prerequisites: Docker

Please download and install Docker / Docker Compose. Well, that's it :)

-   [Docker Installation](https://docs.docker.com/engine/installation/)


## Step 0: Create `docker-compose.yml`

Create `docker-compose.yml` for [Docker
Compose](https://docs.docker.com/compose/overview/). Docker Compose is a tool
for defining and running multi-container Docker applications.

With the YAML file below, you can create and start all the services (in this
case, Apache, Fluentd, Elasticsearch, Kibana) by one command:

``` {.CodeRay}
version: '3'
services:
  web:
    image: httpd
    ports:
      - "80:80"
    links:
      - fluentd
    logging:
      driver: "fluentd"
      options:
        fluentd-address: localhost:24224
        tag: httpd.access

  fluentd:
    build: ./fluentd
    volumes:
      - ./fluentd/conf:/fluentd/etc
    links:
      - "elasticsearch"
    ports:
      - "24224:24224"
      - "24224:24224/udp"

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.2.0
    environment:
      - "discovery.type=single-node"
    expose:
      - "9200"
    ports:
      - "9200:9200"

  kibana:
    image: kibana:7.2.0
    links:
      - "elasticsearch"
    ports:
      - "5601:5601"
```

The `logging` section (check [Docker Compose
documentation](https://docs.docker.com/compose/compose-file/#/logging)) of `web`
container specifies [Docker Fluentd Logging
Driver](https://docs.docker.com/engine/admin/logging/fluentd/) as a default
container logging driver. All the logs from `web` container will automatically
be forwarded to `host:port` specified by `fluentd-address`.


## Step 1: Create Fluentd Image with your Config + Plugin

Create `fluentd/Dockerfile` with the following content using the Fluentd
[official Docker image](https://hub.docker.com/r/fluent/fluentd/); and then,
install the Elasticsearch plugin:

``` {.CodeRay}
# fluentd/Dockerfile

FROM fluent/fluentd:v1.6-debian-1
USER root
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "3.5.2"]
USER fluent
```

Then, create the Fluentd configuration file `fluentd/conf/fluent.conf`. The
[`forward`](/plugins/input/forward.md) input plugin receives logs from the
Docker logging driver and `elasticsearch` output plugin forwards these logs to
Elasticsearch.

``` {.CodeRay}
# fluentd/conf/fluent.conf

<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>

<match *.**>
  @type copy

  <store>
    @type elasticsearch
    host elasticsearch
    port 9200
    logstash_format true
    logstash_prefix fluentd
    logstash_dateformat %Y%m%d
    include_tag_key true
    type_name access_log
    tag_key @log_name
    flush_interval 1s
  </store>

  <store>
    @type stdout
  </store>
</match>
```


## Step 2: Start the Containers

Let's start the containers:

``` {.CodeRay}
$ docker-compose up
```

Use `docker ps` command to verify that the four (4) containers are up and
running:

``` {.CodeRay}
$ docker ps
CONTAINER ID        IMAGE                                                 COMMAND                  CREATED             STATUS              PORTS                              NAMES
558fd18fa2d4        httpd                                                 "httpd-foreground"       17 seconds ago      Up 16 seconds       0.0.0.0:80->80/tcp                 docker_web_1
bc5bcaedb282        kibana:7.2.0                                          "/usr/local/bin/kiba…"   18 seconds ago      Up 17 seconds       0.0.0.0:5601->5601/tcp             docker_kibana_1
9fe2d02cff41        docker.elastic.co/elasticsearch/elasticsearch:7.2.0   "/usr/local/bin/dock…"   20 seconds ago      Up 18 seconds       0.0.0.0:9200->9200/tcp, 9300/tcp   docker_elasticsearch_1
```


## Step 3: Generate `httpd` Access Logs

Use `curl` command to generate some access logs like this:

``` {.CodeRay}
$ curl http://localhost:80/[1-10]
<html><body><h1>It works!</h1></body></html>
<html><body><h1>It works!</h1></body></html>
<html><body><h1>It works!</h1></body></html>
<html><body><h1>It works!</h1></body></html>
<html><body><h1>It works!</h1></body></html>
<html><body><h1>It works!</h1></body></html>
<html><body><h1>It works!</h1></body></html>
<html><body><h1>It works!</h1></body></html>
<html><body><h1>It works!</h1></body></html>
<html><body><h1>It works!</h1></body></html>
```


## Step 4: Confirm Logs from Kibana

Browse to `http://localhost:5601/` and set up the index name pattern for Kibana.
Specify `fluentd-*` to `Index name or pattern` and click `Create`.

![Kibana Index](/images/7.2_efk-kibana-index.png) ![Kibana
Timestamp](/images/7.2_efk-kibana-timestamp.png)

Then, go to `Discover` tab to check the logs. As you can see, logs are properly
collected into Elasticsearch + Kibana, via Fluentd.

![Kibana Discover](/images/7.2_efk-kibana-discover.png)

## Code

The code is available at https://github.com/digikin/fluentd-elastic-kibana.

## Learn More

-   [Fluentd: Architecture](https://www.fluentd.org/architecture)
-   [Fluentd: Get Started](/overview/quickstart.md)
-   [Downloading Fluentd](http://www.fluentd.org/download)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
