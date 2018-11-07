memory Buffer Plugin
====================

The `memory` buffer plugin provides a fast buffer implementation. It
uses memory to store buffer chunks. When Fluentd is shut down, buffered
logs that can't be written quickly are deleted.


Example Config
--------------

``` {.CodeRay}
<match pattern>
  buffer_type memory
</match>
```
Please see the [Config File](config-file.md) article for the basic
structure and syntax of the configuration file.

Parameters
----------

#### buffer\_type (required)

The value must be `memory`.

#### buffer\_chunk\_limit

The size of each buffer chunk. The default is 8m. The suffixes "k" (KB),
"m" (MB), and "g" (GB) can be used. Please see the [Buffer Plugin
Overview](buffer-plugin-overview) article for the basic buffer
structure.

#### buffer\_queue\_limit

The length limit of the chunk queue. Please see the [Buffer Plugin
Overview](buffer-plugin-overview) article for the basic buffer
structure. The default limit is 64 chunks.

#### flush\_interval

The interval between data flushes. The suffixes "s" (seconds), "m"
(minutes), and "h" (hours) can be used

#### flush\_at\_shutdown

If true, queued chunks are flushed at shutdown process. The default is
`true`. If false, queued chunks are discarded unlike `buf_file`.

#### retry\_wait

The interval between retries. The suffixes "s" (seconds), "m" (minutes),
and "h" (hours) can be used.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
