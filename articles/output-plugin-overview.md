# Output Plugin Overview

Fluentd has 7 types of plugins: [Input](/articles/input-plugin-overview.md),
[Parser](/articles/parser-plugin-overview.md), [Filter](/articles/filter-plugin-overview.md),
[Output](/articles/output-plugin-overview.md),
[Formatter](/articles/formatter-plugin-overview.md),
[Storage](/articles/storage-plugin-overview.md) and [Buffer](/articles/buffer-plugin-overview.md).
This article gives an overview of Output Plugin.


## Overview

Fluentd v1.0 output plugins have 3 modes about buffering and flushing.

-   *Non-Buffered* mode doesn't buffer data and write out results
    immediately.
-   *Synchronous Buffered* mode has "staged" buffer chunks (a chunk is a
    collection of events) and a queue of chunks, and its behavior can be
    controlled by `<buffer>` section (See the diagram below).
-   *Asynchronous Buffered* mode also has "stage" and "queue", but
    output plugin will not commit writing chunks in methods
    synchronously, but commit later.

![Fluentd v1.0 Plugin API
Overview](//docs.fluentd.org/images/fluentd-v0.14-plugin-api-overview.png)

Output plugins can support all modes, but may support just one of these
modes. Fluentd choose appropriate mode automatically if there are no
`<buffer>` sections in configuration. If users specify `<buffer>`
section for output plugins which doesn't support buffering, Fluentd will
stop with configuration errors.

Output plugins in v0.14 can control keys of buffer chunking by
configurations, dynamically. Users can configure buffer chunk keys as
time (any unit specified by user), tag and any key name of records.
Output plugin will split events into chunks: events in a chunk have same
values for chunk keys. The output plugin's buffer behavior (if any) is
defined by a separate [Buffer plugin](/articles/buffer-plugin-overview.md). Different
buffer plugins can be chosen for each output plugin.


## List of Output Plugins

-   [out\_copy](/articles/out_copy.md)
-   [out\_null](/articles/out_null.md)
-   [out\_roundrobin](/articles/out_roundrobin.md)
-   [out\_stdout](/articles/out_stdout.md)
-   [out\_exec\_filter](/articles/out_exec_filter.md)
-   [out\_forward](/articles/out_forward.md)
-   [out\_mongo](/articles/out_mongo.md) or [out\_mongo\_replset](/articles/out_mongo_replset.md)
-   [out\_exec](/articles/out_exec.md)
-   [out\_file](/articles/out_file.md)
-   [out\_s3](/articles/out_s3.md)
-   [out\_webhdfs](/articles/out_webhdfs.md)


## Other Plugins

Please refer to this list of available plugins to find out about other
Output plugins.

-   [others](http://fluentd.org/plugin/)


## Difference between v1.0 and v0.12

Fluentd v0.12 uses only `<match>` section for both of configuration
parameters of output plugin and buffer plugin. Fluentd v1.0 uses
`<buffer>` subsection to write parameters for buffering, flushing and
retrying. `<match>` sections are used only for output plugin itself.

Example of v1.0 output plugin configuration:

``` {.CodeRay}
<match myservice_name>
  @type file
  path /my/data/access.${tag}.%Y-%m-%d.%H%M.log
  <buffer tag,time>
    @type file
    path /my/buffer/myservice
    timekey     60m
    timekey_wait 1m
  </buffer>
</source>
```

For Fluentd v0.12, configuration parameters for buffer plugins were
written in same section:

``` {.CodeRay}
<match myservice_name>
  @type file
  path /my/data/access.myservice_name.*.log
  buffer_type file
  buffer_path /my/buffer/myservice/access.myservice_name.*.log
  time_slice_format %Y-%m-%d.%H%M
  time_slice_wait   1m
</source>
```

See buffer section in [Compat Parameters Plugin Helper
API](https://docs.fluentd.org/articles/api-plugin-helper-compat_parameters#compat_parameters_convert(conf,-*types,-**kwargs))
for parameter name changes between v1 and v0.12.


## Buffering/Retrying Parameters

See [Buffer section configurations](/articles/buffer-section.md).


### Control Flushing

See [Buffer Plugin Overview](/articles/buffer-plugin-overview.md) for the basic
behaviour of buffer.

#### flush\_mode

The default is `default`. Supported types are `default`, `lazy`,
`interval` or `immediate`

How to enqueue chunks to be flushed. "interval" flushes per
flush\_interval, "immediate" flushes just after event arrival.

#### flush\_interval

the default is 60

The interval between buffer chunk flushes.

#### flush\_thread\_count

The default is 1.

The number of threads to flush the buffer.

#### flush\_thread\_interval

The default is `1.0`

Seconds to sleep between checks for buffer flushes in flush threads.

#### flush\_thread\_burst\_interval

The default is `1.0`

Seconds to sleep between flushes when many buffer chunks are queued.

#### delayed\_commit\_timeout

The default is 60.

Seconds of timeout for buffer chunks to be committed by plugins later

#### overflow\_action

Control the buffer behaviour when the queue becomes full. 3 modes are
supported:

-   throw\_exception

This is default mode. This mode raises `BufferQueueLimitError` exception
to input plugin. How handle `BufferQueueLimitError` depends on input
plugins, e.g. tail input stops reading new lines, forward input returns
an error to forward output. This action fits for streaming manner.

-   block

This mode stops input plugin thread until buffer full is resolved. This
action is good for batch-like use-case.

We don't recommend to use `block` action to avoid
`BufferQueueLimitError`. Please consider improving destination setting
to resolve `BufferQueueLimitError` or use `@ERROR` label for routing
overflowed events to another backup destination(or `secondary` with
lower `retry_limit`). If you hit `BufferQueueLimitError` frequently, it
means your destination capacity is insufficient for your traffic.

-   drop\_oldest\_chunk

This mode drops oldest chunks. This mode is useful for monitoring system
destinations. For monitoring, newer events are important than older.


### Control Retrying

If the bottom chunk write out fails, it will remain in the queue and
Fluentd will retry after waiting several seconds (`retry_wait`). If the
retry limit has not been disabled (`retry_forever` is true) and the
retry count exceeds the specified limit (`retry_max_times`), the chunk
is trashed. The retry wait time doubles each time (1.0sec, 2.0sec,
4.0sec, ...) until `retry_max_interval` is reached. If the queue length
exceeds the specified limit (`queue_limit_length`), new events are
rejected.

writing out the bottom chunk is considered to be a failure if
\"Output\#write\" or \`Output\#try\_write\` method throws an exception.

#### retry\_type

The default is `exponential_backoff`.

How to wait next retry to flush buffer. Supported types are
`exponential_backoff` or `periodic`

#### retry\_forever

The default is false.

If true, plugin will ignore retry\_timeout and retry\_max\_times options
and retry flushing forever.

#### retry\_timeout

The default is 72 hours.

The maximum seconds to retry to flush while failing, until plugin
discards buffer chunks.

#### retry\_max\_times

The default is `nil`

The maximum number of times to retry to flush while failing. If
`retry_timeout` is the default, the number is 17 with exponential
backoff.

#### retry\_secondary\_threshold

The default is `0.8`

The ratio of retry\_timeout to switch to use secondary while failing.

#### retry\_wait

The default is 1

Seconds to wait before next retry to flush, or constant factor of
exponential backoff.

#### retry\_exponential\_backoff\_base

The default is 2

The base number of exponencial backoff for retries.

#### retry\_max\_interval

The default is `nil`.

The maximum interval seconds for exponential backoff between retries
while failing.

#### retry\_randomize, :bool, default: true

The default is `true`.

If true, output plugin will retry after randomized interval not to do
burst retries.

For other configuration parameters available in `<buffer>` sections, see
[Buffer plugin overview](/articles/buffer-plugin-overview.md) and each plugins.


## Secondary Output

In buffered mode, the user can specify `<secondary>` with any output
plugin in `<match>` configuration. If plugins continue to fail writing
buffer chunks and exceeds the timeout threshold for retries, then output
plugins will delegate to write the buffer chunk to secondary plugin.

`<secondary>` is useful for backup when destination servers are
unavailable, e.g. forward, mongo and other plugins. We strongly
recommend `out_secondary_file` plugin for `<secondary>`.

TODO: add examples for secondary output


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
