file Buffer Plugin
==================

The `file` buffer plugin provides a persistent buffer implementation. It
uses files to store buffer chunks on disk.

[]{#example-config}

::: {#table-of-contents .section}
### Table of Contents

-   [Example Config](#example-config)
-   [Parameters](#parameters)
-   [Caution](#caution)
:::

Example Config
--------------

``` {.CodeRay}
<match pattern>
  buffer_type file
  buffer_path /var/log/fluent/myapp.*.buffer
</match>
```

Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

[]{#parameters}

Parameters
----------

#### buffer\_type (required)

The value must be `file`.

#### buffer\_path (required)

The path where buffer chunks are stored. The '\*' is replaced with
random characters. This parameter is require

This parameter must be unique to avoid race condition problem. For
example, you can't use fixed buffer\_path parameter in
fluent-plugin-forest. `${tag}` or similar placeholder is needed. Of
course, this parameter must also be unique between fluentd instances.

In addition, `buffer_path` should not be an other `buffer_path` prefix.
For example, the following conf doesn't work well. `/var/log/fluent/foo`
resumes `/var/log/fluent/foo.bar`'s buffer files during start phase and
it causes `No such file or directory` in `/var/log/fluent/foo.bar` side.

``` {.CodeRay}
<match pattern1>
    buffer_path /var/log/fluent/foo
</match>

<match pattern2>
    buffer_path /var/log/fluent/foo.bar
</match>
```

Here is the correct version to avoid prefix problem.

``` {.CodeRay}
<match pattern1>
    buffer_path /var/log/fluent/foo.baz
</match>

<match pattern2>
    buffer_path /var/log/fluent/foo.bar
</match>
```

#### buffer\_chunk\_limit

The size of each buffer chunk. The default is 8m. The suffixes "k" (KB),
"m" (MB), and "g" (GB) can be used. Please see the [Buffer Plugin
Overview](buffer-plugin-overview) article for the basic buffer
structure.

The default value for Time Sliced Plugin is overwritten as 256m.

#### buffer\_queue\_limit

The length limit of the chunk queue. Please see the [Buffer Plugin
Overview](buffer-plugin-overview) article for the basic buffer
structure. The default limit is 256 chunks.

#### flush\_interval

The interval between data flushes. The suffixes "s" (seconds), "m"
(minutes), and "h" (hours) can be used

#### flush\_at\_shutdown

If true, queued chunks are flushed at shutdown process. The default is
`false`.

#### retry\_wait

The interval between retries. The suffixes "s" (seconds), "m" (minutes),
and "h" (hours) can be used.

Limitation

[]{#caution}

Caution
-------

`file` buffer implementation depends on the characteristics of local
file system. Don't use `file` buffer on remote file system, e.g. NFS,
GlusterFS, HDFS and etc. We observed major data loss by using remote
file system.

::: {style="text-align:right"}
Last updated: 2016-12-07 10:53:25 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/buf_file) \| ***v0.12*
(td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
