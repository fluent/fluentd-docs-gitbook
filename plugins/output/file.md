# file Output Plugin

![](/images/plugins/output/file.png)

The `out_file` TimeSliced Output plugin writes events to files. By
default, it creates files on a daily basis (around 00:10). This means
that when you first import records using the plugin, no file is created
immediately. The file will be created when the `time_slice_format`
condition has been met. To change the output frequency, please modify
the `time_slice_format` value.


## Example Configuration

`out_file` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<match pattern>
  @type file
  path /var/log/fluent/myapp
  time_slice_format %Y%m%d
  time_slice_wait 10m
  time_format %Y%m%dT%H%M%S%z
  compress gzip
  utc
</match>
```
Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

## Parameters

### type (required)

The value must be `file`.

### path (required)

The Path of the file. The actual path is path + time + ".log". The time
portion is determined by the time\_slice\_format parameter, descried
below.

The `path` parameter is used as `buffer_path` in this plugin.

Initially, you may see a file which looks like
\"/path/to/file.20140101.log.b4eea2c8166b147a0\". This is an
intermediate buffer file (\"b4eea2c8166b147a0\" identifies the buffer).
Once the content of the buffer has been completely [flushed](/plugins/buffer/file.md),
you will see the output file without the trailing identifier.

### append

The flushed chunk is appended to existence file or not. The default is
`false`. By default, out\_file flushes each chunk to different path.

``` {.CodeRay}
# append false
log.20140608_0.log
log.20140608_1.log
log.20140609_0.log
log.20140609_1.log
```

This makes parallel file processing easy. But if you want to disable
this behaviour, you can disable it by setting `append true`.

``` {.CodeRay}
# append true
log.20140608.log
log.20140609.log
```

### format

The format of the file content. The default is `out_file`.

See [formatter article](/plugins/formatter/README.md) for more detail.

### time\_format

The format of the time written in files. The default format is ISO-8601.

### utc

Uses UTC for path formatting. The default format is localtime.

### compress

Compresses flushed files using `gzip`. No compression is performed by
default.

### symlink\_path

Create symlink to temporary buffered file when `buffer_type` is `file`.
No symlink is created by default. This is useful for tailing file
content to check logs.

## Time Sliced Output Parameters

For advanced usage, you can tune Fluentd's internal buffering mechanism
with these parameters.

### time\_slice\_format

The time format used as part of the file name. The following characters
are replaced with actual values when the file is created:

-   \%Y: year including the century (at least 4 digits)
-   \%m: month of the year (01..12)
-   \%d: Day of the month (01..31)
-   \%H: Hour of the day, 24-hour clock (00..23)
-   \%M: Minute of the hour (00..59)
-   \%S: Second of the minute (00..60)

The default format is `%Y%m%d%H`, which creates one file per hour.

### time\_slice\_wait

The amount of time Fluentd will wait for old logs to arrive. This is
used to account for delays in logs arriving to your Fluentd node. The
default wait time is 10 minutes ('10m'), where Fluentd will wait until
10 minutes past the hour for any logs that occurred within the past
hour.

For example, when splitting files on an hourly basis, a log recorded at
1:59 but arriving at the Fluentd node between 2:00 and 2:10 will be
uploaded together with all the other logs from 1:00 to 1:59 in one
transaction, avoiding extra overhead. Larger values can be set as
needed.

### buffer\_type

The buffer type is `file` by default ([buf\_file](/plugins/buffer/file.md)). The
`memory` ([buf\_memory](/plugins/buffer/memory.md)) buffer type can be chosen as well.
If you use `file` buffer type, `buffer_path` parameter is required.

### buffer\_queue\_limit, buffer\_chunk\_limit

The length of the chunk queue and the size of each chunk, respectively.
Please see the [Buffer Plugin Overview](/plugins/buffer/README.md) article
for the basic buffer structure. The default values are 64 and 8m,
respectively. The suffixes "k" (KB), "m" (MB), and "g" (GB) can be used
for buffer\_chunk\_limit.

### flush\_interval

The interval between data flushes. The default is 60s. The suffixes "s"
(seconds), "m" (minutes), and "h" (hours) can be used.

### flush\_at\_shutdown

If set to true, Fluentd waits for the buffer to flush at shutdown. By
default, it is set to true for Memory Buffer and false for File Buffer.

### retry\_wait, max\_retry\_wait

The initial and maximum intervals between write retries. The default
values are 1.0 and unset (no limit). The interval doubles (with +/-12.5%
randomness) every retry until `max_retry_wait` is reached.

Since td-agent will retry 17 times before giving up by default (see the
`retry_limit` parameter for details), the sleep interval can be up to
approximately 131072 seconds (roughly 36 hours) in the default
configurations.

### retry\_limit, disable\_retry\_limit

The limit on the number of retries before buffered data is discarded,
and an option to disable that limit (if true, the value of `retry_limit`
is ignored and there is no limit). The default values are 17 and false
(not disabled). If the limit is reached, buffered data is discarded and
the retry interval is reset to its initial value (`retry_wait`).

### num\_threads

The number of threads to flush the buffer. This option can be used to
parallelize writes into the output(s) designated by the output plugin.
The default is 1.

### slow\_flush\_log\_threshold

Same as Buffered Output but default value is changed to `40.0` seconds.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
