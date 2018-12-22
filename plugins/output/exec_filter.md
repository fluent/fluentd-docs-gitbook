# exec\_filter Output Plugin

![](/images/plugins/output/exec_filter.png)

The `out_exec_filter` Buffered Output plugin (1) executes an external
program using an event as input and (2) reads a new event from the
program output. It passes tab-separated values (TSV) to stdin and reads
TSV from stdout by default.


## Example Configuration

`out_exec_filter` is included in Fluentd's core. No additional
installation process is required.

``` {.CodeRay}
<match pattern>
  @type exec_filter
  command cmd arg arg
  in_keys k1,k2,k3
  out_keys k1,k2,k3,k4
  tag_key k1
  time_key k2
  time_format %Y-%m-%d %H:%M:%S
</match>
```
Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

## Parameters

### \@type (required)

The value must be `exec_filter`.

### command (required)

The command (program) to execute. The `out_exec_filter` plugin passes
the incoming event to the program input and receives the filtered event
from the program output.

### num\_children

The number of spawned process for `command`. Default is 1.

If the number is larger than 2, fluentd uses spawned processes by round
robin fashion.

### child\_respawn

Respawn command when command exit. Default is disabled.

If you specify a positive number, try to respawn until specified times.
If you specify `inf` or `-1`, try to respawn forever.

### in\_format

The format used to map the incoming event to the program input.

The following formats are supported:

-   tsv (default)

When using the tsv format, please also specify the comma-separated
`in_keys` parameter.

``` {.CodeRay}
in_keys k1,k2,k3
```

-   json
-   msgpack

### out\_format

The format used to process the program output.

The following formats are supported:

-   tsv (default)

When using the tsv format, please also specify the comma-separated
`out_keys` parameter.

``` {.CodeRay}
out_keys k1,k2,k3,k4
```

-   json
-   msgpack

When using the json format, this plugin uses the Yajl library to parse
the program output. Yajl buffers data internally so the output isn\'t
always instantaneous.

### tag\_key

The name of the key to use as the event tag. This replaces the value in
the event record.

### time\_key

The name of the key to use as the event time. This replaces the the
value in the event record.

### time\_format

The format for event time used when the `time_key` parameter is
specified. The default is UNIX time (integer).

## Buffered Output Parameters

For advanced usage, you can tune Fluentd's internal buffering mechanism
with these parameters.

### buffer\_type

The buffer type is `memory` by default ([buf\_memory](/plugins/buffer/memory.md)) for
the ease of testing, however `file` ([buf\_file](/plugins/buffer/file.md)) buffer type
is always recommended for the production deployments. If you use `file`
buffer type, `buffer_path` parameter is required.

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
values are 1.0 seconds and unset (no limit). The interval doubles (with
+/-12.5% randomness) every retry until `max_retry_wait` is reached.

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
Increasing the number of threads improves the flush throughput to hide
write / network latency. The default is 1.

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

Please see the [logging article](/deployment/logging.md) for further details.

## Script example

Here is an example writtein in ruby.

``` {.CodeRay}
require 'json'
require 'msgpack'

begin
  while line = STDIN.gets # continue to read a event from stdin
    line.chomp!

    # Input format depends on exec_filter's in_format setting
    json = JSON.parse(line)

    # main processing. You can do anything, mutate record, access to database and etc.
    json['new_field'] = "Hey from exec_filter script!"

    # Write data to stdout. Output format depends on exec_filter's out_format setting
    STDOUT.print MessagePack.pack(json)

    # Call flush to avoid buffering events
    STDOUT.flush
  end
rescue Interrupt # Ignore Interrupt exception because it happens during exec_filter shutdown
end
```

Corresponding configuration is below:

``` {.CodeRay}
<match test.**>
  @type exec_filter
  command ruby /path/to/ruby_script.rb
  in_format json
  out_format msgpack
  flush_interval 10s
  tag filtered.exec
</match>
```

If you want to use other language, translate above script example into
your language.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
