# exec Output Plugin

The `out_exec` TimeSliced Output plugin passes events to an external
program. The program receives the path to a file containing the incoming
events as its last argument. The file format is tab-separated values
(TSV) by default.


## Example Configuration

`out_exec` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<match pattern>
  @type exec
  command cmd arg arg
  format tsv
  keys k1,k2,k3
  tag_key k1
  time_key k2
  time_format %Y-%m-%d %H:%M:%S
</match>
```
Please see the [Config File](/articles/config-file.md) article for the basic
structure and syntax of the configuration file.

## Example: Running FizzBuzz against data stream

This example illustrates how to run FizzBuzz with out\_exec.

We assume that the input file is specified by the last argument in the
command line ("ARGV\[-1\]"). The following script `fizzbuzz.py` runs
[FizzBuzz](http://en.wikipedia.org/wiki/Fizz_buzz) against the new-line
delimited sequence of natural numbers (1, 2, 3...) and writes the output
to "foobar.out".

``` {.CodeRay}
#!/usr/bin/env python
import sys
input = file(sys.argv[-1])
output = file("foobar.out", "a")
for line in input:
    fizzbuzz = int(line.split("\t")[0])
    s = ''
    if fizzbuzz%3 == 0:
        s += 'fizz'
    if fizzbuzz%5 == 0:
        s += 'buzz'
    if len(s) > 0:
        output.write(s+"\n")
    else:
        output.write(str(fizzbuzz)+"\n")
output.close
```

Note that this program is written in Python. For out\_exec (as well as
out\_exec\_filter and in\_exec), **the program can be written in any
language, not just Ruby.**

Then, configure Fluentd as follows

``` {.CodeRay}
<source>
  @type forward
</source>
<match fizzbuzz>
  @type exec
  command python /path/to/fizzbuzz.py
  buffer_path    /path/to/buffer_path
  format tsv
  keys fizzbuzz
  flush_interval 5s # for debugging/checking
</match>
```

The "format tsv" and "keys fizzbuzz" tells Fluentd to extract the
"fizzbuzz" field and output it as TSV. This simple example has a single
key, but you can of course extract multiple fields and use "format json"
to output newline-delimited JSONs.

The intermediary TSV is at `buffer_path`, and the command
`python /path/to/fizzbuzz.py /path/to/buffer_path` is run. This is why
in `fizzbuzz.py`, it's reading the file at `sys.argv[-1]`.

If you start Fluentd and run

``` {.CodeRay}
$ for i in `seq 15`; do echo "{\"fizzbuzz\":$i}" | fluent-cat fizzbuzz; done
```

Then, after 5 seconds, you get a file named `foobar.out`.

``` {.CodeRay}
$ cat foobar.out
1
2
fizz
4
buzz
fizz
7
8
fizz
buzz
11
fizz
13
14
fizzbuzz
```

## Parameters

### \@type (required)

The value must be `exec`.

### command (required)

The command (program) to execute. The exec plugin passes the path of a
TSV file as the last argument.

### format

The format used to map the incoming events to the program input.

The following formats are supported:

-   tsv (default)

When using the tsv format, please also specify the comma-separated
`keys` parameter.

``` {.CodeRay}
keys k1,k2,k3
```

-   json
-   msgpack

### tag\_key

The name of the key to use as the event tag. This replaces the value in
the event record.

### time\_key

The name of the key to use as the event time. This replaces the the
value in the event record.

### time\_format

The format for event time used when the `time_key` parameter is
specified. The default is UNIX time (integer).

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

The buffer type is `file` by default ([buf\_file](/articles/buf_file.md)). The
`memory` ([buf\_memory](/articles/buf_memory.md)) buffer type can be chosen as well.
If you use `file` buffer type, `buffer_path` parameter is required.

### buffer\_queue\_limit, buffer\_chunk\_limit

The length of the chunk queue and the size of each chunk, respectively.
Please see the [Buffer Plugin Overview](/articles/buffer-plugin-overview.md) article
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

Please see the [logging article](/articles/logging.md) for further details.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
