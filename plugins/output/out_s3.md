# Amazon S3 Output Plugin

The `out_s3` TimeSliced Output plugin writes records into the Amazon S3
cloud object storage service. By default, it creates files on an hourly
basis. This means that when you first import records using the plugin,
no file is created immediately. The file will be created when the
`time_slice_format` condition has been met. To change the output
frequency, please modify the `time_slice_format` value.
This document doesn\'t describe all parameters. If you want to know full
features, check the Further Reading section.


## Installation

`out_s3` is included in td-agent by default. Fluentd gem users will need
to install the fluent-plugin-s3 gem using the following command.

``` {.CodeRay}
$ fluent-gem install fluent-plugin-s3
```

## Example Configuration

``` {.CodeRay}
<match pattern>
  @type s3

  aws_key_id YOUR_AWS_KEY_ID
  aws_sec_key YOUR_AWS_SECRET_KEY
  s3_bucket YOUR_S3_BUCKET_NAME
  s3_region ap-northeast-1
  path logs/
  buffer_path /var/log/fluent/s3

  time_slice_format %Y%m%d%H
  time_slice_wait 10m
  utc

  buffer_chunk_limit 256m
</match>
```

Please see the [Store Apache Logs into Amazon S3](/articles/apache-to-s3.md) article
for real-world use cases.

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

Please make sure that you have **enough space in the buffer\_path
directory**. Running out of disk space is a problem frequently reported
by users.

## Parameters

### \@type (required)

The value must be `s3`.

### aws\_key\_id (required/optional)

The AWS access key id. This parameter is required when your agent is not
running on an EC2 instance with an IAM Instance Profile.

### aws\_sec\_key (required/optional)

The AWS secret key. This parameter is required when your agent is not
running on an EC2 instance with an IAM Instance Profile.

### s3\_bucket (required)

The Amazon S3 bucket name.

### buffer\_path (required)

The path prefix of the log buffer files.

### s3\_region

The Amazon S3 region name. Please select the appropriate region name and
confirm that your bucket has been created in the correct region. Here
are the region examples.

-   us-east-1
-   us-west-1
-   eu-central-1
-   ap-southeast-1
-   sa-east-1

The full list can be found [official AWS document](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region).

### s3\_endpoint

This option is deprecated because latest aws-sdk ignores this option.
Please use `s3_region` instead.

The Amazon S3 enpoint name. Please select the appropriate endpoint name
from the list below and confirm that your bucket has been created in the
correct region.

-   s3.amazonaws.com
-   s3-us-west-1.amazonaws.com
-   s3-us-west-2.amazonaws.com
-   s3.sa-east-1.amazonaws.com
-   s3-eu-west-1.amazonaws.com
-   s3-ap-southeast-1.amazonaws.com
-   s3-ap-northeast-1.amazonaws.com

The most recent versions of the endpoints can be found
[here](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region).

### format

The format of the S3 object. The default is `out_file`.

See [formatter article](/plugins/formatter/formatter-plugin-overview.md) for more detail.

### time\_format

The format of the time written in files. The default format is ISO-8601.

### path

The path prefix of the files on S3. The default is "" (no prefix).

The actual path on S3 will be:
"{path}{time\_slice\_format}\_{sequential\_index}.gz" (see
\`s3\_object\_key\_format\`)

### s3\_object\_key\_format

The actual S3 path. The default value is
%{path}%{time\_slice}\_%{index}.%{file\_extension}, which is
interpolated to the actual path (ex: Ruby's variable interpolation).

-   path: the value of the `path` parameter above
-   time\_slice: the time string as formatted by `time_slice_format`
-   index: the index for the given path. Incremented per buffer flush
-   file\_extension: as determined by the `store_as` parameter.

For example, if

-   `s3_object_key_format` is as default
-   `path` is "hello"
-   `time_slice_format` is "%Y%m%d"
-   `store_as` is "json"

Then, "hello20141111\_0.json" would be an example actual S3 path.

This parameter is for advanced users. Most users should NOT modify it.
Also, always make sure that %{index} appears in the customized
\`s3\_object\_key\_format\` (Otherwise, multiple buffer flushes within
the same time slice throws an error).

### utc

Uses UTC for path formatting. The default format is localtime.

### store\_as

The compression type. The default is "gzip", but you can also choose
"lzo", "json", or "txt".

### proxy\_uri

The proxy url. The default is nil.

### ssl\_verify\_peer

Verify SSL certificate of the endpoint. The default is true. Set false
when you want to ignore the endpoint SSL certificate.

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

The buffer type is `file` by default ([buf\_file](/plugins/buffer/buf_file.md)). The
`memory` ([buf\_memory](/plugins/buffer/buf_memory.md)) buffer type can be chosen as well.
If you use `file` buffer type, `buffer_path` parameter is required.

### buffer\_queue\_limit, buffer\_chunk\_limit

The length of the chunk queue and the size of each chunk, respectively.
Please see the [Buffer Plugin Overview](/plugins/buffer/buffer-plugin-overview.md) article
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

## Further Reading

This page doesn't describe all the possible configurations. If you want
to know about other configurations, please check the link below.

-   [fluent-plugin-s3 repository](https://github.com/fluent/fluent-plugin-s3)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
