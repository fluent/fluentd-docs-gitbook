# kafka

![](../.gitbook/assets/kafka.png)

The `out_kafka2` Output plugin writes records into [Apache Kafka](https://kafka.apache.org/).

## Installation

`out_kafka2` is included in `td-agent`. Fluentd gem users will need to install the `fluent-plugin-kafka` gem using the following command:

```text
$ fluent-gem install fluent-plugin-kafka
```

## Example Configuration

```text
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

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

Please make sure that you have **enough space in the buffer path directory**. Running out of disk space is a problem frequently reported by users.

## Parameters

### `@type` \(required\)

The value must be `kafka2`.

### `brokers` \(required/optional\)

The list of all seed brokers, with their host and port information.

Default: `localhost:9092`

### `topic_key`

The field name for the target topic. If the field value is `app`, this plugin writes events to the `app` topic.

This field name must be included in the buffer chunk keys:

```text
topic_key category
<buffer category> # topic_key should be included in buffer chunk key
  # ...
</buffer>
```

Default: `topic`

### `default_topic`

The name of the default topic. \(default: `nil`\)

This value will be used when the `topic_key` field is missing.

### `<format>` Directive

The format of each message. The available options are `json`, `ltsv`, and formatter plugins.

Here is the `json` example:

```text
<format>
  @type json
</format>
```

See [`formatter`](../formatter/) article for more detail.

### `use_event_time`

Set fluentd event time to Kafka's `CreateTime`.

Default: `false` \(It means the current time.\)

### `required_acks`

The number of acks required per request.

Default: `-1`

### `compression_codec`

The codec the producer uses to compress messages \(default: `nil`\).

Default: `nil`

Available options: `gzip`, `snappy`

For `snappy`, you need to install `snappy` gem by `td-agent-gem` command.

#### `@log_level`

The `@log_level` option allows the user to set different levels of logging for each plugin.

Supported log levels: `fatal`, `error`, `warn`, `info`, `debug`, `trace`.

Please see the [logging](../deployment/logging.md) article for further details.

## Common Output / Buffer parameters

For common output / buffer parameters, please check the following articles:

* [Output Plugin Overview](./)
* [Buffer Section Configuration](../configuration/buffer-section.md)

## Further Reading

This page does not describe all the possible configurations. If you want to know about other configurations, please check the link below:

* [`fluent-plugin-kafka`](https://github.com/fluent/fluent-plugin-kafka)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

