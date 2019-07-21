# Apache Kafka Output Plugin

![](/images/plugins/output/kafka.png)

The `out_kafka2` Output plugin writes records into [Apache Kafka](https://kafka.apache.org/).

>## Installation

`out_kafka2` is included in td-agent3. Fluentd gem users will
eed to install the fluent-plugin-kafka gem using the following command.

``` {.CodeRay}
$ fluent-gem install fluent-plugin-kafka
```

## Example Configuration

``` {.CodeRay}
<match pattern>
  @type kafka2

  # list of seed brokers
  brokers <broker1_host>:<broker1_port>,<broker2_host>:<broker2_port>
  use_event_time true

  # buffer settings
  <buffer topic>
    @type file
    path /var/log/td-agent/buffer/td
    flush_interval 3s
  </buffer>

  # data type settings
  <format>
    @type json
  </format>

  # topic settings
  topic_key topic
  default_topic messages

  # producer settings
  required_acks -1
  compression_codec gzip
</match>
```

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

Please make sure that you have **enough space in the buffer path
directory**. Running out of disk space is a problem frequently reported
by users.

## Parameters

### type (required)

The value must be `kafka2`.

### brokers (required/optional)

The list of all seed brokers, with their host and port information.

The default is `localhost:9092`.

### topic\_key

The field name for target topic. If the field value is `app`,
this plugin write events to `app` topic.

In addition, this field name must be included in buffer chunk keys.

```
topic_key category
<buffer category> # topic_key should be included in buffer chunk key
  # ...
</buffer>
```

The default is `topic.`

### default\_topic

The name of default topic (default: nil).
This value will be used when `topic_key` field is missing

### &lt;format&gt; directive

The format of each message. The available options are `json`, `ltsv`,
and formatter plugins.

Here is `json` example:

```
<format>
  @type json
</format>
```

See [formatter article](/plugins/formatter/README.md) for more detail.

### use_event_time

Set fluentd event time to kafka's CreateTime.

The default is `false`. This means use current time.

### required\_acks

The number of acks required per request (default: -1).

### compression\_codec

The codec the producer uses to compress messages (default: nil). The
available options are `gzip` and `snappy`. When you use `snappy`, you
need to install `snappy` gem by `td-agent-gem` command.

#### @log\_level option

The `@log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.

## Common Output / Buffer parameters

For common output / buffer parameters, please check the following
articles.

-   [Output Plugin Overview](/plugins/output/README.md)
-   [Buffer Section Configuration](/configuration/buffer-section.md)


## Further Reading

This page doesn't describe all the possible configurations. If you want
to know about other configurations, please check the link below.

-   [fluent-plugin-kafka repository](https://github.com/fluent/fluent-plugin-kafka)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
