Apache Kafka Output Plugin
==========================

The `out_kafka` Output plugin writes records into [Apache
Kafka](https://kafka.apache.org/).

This document doesn\'t describe all parameters. If you want to know full
features, check the Further Reading section.

[]{#installation}

::: {#table-of-contents .section}
### Table of Contents

[Installation](#installation)

[Example Configuration](#example-configuration)

[Parameters](#parameters)

-   [\@type (required)](#@type-(required))
-   [brokers (required/optional)](#brokers-(required/optional))
-   [default\_topic](#default_topic)
-   [default\_partition\_key](#default_partition_key)
-   [default\_message\_key](#default_message_key)
-   [output\_data\_type](#output_data_type)
-   [max\_send\_retries](#max_send_retries)
-   [required\_acks](#required_acks)
-   [ack\_timeout](#ack_timeout)
-   [compression\_codec](#compression_codec)

[Buffered Output Parameters](#buffered-output-parameters)

-   [buffer\_type](#buffer_type)
-   [buffer\_queue\_limit,
    buffer\_chunk\_limit](#buffer_queue_limit,-buffer_chunk_limit)
-   [flush\_interval](#flush_interval)
-   [flush\_at\_shutdown](#flush_at_shutdown)
-   [retry\_wait, max\_retry\_wait](#retry_wait,-max_retry_wait)
-   [retry\_limit,
    disable\_retry\_limit](#retry_limit,-disable_retry_limit)
-   [num\_threads](#num_threads)
-   [slow\_flush\_log\_threshold](#slow_flush_log_threshold)

[Further Reading](#further-reading)
:::

Installation
------------

`out_kafka` is included in td-agent2 after v2.3.3. Fluentd gem users
will need to install the fluent-plugin-kafka gem using the following
command.

``` {.CodeRay}
$ fluent-gem install fluent-plugin-kafka
```

[]{#example-configuration}

Example Configuration
---------------------

``` {.CodeRay}
<match pattern>
  @type kafka_buffered

  # list of seed brokers
  brokers <broker1_host>:<broker1_port>,<broker2_host>:<broker2_port>

  # buffer settings
  buffer_type file
  buffer_path /var/log/td-agent/buffer/td
  flush_interval 3s

  # topic settings
  default_topic messages

  # data type settings
  output_data_type json
  compression_codec gzip

  # producer settings
  max_send_retries 1
  required_acks -1
</match>
```

Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

Please make sure that you have **enough space in the buffer\_path
directory**. Running out of disk space is a problem frequently reported
by users.

[]{#parameters}

Parameters
----------

[]{#@type-(required)}

### \@type (required)

The value must be `kafka_buffered`.

[]{#brokers-(required/optional)}

### brokers (required/optional)

The list of all seed brokers, with their host and port information.

[]{#default_topic}

### default\_topic

The name of default topic (default: nil).

[]{#default_partition_key}

### default\_partition\_key

The name of default partition key (default: nil).

[]{#default_message_key}

### default\_message\_key

The name of default message key (default: nil).

[]{#output_data_type}

### output\_data\_type

The format of each message. The available options are `json`, `ltsv`,
`msgpack`, `attr:<record name>`, `<formatter name>`. `msgpack` is
recommended since it's more compact and faster.

[]{#max_send_retries}

### max\_send\_retries

The number of times to retry sending of messages to a leader (default:
1).

[]{#required_acks}

### required\_acks

The number of acks required per request (default: -1).

[]{#ack_timeout}

### ack\_timeout

How long the producer waits for acks. The unit is seconds (default: nil
=\> Use default of ruby-kafka library)

[]{#compression_codec}

### compression\_codec

The codec the producer uses to compress messages (default: nil). The
available options are `gzip` and `snappy`. When you use `snappy`, you
need to install `snappy` gem by `td-agent-gem` command.

[]{#buffered-output-parameters}

Buffered Output Parameters
--------------------------

For advanced usage, you can tune Fluentd's internal buffering mechanism
with these parameters.

[]{#buffer_type}

### buffer\_type

The buffer type is `memory` by default ([buf\_memory](buf_memory)) for
the ease of testing, however `file` ([buf\_file](buf_file)) buffer type
is always recommended for the production deployments. If you use `file`
buffer type, `buffer_path` parameter is required.

[]{#buffer_queue_limit,-buffer_chunk_limit}

### buffer\_queue\_limit, buffer\_chunk\_limit

The length of the chunk queue and the size of each chunk, respectively.
Please see the [Buffer Plugin Overview](buffer-plugin-overview) article
for the basic buffer structure. The default values are 64 and 8m,
respectively. The suffixes "k" (KB), "m" (MB), and "g" (GB) can be used
for buffer\_chunk\_limit.

[]{#flush_interval}

### flush\_interval

The interval between data flushes. The default is 60s. The suffixes "s"
(seconds), "m" (minutes), and "h" (hours) can be used.

[]{#flush_at_shutdown}

### flush\_at\_shutdown

If set to true, Fluentd waits for the buffer to flush at shutdown. By
default, it is set to true for Memory Buffer and false for File Buffer.

[]{#retry_wait,-max_retry_wait}

### retry\_wait, max\_retry\_wait

The initial and maximum intervals between write retries. The default
values are 1.0 seconds and unset (no limit). The interval doubles (with
+/-12.5% randomness) every retry until `max_retry_wait` is reached.

Since td-agent will retry 17 times before giving up by default (see the
`retry_limit` parameter for details), the sleep interval can be up to
approximately 131072 seconds (roughly 36 hours) in the default
configurations.

[]{#retry_limit,-disable_retry_limit}

### retry\_limit, disable\_retry\_limit

The limit on the number of retries before buffered data is discarded,
and an option to disable that limit (if true, the value of `retry_limit`
is ignored and there is no limit). The default values are 17 and false
(not disabled). If the limit is reached, buffered data is discarded and
the retry interval is reset to its initial value (`retry_wait`).

[]{#num_threads}

### num\_threads

The number of threads to flush the buffer. This option can be used to
parallelize writes into the output(s) designated by the output plugin.
Increasing the number of threads improves the flush throughput to hide
write / network latency. The default is 1.

[]{#slow_flush_log_threshold}

### slow\_flush\_log\_threshold

The threshold for checking chunk flush performance. The default value is
`20.0` seconds. Note that parameter type is `float`, not `time`.

If chunk flush takes longer time than this threshold, fluentd logs
warning message like below:

``` {.CodeRay}
2016-12-19 12:00:00 +0000 [warn]: buffer flush took longer time than slow_flush_log_threshold: elapsed_time = 15.0031226690043695 slow_flush_log_threshold=10.0 plugin_id="foo"
```

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.

[]{#further-reading}

Further Reading
---------------

This page doesn't describe all the possible configurations. If you want
to know about other configurations, please check the link below.

-   [fluent-plugin-kafka
    repository](https://github.com/fluent/fluent-plugin-kafka)

::: {style="text-align:right"}
Last updated: 2017-01-28 07:34:32 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| ***v0.12* (td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
