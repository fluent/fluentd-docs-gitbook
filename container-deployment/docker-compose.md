# Docker Compose

This article explains how to collect [Docker](https://www.docker.com/) logs and propagate them to EFK \(Elasticsearch + Fluentd + Kibana\) stack. The example uses [Docker Compose](https://docs.docker.com/compose/) for setting up multiple containers.

![Kibana](../.gitbook/assets/7.10_kibana-homepage.png)

[Elasticsearch](https://www.elastic.co/products/elasticsearch) had been an open-source search engine known for its ease of use. [Kibana](https://www.elastic.co/products/kibana) had been an open-source Web UI that makes Elasticsearch user-friendly for marketers, engineers and data scientists alike.

NOTE: Since v7.11, These products are distributed under non open-source license (Dual licensed under Server Side Public License and Elastic License)


By combining these three tools EFK \(Elasticsearch + Fluentd + Kibana\) we get a scalable, flexible, easy to use log collection and analytics pipeline. In this article, we will set up four \(4\) containers, each includes:

* [Apache HTTP Server](https://hub.docker.com/_/httpd/)
* [Fluentd](https://hub.docker.com/r/fluent/fluentd/)
* [Elasticsearch](https://hub.docker.com/_/elasticsearch/)
* [Kibana](https://hub.docker.com/_/kibana/)

All the logs of `httpd` will be ingested into Elasticsearch + Kibana, via Fluentd.

## Prerequisites: Docker

Please download and install Docker / Docker Compose. Well, that's it :\)

* [Docker Installation](https://docs.docker.com/engine/installation/)

## Step 0: Create `docker-compose.yml`

Create `docker-compose.yml` for [Docker Compose](https://docs.docker.com/compose/overview/). Docker Compose is a tool for defining and running multi-container Docker applications.

With the YAML file below, you can create and start all the services \(in this case, Apache, Fluentd, Elasticsearch, Kibana\) by one command:

```text
services:
  web:
    image: httpd
    ports:
      - "8080:80"
    depends_on:
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
    depends_on:
      # Launch fluentd after that elasticsearch is ready to connect
      elasticsearch:
        condition: service_healthy
    ports:
      - "24224:24224"
      - "24224:24224/udp"

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.17.1
    container_name: elasticsearch
    hostname: elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false # Disable security for testing
    healthcheck:
      # Check whether service is ready
      test: ["CMD", "curl", "-f", "http://localhost:9200/_cluster/health"]
      interval: 10s
      retries: 5
      timeout: 5s
    ports:
      - 9200:9200

  kibana:
    image: docker.elastic.co/kibana/kibana:8.17.1
    depends_on:
      # Launch fluentd after that elasticsearch is ready to connect
      elasticsearch:
        condition: service_healthy
    ports:
      - "5601:5601"
```

The `logging` section \(check [Docker Compose documentation](https://docs.docker.com/reference/compose-file/services/#logging)\) of `web` container specifies [Docker Fluentd Logging Driver](https://docs.docker.com/engine/admin/logging/fluentd/) as a default container logging driver. All the logs from the `web` container will automatically be forwarded to `host:port` specified by `fluentd-address`.

## Step 1: Create Fluentd Image with your Config + Plugin

Create `fluentd/Dockerfile` with the following content using the Fluentd [official Docker image](https://hub.docker.com/r/fluent/fluentd/); and then, install the Elasticsearch plugin:

```text
# fluentd/Dockerfile

FROM fluent/fluentd:edge-debian
USER root

# To connect to docker.elastic.co/elasticsearch/elasticsearch:8.x, it requires elasticsearch v8 gem
# Ref. https://github.com/elastic/elasticsearch-ruby/blob/main/README.md#compatibility
RUN ["gem", "install", "elasticsearch", "--no-document", "--version", "8.19.0"]

RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "5.4.3"]
USER fluent
```

Then, create the Fluentd configuration file `fluentd/conf/fluent.conf`. The [`forward`](../input/forward.md) input plugin receives logs from the Docker logging driver and `elasticsearch` output plugin forwards these logs to Elasticsearch.

```text
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

NOTE: The detail of used parameters for `@type elasticsearch`, see [Elasticsearch parameters section](../output/elasticsearch.md#parameters) and [fluent-plugin-elasticsearch](https://github.com/uken/fluent-plugin-elasticsearch) furthermore.

## Step 2: Start the Containers

Let's start the containers:

```text
$ docker compose up --detach
```

Use `docker ps` command to verify that the four \(4\) containers are up and running:

```text
$ docker ps
CONTAINER ID   IMAGE                                                  COMMAND                   CREATED          STATUS                    PORTS                                                                                                    NAMES
7a489886d856   httpd                                                  "httpd-foreground"        36 seconds ago   Up 14 seconds             0.0.0.0:8080->80/tcp, [::]:8080->80/tcp                                                                  fluentd-elastic-kibana-web-1
36ded62da733   fluentd-elastic-kibana-fluentd                         "tini -- /bin/entryp…"    36 seconds ago   Up 15 seconds             5140/tcp, 0.0.0.0:24224->24224/tcp, 0.0.0.0:24224->24224/udp, :::24224->24224/tcp, :::24224->24224/udp   fluentd-elastic-kibana-fluentd-1
254b7692966f   docker.elastic.co/kibana/kibana:8.17.1                 "/bin/tini -- /usr/l…"    36 seconds ago   Up 15 seconds             0.0.0.0:5601->5601/tcp, :::5601->5601/tcp                                                                fluentd-elastic-kibana-kibana-1
187d3e5c2e08   docker.elastic.co/elasticsearch/elasticsearch:8.17.1   "/bin/tini -- /usr/l…"    37 seconds ago   Up 35 seconds (healthy)   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp, 9300/tcp                                                      elasticsearch
```

## Step 3: Generate `httpd` Access Logs

Use `curl` command to generate some access logs like this:

```text
$ curl http://localhost:8080/
<html><body><h1>It works!</h1></body></html>
```

## Step 4: Confirm Logs from Kibana

Browse to [`http://localhost:5601/app/discover#/`](http://localhost:5601/app/discover#/) and create data view.
![Kibana Discover](../.gitbook/assets/8.17_efk-kibana-discover-start-page.png)

Specify `fluentd-*` to `Index pattern` and click `Save data view to Kibana`.
![Kibana Discover](../.gitbook/assets/8.17_efk-kibana-create-data-view.png)

Then, go to `Discover` tab to check the logs. As you can see, logs are properly collected into the Elasticsearch + Kibana, via Fluentd.

![Kibana Discover](../.gitbook/assets/8.17_efk-kibana-discover.png)

## Learn More

* [Fluentd: Architecture](https://www.fluentd.org/architecture)
* [Fluentd: Get Started](../quickstart/)
* [Downloading Fluentd](http://www.fluentd.org/download)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

