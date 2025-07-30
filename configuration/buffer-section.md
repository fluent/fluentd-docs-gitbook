# Config: Buffer Section

Fluentd output plugins support the `<buffer>` section to configure the buffering of events. The buffering is handled by the Fluentd core.

## Buffer Section Overview

Buffer section comes under the `<match>` section. It is enabled for those output plugins that support buffered output features.

```text
<match tag.*>
  @type file
  # ...
  <buffer>
    # ...
  </buffer>

  # <buffer> section can only be configured once!
</match>
```

## Buffer Plugin Type

The `@type` parameter of `<buffer>` section specifies the type of the buffer plugin:

```text
<buffer>
  @type file
</buffer>
```

Fluentd core bundles `file` and `memory` buffer plugins i.e.:

* [`buf_file`](../buffer/file.md)
* [`buf_memory`](../buffer/memory.md)

Third-party plugins may also be installed and configured.

However, the `@type` parameter is not mandatory. If omitted, by default, the buffer plugin specified by the output plugin is used \(if possible\). Otherwise, the `memory` buffer plugin is used.

For the usual workload, the file buffer plugin is recommended. It is more durable for the general use-cases.

## Chunk Keys

The output plugins group events into chunks. Chunk keys, specified as the argument of `<buffer>` section, control how to group events into chunks.

```text
<buffer ARGUMENT_CHUNK_KEYS>
  # ...
</buffer>
```

If specified, the chunk key arguments must be comma-separated strings.

### Blank Chunk Keys

In case of no or blank chunk key, the output plugin writes all the matched events into a single chunk until its size exceeds provided that the output plugin itself does not specify any default chunk keys.

```text
<match tag.**>
  # ...
  <buffer>      # <--- No chunk key specified as argument
    # ...
  </buffer>
</match>

# No chunk keys: All events will be appended into the same chunk.

11:59:30 web.access {"key1":"yay","key2":100}  --|
                                                 |
12:00:01 web.access {"key1":"foo","key2":200}  --|---> CHUNK_A
                                                 |
12:00:25 ssh.login  {"key1":"yay","key2":100}  --|
```

### Tag

If a `tag` is specified as a chunk key, the output plugin writes events into chunks grouped by tag. Events with different tags will be written into different chunks.

```text
<match tag.**>
  # ...
  <buffer tag>
    # ...
  </buffer>
</match>

# Tag chunk key: The events will be grouped into chunks by tag.

11:59:30 web.access {"key1":"yay","key2":100}  --|
                                                 |---> CHUNK_A
12:00:01 web.access {"key1":"foo","key2":200}  --|

12:00:25 ssh.login  {"key1":"yay","key2":100}  ------> CHUNK_B
```

### Time

If the argument `time` and the parameter `timekey` \(required\) are specified, the output plugin writes events into chunks grouped by time key.

Time key is calculated like this:

```text
time (unix time) / timekey (seconds)
```

For example:

* timekey 60: `["12:00:00", ..., "12:00:59"]`, `["12:01:00", ..., "12:01:59"]`,

  ...

* timekey 180: `["12:00:00", ..., "12:02:59"]`, `["12:03:00", ..., "12:05:59"]`,

  ...

* timekey 3600: `["12:00:00", ..., "12:59:59"]`, `["13:00:00", ..., "13:59:59"]`,

  ...

The events will be grouped into chunks by their time range. They will be flushed by the output plugin after the expiration of the time key range.

```text
<match tag.**>
  # ...
  <buffer time>
    timekey      1h # chunks per hours ("3600" also available)
    timekey_wait 5m # 5mins delay for flush ("300" also available)
  </buffer>
</match>

# Time chunk key: The events will be grouped by timekey with timekey_wait delay.

11:59:30 web.access {"key1":"yay","key2":100}  ------> CHUNK_A

12:00:01 web.access {"key1":"foo","key2":200}  --|
                                                 |---> CHUNK_B
12:00:25 ssh.login  {"key1":"yay","key2":100}  --|
```

The `timekey_wait` parameter configures the flush delay for events. The default is 600 \(10 minutes\).

The event time is normally the delayed time from the current timestamp. Fluentd will wait to flush the buffered chunks for delayed events. For example, the figure below shows when the chunks \(timekey: 3600\) will be flushed actually, for sample `timekey_wait` values:

```text
 timekey: 3600
 -------------------------------------------------------
 time range for chunk | timekey_wait | actual flush time
  12:00:00 - 12:59:59 |           0s |          13:00:00
  12:00:00 - 12:59:59 |     60s (1m) |          13:01:00
  12:00:00 - 12:59:59 |   600s (10m) |          13:10:00
```

### Other Keys

The other \(non-time/non-tag\) keys are handled as the field names of records. The output plugin will group events into chunks by the value of these fields.

```text
<match tag.**>
  # ...
  <buffer key1>
    # ...
  </buffer>
</match>

# Chunk keys: The events will be grouped by values of "key1".

11:59:30 web.access {"key1":"yay","key2":100}  --|---> CHUNK_A
                                                 |
12:00:01 web.access {"key1":"foo","key2":200}  --|---> CHUNK_B
                                                 |
12:00:25 ssh.login  {"key1":"yay","key2":100}  --|---> CHUNK_A
```

#### Nested Field Support

The nested field\(s\) may be specified using the [`record_accessor`](../plugin-helper-overview/api-plugin-helper-record_accessor.md) syntax.

Example:

```text
<match tag.**>
  # ...
  <buffer $.nest.field> # access record['nest']['field']
    # ...
  </buffer>
</match>
```

### Combination of Chunk Keys

Two or more chunk keys may be combined together. The events will be grouped into chunks by the combination of the values of these combined chunk keys.

```text
# <buffer tag,time>

11:58:01 ssh.login  {"key1":"yay","key2":100}  ------> CHUNK_A

11:59:13 web.access {"key1":"yay","key2":100}  --|
                                                 |---> CHUNK_B
11:59:30 web.access {"key1":"yay","key2":100}  --|

12:00:01 web.access {"key1":"foo","key2":200}  ------> CHUNK_C

12:00:25 ssh.login  {"key1":"yay","key2":100}  ------> CHUNK_D
```

NOTE: There is no hard limit on the total number of chunk keys. But, too many chunk keys may degrade the I/O performance and/or increase the total resource utilization.

### Empty Keys

Buffer chunk keys may be specified empty by using `[]` as the `buffer` section argument.

```text
<match tag.**>
  # ...
  <buffer []>
    # ...
  </buffer>
</match>
```

This is particularly useful when the output plugin has its own default chunk keys and it needs to disable those.

## Placeholders

When the chunk keys are specified, these values can be extracted in configuration parameter values. It depends on whether the plugin applies a method\(`extract_placeholders`\) on configuration values or not.

The following configuration shows `file` output plugin that applies `extract_placeholders` on `path`:

```text
# chunk_key: tag
# ${tag} will be replaced with actual tag string
<match log.*>
  @type file
  path /data/${tag}/access.log  #=> "/data/log.map/access.log"
  <buffer tag>
    # ...
  </buffer>
</match>
```

The value of `timekey` in buffer chunk keys can be extracted using `strptime` placeholders. The extracted time value is the first second of the timekey range.

Example:

```text
# chunk_key: tag and time
# ${tag[1]} will be replaced with 2nd part of tag ("map" of "log.map"), zero-origin index
# %Y, %m, %d, %H, %M, %S: strptime placeholder are available when "time" chunk key specified

<match log.*>
  @type file
  path /data/${tag[1]}/access.%Y-%m-%d.%H%M.log #=> "/data/map/access.2017-02-28.20:48.log"

  <buffer tag,time>
    timekey 1m
  </buffer>
</match>
```

Any key is acceptable as a chunk key. If a key other than specified in the chunk keys is referenced, Fluentd raises configuration errors.

```text
<match log.*>
  @type file
  path /data/${tag}/access.${key1}.log #=> "/data/log.map/access.yay.log"
  <buffer tag,key1>
    # ...
  </buffer>
</match>
```

### Chunk ID

`${chunk_id}` will be replaced with internal chunk id. No need to specify `chunk_id` in chunk keys.

```text
<match test.**>
  @type file
  path /path/to/app_${tag}_${chunk_id}
  append true
  <buffer tag>
    flush_interval 5s
  </buffer>
</match>
```

The result with `test.foo` tag is like below:

```text
# 5b35967b2d6c93cb19735b7f7d19100c is chunk id
/path/to/app_test.foo_5b35967b2d6c93cb19735b7f7d19100c.log
```

This placeholder is useful for identifying chunks, e.g. `secondary_file`, `s3` and more.

### Nested Field Support

Same with chunk keys:

```text
<match log.*>
  @type file
  path /data/${tag}/access.${$.nest.field}.log #=> "/data/log.map/access.nested_yay.log"
  <buffer tag,$.nest.field> # access record['nest']['field']
    # ...
  </buffer>
</match>
```

## Parameters

### Argument

It is an array of chunk keys that must be a list of comma-separated strings. It can also be left blank.

```text
<buffer> # blank
  # ...
</buffer>

<buffer tag, time, key1> # keys
  # ...
</buffer>
```

NOTE: The `tag` and `time` chunk keys are reserved for **tag** and **time** and cannot be used for the record fields.

With `time`, the following parameters are available:

* `timekey` \[time\]
  * Required \(no default value\)
  * Output plugin will flush chunks per specified time \(enabled when `time`

    is specified in chunk keys\)
* `timekey_wait` \[time\]
  * Default: 600 \(10m\)
  * Output plugin will write chunks after `timekey_wait` seconds later after

    `timekey` expiration

  * If a user configures `timekey 60m`, output plugin will wait delayed

    events for flushed `timekey` and write the chunk at 10 minutes of each

    hour
* `timekey_use_utc` \[bool\]
  * Default: false \(to use local timezone\)
  * Output plugin decides to use UTC or not to format placeholders using

    timekey
* `timekey_zone` \[string\]
  * Default: local timezone
  * The timezone \(`-0700` or `Asia/Tokyo`\) string for formatting timekey

    placeholders

### `@type`

The `@type` parameter specifies the type of the buffer plugin. The default type is `memory` for bare output plugin but it may be overridden by the output plugin implementations.

For example, the default is `file` buffer plugin for the `file` output plugin:

```text
<buffer>
  @type file
  # ...
</buffer>
```

### Buffering Parameters

Following are the configuration parameters for buffer plugin and its chunks:

* `chunk_limit_size` \[size\]
  * Default: 8MB \(memory\) / 256MB \(file\)
  * The max size of each chunks: events will be written into chunks until

    the size of chunks become this size
* `chunk_limit_records` \[integer\]
  * Optional
  * The max number of events that each chunks can store in it
* `total_limit_size` \[size\]
  * Default: 512MB \(memory\) / 64GB \(file\)
  * The size limitation of this buffer plugin instance
  * Once the total size of stored buffer reached this threshold, all append

    operations will fail with error \(and data will be lost\)
* `queue_limit_length` \[integer\]
  * Default: `nil`
  * The queue length limitation of this buffer plugin instance
  * This parameter is for [v0.12 compatibility](../plugin-helper-overview/api-plugin-helper-compat_parameters.md).

    Use `total_limit_size` instead for v1 configuration.
* `chunk_full_threshold` \[float\]
  * Default: 0.95
  * The percentage of chunk size threshold for flushing
  * output plugin will flush the chunk when actual size reaches

    `chunk_limit_size * chunk_full_threshold (== 8MB * 0.95 in default)`
* `queued_chunks_limit_size` \[integer\] \(since v1.1.3\)
  * Default: 1 \(equals to the same value as the `flush_thread_count`

    parameter\)

  * Limit the number of queued chunks.
  * If a smaller `flush_interval` is set, e.g. 1s, there are lots of small

    queued chunks in the buffer. With file buffer, it may consume a lot of

    fd resources when output destination has a problem. This parameter

    mitigates such situations.
* `compress` \[ enum: `text` / `gzip` / `zstd`\(since v1.19.0\) \]
  * Default: `text`
  * If `gzip`/`zstd` is set, Fluentd compresses data records before writing to

    buffer chunks.

  * Fluentd will decompress these compressed chunks automatically when

    the output plugin sends the chunk to the destination. \(The exceptional

    case is when the output plugin can transfer data in compressed form.

    In this case, the data will be passed to the destination as is\).

  * The default`text` means that no compression is applied.

### Flushing Parameters

Following are the flushing parameters for chunks to optimize performance \(latency and throughput\):

* `flush_at_shutdown` \[bool\]
  * Default: `false` for persistent buffers \(e.g. `buf_file`\), `true` for

    non-persistent buffers \(e.g. `buf_memory`\)

  * This specifies whether to flush/write all buffer chunks on shutdown or

    not
* `flush_mode` \[enum: `default`/`lazy`/`interval`/`immediate`\]
  * Default: `default` \(equals to `lazy` if `time` is specified as chunk

    key, `interval` otherwise\)

  * `lazy`: flushes/writes chunks once per timekey
  * `interval`: flushes/writes chunks per specified time via

    `flush_interval`

  * `immediate`: flushes/writes chunks immediately after events are appended

    into chunks
* `flush_interval` \[time\]
  * Default: 60s
* `flush_thread_count` \[integer\]
  * Default: 1
  * The number of threads to flush/write chunks in parallel
* `flush_thread_interval` \[float\]
  * Default: 1.0
  * The sleep interval \(seconds\) for threads to wait for the next flush try

    \(when no chunks are waiting\)
* `flush_thread_burst_interval` \[float\]
  * Default: 1.0
  * The sleep interval \(seconds\) for threads between flushes when the output

    plugin flushes the waiting chunks to the next ones
* `delayed_commit_timeout` \[time\]
  * Default: 60
  * The timeout \(seconds\) until output plugin decides if the async write

    operation has failed
* `overflow_action` \[enum: `throw_exception`/`block`/`drop_oldest_chunk`\]
  * Default: `throw_exception`
  * How does output plugin behave when its buffer queue is full?
    * `throw_exception`: raises an exception to show the error in log
    * `block`: wait until buffer can store more data.

      After buffer is ready for storing more data, writing buffer is retried.

      Because of such behavior, `block` is suitable for processing batch execution,

      so do not use for improving processing throughput or performance.

    * `drop_oldest_chunk`: drops/purges the oldest chunk to accept newly

      incoming chunk

### Retries Parameters

* `retry_timeout` \[time\]
  * Default: 72h
  * The maximum time \(seconds\) to retry to flush again the failed chunks,

    until the plugin discards the buffer chunks.

    If the next retry is going to exceed this time limit, the last retry

    will be made at exactly this time limit.
* `retry_forever` \[bool\]
  * Default: `false`
  * If true, plugin will ignore `retry_timeout` and `retry_max_times`

    options and retry flushing forever
* `retry_max_times` \[integer\]
  * Default: `none`
  * The maximum number of times to retry to flush the failed chunks
* `retry_secondary_threshold` \[float\]
  * Default: 0.8
  * The ratio of `retry_timeout` to switch to use the secondary while

    failing \(maximum valid value is 1.0\)
* `retry_type` \[enum: `exponential_backoff`/`periodic`\]
  * Default: `exponential_backoff`
  * `exponential_backoff`: wait in seconds will become large exponentially

    per failure

  * `periodic`: output plugin will retry periodically with fixed intervals

    \(configured via `retry_wait`\)
* `retry_wait` \[time\]
  * Default: 1s
  * Wait in seconds before the next retry to flush or constant factor of

    exponential backoff
* `retry_exponential_backoff_base` \[float\]
  * Default: 2
  * The base number of exponential backoff for retries
* `retry_max_interval` \[time\]
  * Default: none
  * The maximum interval \(seconds\) for exponential backoff between retries

    while failing
* `retry_randomize` \[bool\]
  * Default: true
  * If true, the output plugin will retry after randomized interval not to

    do burst retries
* `disable_chunk_backup` \[bool\]
  * Default: false
  * Instead of storing unrecoverable chunks in the backup directory, just

    discard them. This option is new in Fluentd v1.2.6.

With `exponential_backoff`, `retry_wait` interval will be calculated as below:

* c: constant factor, `@retry_wait`
* b: base factor, `@retry_exponential_backoff_base`
* k: number of retry times
* total retry time: `c + c*b^1 + (...) + c*b^(k-1) = c*(b^k - 1) / (b - 1)`
  * = `2^k - 1` by default

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

