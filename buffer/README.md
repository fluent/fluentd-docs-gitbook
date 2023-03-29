# Buffer Plugins

Fluentd has nine \(9\) types of plugins:

* [Input](../input/)
* [Parser](../parser/)
* [Filter](../filter/)
* [Output](../output/)
* [Formatter](../formatter/)
* [Storage](../storage/)
* [Service Discovery](../service_discovery/)
* [Buffer](./)
* [Metrics](../metrics/)

This article gives an overview of Buffer Plugin.

## Overview

Buffer plugins are used by output plugins. For example, `out_s3` uses `buf_file` by default to store incoming stream temporally before transmitting to S3.

Buffer plugins are, as you can tell by the name, _pluggable_. So you can choose a suitable backend based on your system requirements.

## How Buffer Works

A buffer is essentially a set of "chunks". A chunk is a collection of events concatenated into a single blob. Each chunk is managed one by one in the form of files \([`buf_file`](file.md)\) or continuous memory blocks \([`buf_memory`](memory.md)\).

### The Lifecycle of Chunks

You can think of a chunk as a cargo box. A buffer plugin uses a chunk as a lightweight container, and fills it with events incoming from input sources. If a chunk becomes full, then it gets "shipped" to the destination.

Internally, a buffer plugin has two separated places to store its chunks: _"stage"_ where chunks get filled with events, and _"queue"_ where chunks wait before the transportation. Every newly-created chunk starts from _stage_, then proceeds to _queue_ in time \(and subsequently gets transferred to the destination\).

![Fluentd-v0.14 Plugin API Overview](../.gitbook/assets/fluentd-v0.14-plugin-api-overview.png)

## Control Retry Behavior

A chunk can fail to be written out to the destination for a number of reasons. The network can go down, or the traffic volumes can exceed the capacity of the destination node. To handle such common failures gracefully, buffer plugins are equipped with a built-in retry mechanism.

### How Exponential Backoff Works

By default, Fluentd increases the wait interval exponentially for each retry attempt. For example, assuming that the initial wait interval is set to 1 second and the exponential factor is 2, each attempt occurs at the following time points:

```text
0 1   3       7               15
x-x---x-------x---------------x-------------------------
│ │   │       │               └─  4th retry (wait = 8s)
│ │   │       └─────────────────  3th retry (wait = 4s)
│ │   └─────────────────────────  2th retry (wait = 2s)
│ └─────────────────────────────  1th retry (wait = 1s)
└───────────────────────────────  FAIL
```

Note that, in practice, Fluentd tweaks this algorithm in a few aspects:

* Wait intervals are **randomized** by default. That is, Fluentd

  diversifies the wait interval by multiplying by a randomly-chosen

  number between 0.875 and 1.125. You can turn off this behavior by

  setting `retry_randomize` to `false`.

* Wait intervals can be **capped** to a certain limit. For example,

  if you set `retry_max_interval` to 5 seconds in the example above,

  the 4th retry will wait for 5 seconds, instead of 8 seconds.

If you want to disable the exponential backoff, set the `retry_type` option to `periodic`.

### Handling Successive Failures

Fluentd will abort the attempt to transfer the failing chunks on the following conditions:

1. The number of retries exceeds `retry_max_times` \(default: `none`\)
2. The seconds elapsed since the first retry exceeds `retry_timeout`

   \(default: `72h`\)

In these events, **all chunks in the queue are discarded.** If you want to avoid this, you can enable `retry_forever` to make Fluentd retry indefinitely.

### Handling Unrecoverable Errors

Not all errors are recoverable in nature. For example, if the content of a chunk file gets corrupted, you obviously cannot fix anything just by redoing the write operation. Rather, a blind retry attempt will just make the situation worse.

Since v1.2.0, Fluentd can detect these non-recoverable failures. If these kinds of fatal errors occur, Fluentd will abort the chunk immediately and move it into `secondary` or the backup directory. The exact location of the backup directory is determined by the parameter `root_dir` in `<system>`:

```text
${root_dir}/backup/worker${worker_id}/${plugin_id}/{chunk_id}.log
```

If you do not need to back up chunks, you can enable `disable_chunk_backup` \(available since v1.2.6\) in the `<buffer>` section.

The following is the current list of exceptions considered **unrecoverable**:

| Exception | The typical cause of this error |
| :--- | :--- |
| `Fluent::UnrecoverableError` | Output plugin can use this exception to suppress further retry attempts for plugin-specific unrecoverable error. |
| `TypeError` | Occurs when an event has an unexpected type in its target field. |
| `ArgumentError` | Occurs when the plugin uses the library wrongly. |
| `NoMethodError` | Occurs when events and configuration are mismatched. |

Here are the patterns when an unrecoverable error happens:

* If the plugin does not have a `secondary`, the chunk is moved to the backup

  directory.

* If the plugin has a `secondary` which is of different type from primary,

  the chunk is moved to `secondary`.

* If the unrecoverable error happens inside `secondary`, the chunk is

  moved to the backup directory.

#### Detecting chunk file corruption when Fluentd starts up

When starting up, Fluentd loads all remaining chunk files.

Some chunk files are possibly corrupted after Fluentd stopped abnormally, such as due to a power failure.
Since v1.16.0, those corrupted files are considered **unrecoverable** too and are moved to the backup directory at starting up of Fluentd.
(Before v1.16.0, those files are just deleted.)

Note that depending on how corrupt the file is, it may not be detected.
In such cases, some corrupted data will flow to subsequent processes and cause unexpected errors.

Since v1.16.0, in order to narrow down the range of data that possibly be corrupted, if corruption is detected in even one of the files,
information on other files remaining at starting up is also output to the log.

```
[info]: #0 fluent/log.rb:330:info: starting fluentd worker pid=920781 ppid=920761 worker=0
[error]: #0 [test_id] found broken chunk file during resume. path="/test/fluentd/buffer/buffer.b5f32232e76a4d1bdfdbeed36c384b03b.log" mode=:staged err_msg="staged meta file is broken. no implicit conversion of Symbol into Integer"
[warn]: #0 [test_id] bad chunk is moved to /test/fluentd/forwarder/backup/worker0/test_id/5f32232e76a4d1bdfdbeed36c384b03b.log
[info]: #0 [test_id] Since a broken chunk file was found, it is possible that other files remaining at the time of resuming were also broken. Here is the list of the files.
[info]: #0 [test_id]   /test/fluentd/buffer/buffer.b5f32716d7292f8138b36fd759abf7207.log: created_at=2023-01-26 18:08:16 +0900 modified_at=2023-01-26 18:08:17 +0900
[info]: #0 [test_id]   /test/fluentd/buffer/buffer.b5f32716d734618fef772d3ae48fd577a.log: created_at=2023-01-26 18:08:16 +0900 modified_at=2023-01-26 18:08:17 +0900
[info]: #0 fluent/log.rb:330:info: fluentd worker is now running worker=0
```

If data corruption occurs due to an abnormal termination, please take the necessary recovery process based on these information.

### Configuration Example

Following is a complete configuration that covers all the parameters controlling the retry behaviors:

```text
<system>
  root_dir /var/log/fluentd         # For handling unrecoverable chunks
</system>

<buffer>
  retry_wait 1                      # The wait interval for the first retry.
  retry_exponential_backoff_base 2  # Increase the wait time by a factor of N.
  retry_type exponential_backoff    # Set 'periodic' for constant intervals.

  # retry_max_interval 1h           # Cap the wait interval. (see above)
  retry_randomize true              # Apply randomization. (see above)
  retry_timeout 72h                 # Maximum duration before giving up.

  # retry_max_times 17              # Maximum retry count before giving up.
  retry_forever false               # Set 'true' for infinite retry loops.
  retry_secondary_threshold 0.8     # See the "Secondary Output" section in
</buffer>                           # 'Output Plugins' > 'Overview'.
```

Normally, you do not need to specify every option as in this example, because these options are, in fact, optional. As for the detail of each option, please read [this article](../configuration/buffer-section.md#retries-parameters).

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Buffer Section Configurations](../configuration/buffer-section.md)

## FAQ

### Buffer's chunk size and output's payload size are sometimes different, why?

Because the format of buffer chunk is different from output's payload. Let's use elasticsearch output plugin, `out_elasticsearch`, for the detailed explanation.

`out_elasticsearch` uses MessagePack for buffer's serialization \(NOTE that this depends on the plugin\). On the other hand, [Elasticsearch's Bulk API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html) requires JSON-based payload. It means that one MessagePack-ed record is converted into 2 JSON lines. So, the payload size is larger than the buffer's chunk size.

This sometimes causes a problem when the output destination has a payload size limitation. If you have a problem with the payload size issue, check chunk size configuration, and API spec.

## List of Buffer Plugins

* [`buf_memory`](memory.md)
* [`buf_file`](file.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

