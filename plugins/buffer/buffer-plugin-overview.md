# Buffer Plugin Overview

Fluentd has 6 types of plugins: [Input](/plugins/input/input-plugin-overview.md),
[Parser](/plugins/parser/parser-plugin-overview.md), [Filter](/plugins/filter/filter-plugin-overview.md),
[Output](/plugins/output/output-plugin-overview.md), [Formatter](/plugins/formatter/formatter-plugin-overview.md)
and [Buffer](/plugins/buffer/buffer-plugin-overview.md). This article will provide a
high-level overview of Buffer plugins.


## Buffer Plugin Overview

Buffer plugins are used by output plugins. For example, `out_s3` uses
`buf_file` plugin by default to store incoming stream temporally before
transmitting to S3.

Buffer plugins are, as you can tell by the name, *pluggable*. So you can
choose a suitable backend based on your system requirements.

## Buffer Structure

A buffer is essentially a set of "chunks". A chunk is a collection of
records concatenated into a single blob. Chunks are periodically flushed
to the output queue and then sent to the specified destination. Here is
the diagram of how it works:



[![](/images/buffer-internal-and-parameters.png)](/images/buffer-internal-and-parameters.png)



### Common Parameters

Buffer plugins allow fine-grained controls over the buffering behaviours
through config options.

#### `buffer_type`

-   This option specifies which plugin to use as the backend.
-   In default installations, supported values are `file` and `memory`.

#### `buffer_chunk_limit`

-   The maximum size of a chunk allowed (default: 8MB)
-   If a chunk grows more than the limit, it gets flushed to the output
    queue automatically.

#### `buffer_queue_limit`

-   The maximum length of the output queue (default: 256)
-   If the limit gets exceeded, Fluentd will invoke an error handling
    mechanism (See "Handling queue overflow" below for details).

#### `flush_interval`

-   The interval in seconds to wait before invoking the next buffer
    flush (default: 60)

### Handling queue overflow

The `buffer_queue_full_action` option controls the behaviour when the
queue becomes full. For now, three modes are supported:

1.  *exception* (default)
    -   This mode raises a `BufferQueueLimitError` exception to the
        input plugin.
    -   This mode is suitable for data streaming.
    -   It's up to the input plugin to decide how to handle raised
        exceptions.
2.  *block*
    -   This mode blocks the thread until the free space is vacated.
    -   This mode is good for batch-like use-case.
    -   DO NOT use this option casually just for avoiding
        `BufferQueueLimitError` exceptions (see the deployment tips
        below).
3.  *drop\_oldest\_chunk*
    -   This mode drops the oldest chunks.
    -   This mode might be useful for monitoring systems, since newer
        events are much more important than the older ones in this
        context.

#### Deployment tips

If your Fluentd daemon experiences overflows frequently, it means that
your destination is insufficient for your traffic. There are several
measures you can take:

1.  Upgrade the destination node to provide enough data-processing
    capacity.
2.  Use an `@ERROR` label to route overflowed events to another backup
    destination.
3.  Use a `<secondary>` tag to route overflowed events to another backup
    destination.

### Handling write failures

The chunks in the output queue are written out to the destination one by
one. However, the problem is that there might occur an error while
writing out a chunk. For such cases, buffer plugins are equipped with a
"retry" mechanism that handles write failures gracefully.

Here is how it works. If Fluentd fails to write out a chunk, the chunk
will not be purged from the queue, and then, after a certain interval,
Fluentd will retry to write the chunk again. The intervals between retry
attempts are determined by the exponential backoff algorithm, and we can
control the behaviour finely through the following options:

#### `retry_limit`

-   The maximum number of retries for sending a chunk (default: 17)
-   If `retry_limit` is exceeded, Fluentd will discard the given chunk.

#### `disable_retry_limit`

-   If set true, it disables `retry_limit` and make Fluentd retry
    indefinitely (default: false).

#### `retry_wait`

-   The number of seconds the first retry will wait (default: 1.0)
-   This is the seed value used by the exponential backoff algorithm;
    The wait interval will be doubled on each retry.

#### `max_retry_wait`

-   The maximum interval seconds to wait between retries (default:
    unset)
-   If the wait interval reaches this limit, the exponentiation stops.

## Slicing Data by Time

Buffer plugins support a special mode that groups the incoming data by
time frames. For example, you can group the incoming access logs by date
and save them to separate files. Under this mode, a buffer plugin will
behave quite differently in a few key aspects:

1.  It supports the additional `time_slice_*` options (See Q1/Q2 below
    for details)
2.  Chunks will be flushed "lazily" based on the settings of the
    `time_slice_format` option. See Q2 for the relationship of this
    option and `flush_interval`.
3.  The default value of `buffer_chunk_limit` becomes 256mb.

Normally, the output plugin determines in which mode the buffer plugin
operates. For example, `out_s3` and `out_file` will enable the
time-slicing mode. For the list of output plugins which enable the
time-slicing mode, see [this
page](/plugins/output/output-plugin-overview.md/#list-of-time-sliced-output-plugins).

### FAQ

#### Q1. How do we specify the granularity of time chunks?

This is done through the `time_slice_format` option, which is set to
"%Y%m%d" (daily) by default. If you want your chunks to be hourly,
"%Y%m%d%H" will do the job.

#### Q2. What if new logs come after the time corresponding the current chunk?

For example, what happens to an event, timestamped at 2013-01-01
02:59:45 UTC, comes in at 2013-01-01 03:00:15 UTC? Would it make into
the 2013-01-01 02:00:00-02:59:59 chunk?

This issue is addressed by setting the `time_slice_wait` parameter.
`time_slice_wait` sets, in seconds, how long fluentd waits to accept
"late" events into the chunk *past the max time corresponding to that
chunk*. The default value is 600, which means it waits for 10 minutes
before moving on. So, in the current example, as long as the events come
in before 2013-01-01 03:10:00, it will make it in to the 2013-01-01
02:00:00-02:59:59 chunk.

Alternatively, you can also flush the chunks regularly using
`flush_interval`. Note that `flush_interval` and `time_slice_wait` are
mutually exclusive. If you set `flush_interval`, `time_slice_wait` will
be ignored and fluentd would issue a warning.

## List of Buffer Plugins

-   [buf\_memory](/plugins/buffer/buf_memory.md)
-   [buf\_file](/plugins/buffer/buf_file.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
