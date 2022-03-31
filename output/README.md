# Output Plugins

Fluentd has nine \(9\) types of plugins:

* [Input](../input/)
* [Parser](../parser/)
* [Filter](../filter/)
* [Output](./)
* [Formatter](../formatter/)
* [Storage](../storage/)
* [Service Discovery](../service_discovery/)
* [Buffer](../buffer/)
* [Metrics](../metrics/)

This article gives an overview of the Output Plugin.

## Overview

Fluentd v1.0 output plugins have three \(3\) buffering and flushing modes:

* **Non-Buffered** mode does not buffer data and write out results

  immediately.

* **Synchronous Buffered** mode has "staged" buffer chunks \(a chunk is a

  collection of events\) and a queue of chunks, and its behavior can be

  controlled by `<buffer>` section \(See the diagram below\).

* **Asynchronous Buffered** mode also has "stage" and "queue", but

  the output plugin will not commit writing chunks in methods

  synchronously, but commit them later.

![Fluentd v1.0 Plugin API Overview](../.gitbook/assets/fluentd-v0.14-plugin-api-overview.png)

Output plugins can support all the modes, but may support just one of these modes. Fluentd chooses appropriate mode automatically if there are no `<buffer>` sections in the configuration. If the users specify `<buffer>` section for the output plugins that do not support buffering, Fluentd will raise configuration errors.

Output plugins in v1 can control keys of buffer chunking by configurations, dynamically. Users can configure buffer chunk keys as time \(any unit specified by user\), tag and any key name of records. Output plugin will split events into chunks: events in a chunk have the same values for chunk keys. The output plugin's buffer behavior \(if any\) is defined by a separate [Buffer plugin](../buffer/). Different buffer plugins can be chosen for each output plugin.

## List of Output Plugins

* [`out_copy`](copy.md)
* [`out_null`](null.md)
* [`out_roundrobin`](roundrobin.md)
* [`out_stdout`](stdout.md)
* [`out_exec_filter`](exec_filter.md)
* [`out_forward`](forward.md)
* [`out_mongo`](mongo.md) / [`out_mongo_replset`](mongo_replset.md)
* [`out_exec`](exec.md)
* [`out_file`](file.md)
* [`out_s3`](s3.md)
* [`out_webhdfs`](webhdfs.md)

## Other Plugins

See this list of available plugins to find out more about other Output plugins:

* [other plugins](http://fluentd.org/plugin/)

## Difference between v1.0 and v0.12

Fluentd v0.12 uses only `<match>` section for both the configuration parameters of output and buffer plugins. Fluentd v1.0 uses `<buffer>` subsection to write parameters for buffering, flushing and retrying. `<match>` sections are used only for the output plugin itself.

Example of v1.0 output plugin configuration:

```text
<match myservice_name>
  @type file
  path /my/data/access.${tag}.%Y-%m-%d.%H%M.log
  <buffer tag,time>
    @type file
    path /my/buffer/myservice
    timekey 60m
    timekey_wait 1m
  </buffer>
</match>
```

For Fluentd v0.12, configuration parameters for buffer plugins are written in the same section:

```text
<match myservice_name>
  @type file
  path /my/data/access.myservice_name.*.log
  buffer_type file
  buffer_path /my/buffer/myservice/access.myservice_name.*.log
  time_slice_format %Y-%m-%d.%H%M
  time_slice_wait 1m
</match>
```

See buffer section in [Compat Parameters Plugin Helper API](../plugin-helper-overview/api-plugin-helper-compat_parameters.md) for parameter name changes between v1 and v0.12.

## Buffering/Retrying Parameters

See [Buffer Section Configurations](../configuration/buffer-section.md).

### Control Flushing

See [Buffer Plugin Overview](../buffer/) for the behavior of the buffer.

#### `flush_mode`

Default: `default`

Supported types: `default`, `lazy`, `interval`, `immediate`

* `interval` flushes per `flush_interval`
* `immediate` flushes just after event arrives

#### `flush_interval`

The interval between buffer chunk flushes.

Default: `60`

#### `flush_thread_count`

The number of threads to flush the buffer.

Default: `1`

#### `flush_thread_interval`

Seconds to sleep between checks for buffer flushes in flush threads.

Default: `1.0`

#### `flush_thread_burst_interval`

Seconds to sleep between flushes when many buffer chunks are queued.

Default: `1.0`

#### `delayed_commit_timeout`

Seconds of timeout for buffer chunks to be committed by plugins later.

Default: `60`

#### `slow_flush_log_threshold`

The threshold for chunk flush performance check.

Default: `20.0` \(seconds\)

Note that the parameter type is `float`, not `time`.

If chunk flush takes longer time than this threshold, fluentd logs warning message like this:

```text
2016-12-19 12:00:00 +0000 [warn]: buffer flush took longer time than slow_flush_log_threshold: elapsed_time=15.0031226690043695 slow_flush_log_threshold=10.0 plugin_id="foo"
```

#### `overflow_action`

Controls the buffer behavior when the queue becomes full.

Supported modes:

* `throw_exception` \(default\)

  This mode throws the`BufferOverflowError` exception to the input plugin. How `BufferOverflowError` is handled depends on the input plugins, e.g. tail input stops reading new lines, forward input returns an error to forward output. This action is suitable for streaming.

* `block`

  This mode stops input plugin thread until buffer full issue is resolved. This action is good for batch-like use-cases. This is mainly for `in_tail` plugin. Other input plugins, e.g. socket-based plugin, don't assume this action.

  We do not recommend using `block` action to avoid `BufferOverflowError`. Please consider improving destination settings to resolve `BufferOverflowError` or use `@ERROR` label for routing overflowed events to another backup destination \(or `secondary` with lower `retry_limit`\). If you hit `BufferOverflowError` frequently, it means your destination capacity is insufficient for your traffic.

* `drop_oldest_chunk`

  This mode drops the oldest chunks. This mode is useful for monitoring system destinations. For monitoring, newer events are important than older.

### Control Retrying

If the bottom chunk write out fails, it will remain in the queue and Fluentd will retry after waiting for several seconds \(`retry_wait`\). If the retry limit has not been disabled \(`retry_forever` is `false`\) and the retry count exceeds the specified limit \(`retry_max_times`\), **all chunks in the queue are discarded**. The retry wait time doubles each time \(1.0sec, 2.0sec, 4.0sec, ...\) until `retry_max_interval` is reached. If the queue length exceeds the specified limit \(`queue_limit_length`\), new events are rejected.

Writing out the bottom chunk is considered to be a failure if `Output#write` or `Output#try_write` method throws an exception.

The retry timings of `retry_timeout: 100s`.

| N-th retry | Elapsed |
| :---       | :---    |
| 1th        | 1s      |
| 2th        | 3s      |
| 3th        | 7s      |
| 4th        | 15s     |
| 5th        | 31s     |
| 6th        | 63s     |
| 7th        | 100s    |

#### `retry_type`

Specifies how to wait for the next retry to flush buffer.

Supported types:

* `exponential_backoff` \(default\)
* `periodic`

#### `retry_forever`

If `true`, plugin will ignore `retry_timeout` and `retry_max_times` options and retry flushing forever.

Default: `false`

#### `retry_timeout`

The maximum seconds to retry to flush while failing, until the plugin discards the buffer chunks. If the next retry is going to exceed this time limit, the last retry will be made at exactly this time limit.

Default: `72h` \(72 hours\)

#### `retry_max_times`

The maximum number of times to retry to flush while failing. If `retry_timeout` is the default, the number is 18 with exponential backoff.

Default: `nil`

#### `retry_secondary_threshold`

The ratio of `retry_timeout` to switch to use secondary while failing.

Default: `0.8`

#### `retry_wait`

Seconds to wait before the next retry to flush, or constant factor of exponential backoff.

Default: `1`

#### `retry_exponential_backoff_base`

The base number of exponential backoff for retries.

Default: `2`

#### `retry_max_interval`

The maximum interval \(seconds\) for exponential backoff between retries while failing.

Default: `nil`

#### `retry_randomize`

If `true`, the output plugin will retry after a randomized interval not to do burst retries.

Default: `true`

For other configuration parameters available in `<buffer>` section, see [Buffer Plugin Overview](../buffer/).

## Secondary Output

In `buffered` mode, the user can specify `<secondary>` with any output plugin in `<match>` configuration. If plugins continue to fail writing buffer chunks and exceeds the timeout threshold for retries, then output plugins will delegate the writing of the buffer chunk to the secondary plugin.

`<secondary>` is useful for backup when destination servers are unavailable, e.g. `forward`, `mongo`, etc. We strongly recommend `out_secondary_file` plugin for `<secondary>`.

This example sends logs to Elasticsearch using a file buffer `/var/log/td-agent/buffer/elasticsearch`, and any failure will be sent to `/var/log/td-agent/error/` using `my.logs` for file names:

```text
<match my.logs>
  @type elasticsearch
  host localhost
  port 9200
  logstash_format true
  <buffer>
    @type file
    path /var/log/td-agent/buffer/elasticsearch
  </buffer>
  <secondary>
    @type secondary_file
    directory /var/log/td-agent/error
    basename my.logs
  </secondary>
</match>
```

NOTE: `<secondary>` plugin receives the primary's buffer chunk directly. So, you need to check if your secondary plugin works with the primary setting.

The retry timings of `retry_timeout: 100s` with the secondary.

| N-th retry | Elapsed | Output plugin |
| :---       | :---    | :---          |
| 1th        | 1s      | primary       |
| 2th        | 3s      | primary       |
| 3th        | 7s      | primary       |
| 4th        | 15s     | primary       |
| 5th        | 31s     | primary       |
| 6th        | 63s     | primary       |
| 7th        | 80s     | secondary     |
| 8th        | 81s     | secondary     |
| 9th        | 83s     | secondary     |
| 10th       | 87s     | secondary     |
| 11th       | 95s     | secondary     |
| 12th       | 100s    | secondary     |

The retry timings of `retry_max_times: 10` with the secondary.

| N-th retry | Elapsed | Output plugin |
| :---       | :---    | :---          |
| 1th        | 1s      | primary       |
| 2th        | 3s      | primary       |
| 3th        | 7s      | primary       |
| 4th        | 15s     | primary       |
| 5th        | 31s     | primary       |
| 6th        | 63s     | primary       |
| 7th        | 127s    | primary       |
| 8th        | 255s    | primary       |
| 9th        | 511s    | primary       |
| 10th       | 818s    | secondary     |

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

