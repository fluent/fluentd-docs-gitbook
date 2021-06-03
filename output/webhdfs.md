# webhdfs

![](../.gitbook/assets/webhdfs.png)

The `out_webhdfs` Output plugin writes records into HDFS \(Hadoop Distributed File System\). By default, it creates files on an hourly basis. This means that when you first import records using the plugin, no file is created immediately.

The file will be created when the `timekey` condition has been met. To change the output frequency, please modify the `timekey` value.

This document does not describe all the parameters. For more details, see the **Further Reading** section.

## Install

`out_webhdfs` is included in `td-agent` by default \(v1.1.10 or later\). Fluentd gem users will have to install the `fluent-plugin-webhdfs` gem using the following command:

```text
$ fluent-gem install fluent-plugin-webhdfs
```

## HDFS Configuration

Append operations are not enabled by default on CDH. Please put these configurations into your `hdfs-site.xml` file and restart the whole cluster:

```text
<property>
  <name>dfs.webhdfs.enabled</name>
  <value>true</value>
</property>

<property>
  <name>dfs.support.append</name>
  <value>true</value>
</property>

<property>
  <name>dfs.support.broken.append</name>
  <value>true</value>
</property>
```

## Example Configuration

```text
<match access.**>
  @type webhdfs
  host namenode.your.cluster.local
  port 50070
  path "/path/on/hdfs/access.log.%Y%m%d_%H.#{Socket.gethostname}.log"
  <buffer>
    flush_interval 10s
  </buffer>
</match>
```

Please see the [Fluentd + HDFS: Instant Big Data Collection](../how-to-guides/http-to-hdfs.md) article for real-world use cases.

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file. For `<buffer>`, please check [Buffer Section Configuration](../configuration/buffer-section.md).

## Plugin Helpers

* [`inject`](../plugin-helper-overview/api-plugin-helper-inject.md)
* [`formatter`](../plugin-helper-overview/api-plugin-helper-formatter.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type` \(required\)

The value must be `webhfds`.

### `host` \(required\)

The node hostname.

### `port` \(required\)

The node port number.

### `path` \(required\)

The path on HDFS. Please include `"#{Socket.gethostname}"` in your path to avoid writing into the same HDFS file from multiple Fluentd instances. This conflict could result in data loss.

Path value can contain time placeholders. The following characters are replaced with actual values when the file is created:

* `%Y`: year including the century \(at least 4 digits\)
* `%m`: month of the year \(01..12\)
* `%d`: Day of the month \(01..31\)
* `%H`: Hour of the day, 24-hour clock \(00..23\)
* `%M`: Minute of the hour \(00..59\)
* `%S`: Second of the minute \(00..60\)

Although it is possible to contain time placeholder with `path` configuration, it is recommended to specify the format using `<format>` section.

## Output Parameters \(and overwritten values by `out_webhdfs`\)

For advanced usage, you can tune Fluentd's internal buffering mechanism with these parameters.

### `timekey`

This plugin will flush chunks per specified time by the `timekey` parameter. The default value is `86400` \(when the path does not contain the time placeholders\), which creates one file per day.

This parameter is specified by the `path` configuration. For example, when `path` contains `%H`, the value is `3600` and creates one file per hour.

### `timekey_wait`

The amount of time Fluentd will wait for old logs to arrive. This is used to account for delays in logs arriving to your Fluentd node. The default wait time is 10 minutes \(`10m`\), where Fluentd will wait until 10 minutes past the hour for any logs that occurred within the past hour.

For example, when splitting files on an hourly basis, a log recorded at 1:59 but arriving at the Fluentd node between 2:00 and 2:10 will be uploaded together with all the other logs from 1:00 to 1:59 in one single transaction, avoiding extra overhead. Larger values can be set as needed.

### `queue_limit_length`, `chunk_limit_size`

The length of the chunk queue and the size of each chunk, respectively. Please see the [Buffer Plugin Overview](../buffer/) article for the basic buffer structure. The default values are `64` and `8m`, respectively. The suffixes `k` \(KB\), `m` \(MB\), and `g` \(GB\) can be used for `chunk_limit_size`.

### `flush_interval`

The interval between data flushes. The default is unspecified, and the buffer chunks will be flushed at the end of the time slices. The suffixes `s` \(seconds\), `m` \(minutes\), and `h` \(hours\) can be used.

### `flush_at_shutdown`

The boolean value to specify whether to flush buffer chunks on shutdown, or not. The default is `true`. Specify `true` if you use `memory` buffer type.

### `retry_wait`, `retry_max_interval`

The initial and maximum intervals between write retries. The default values are `1.0` and `unset` \(no limit\). The interval doubles \(with +/-12.5% randomness\) every retry until `retry_max_interval` is reached.

Since `td-agent` will retry `17` times before giving up by default \(see the `retry_max_times` parameter for details\), the sleep interval can be up to approximately 131072 seconds \(roughly 36 hours\) in the default configurations.

### `retry_max_times`, `retry_forever`

The limit on the number of retries before buffered data is discarded, and an option to disable that limit \(if `true`, the value of `retry_max_times` is ignored and there is no limit\). The default values are `17` and `false` \(not disabled\). If the limit is reached, buffered data is discarded and the retry interval is reset to its initial value \(`retry_wait`\).

### `flush_thread_count`

The number of threads to flush the buffer. This option can be used to parallelize writes into the output\(s\) designated by the output plugin. The default is `1`.

#### `@log_level`

The `@log_level` option allows the user to set different levels of logging for each plugin.

Supported log levels: `fatal`, `error`, `warn`, `info`, `debug`, `trace`

Please see the [logging](../deployment/logging.md) article for further details.

## Common Output / Buffer parameters

For common output / buffer parameters, please check the following articles:

* [Output Plugin Overview](./)
* [Buffer Section Configuration](../configuration/buffer-section.md)

## Further Reading

* [`fluent-plugin-webhdfs`](https://github.com/fluent/fluent-plugin-webhdfs)
* [Slides: Fluentd and WebHDFS](http://www.slideshare.net/tagomoris/fluentd-and-webhdfs)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

