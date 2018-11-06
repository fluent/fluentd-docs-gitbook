::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_mongo) \| ***v0.12*
(td-agent2) **
:::
:::

------------------------------------------------------------------------

MongoDB Output Plugin
=====================

The `out_mongo` Buffered Output plugin writes records into
[MongoDB](http://mongodb.org/), the emerging document-oriented database
system.
:::
:::
:::

If you\'re using ReplicaSet, please see the
[out\_mongo\_replset](out_mongo_replset) article instead.

This document doesn\'t describe all parameters. If you want to know full
features, check the Further Reading section.

[]{#why-fluentd-with-mongodb?}

::: {#table-of-contents .section}
### Table of Contents

[Why Fluentd with MongoDB?](#why-fluentd-with-mongodb?)

[Install](#install)

[Example Configuration](#example-configuration)

[Parameters](#parameters)

-   [type (required)](#type-(required))
-   [host (required)](#host-(required))
-   [port (required)](#port-(required))
-   [database (required)](#database-(required))
-   [collection (required, if not
    tag\_mapped)](#collection-(required,-if-not-tag_mapped))
-   [capped](#capped)
-   [user](#user)
-   [password](#password)
-   [time\_key](#time_key)
-   [tag\_mapped](#tag_mapped)

[Buffered Output Parameters](#buffered-output-parameters)

-   [buffer\_type](#buffer_type)
-   [buffer\_queue\_limit,
    buffer\_chunk\_limit](#buffer_queue_limit,-buffer_chunk_limit)
-   [flush\_interval](#flush_interval)
-   [flush\_at\_shutdown](#flush_at_shutdown)
-   [retry\_wait, max\_retry\_wait](#retry_wait,-max_retry_wait)
-   [retry\_limit,
    disable\_retry\_limit](#retry_limit,-disable_retry_limit)
-   [num\_threads](#num_threads)
-   [slow\_flush\_log\_threshold](#slow_flush_log_threshold)

[Further Reading](#further-reading)
:::

Why Fluentd with MongoDB?
-------------------------

Fluentd enables your apps to insert records to MongoDB asynchronously
with batch-insertion, unlike direct insertion of records from your apps.
This has the following advantages:

1.  less impact on application performance
2.  higher MongoDB insertion throughput while maintaining JSON record
    structure

[]{#install}

Install
-------

`out_mongo` is included in td-agent by default. Fluentd gem users will
need to install the fluent-plugin-mongo gem using the following command.

``` {.CodeRay}
$ fluent-gem install fluent-plugin-mongo
```

[]{#example-configuration}

Example Configuration
---------------------

``` {.CodeRay}
# Single MongoDB
<match mongo.**>
  @type mongo
  host fluentd
  port 27017
  database fluentd
  collection test

  # for capped collection
  capped
  capped_size 1024m

  # authentication
  user michael
  password jordan

  # key name of timestamp
  time_key time

  # flush
  flush_interval 10s
</match>
```

Please see the [Store Apache Logs into MongoDB](apache-to-mongodb)
article for real-world use cases.

Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

[]{#parameters}

Parameters
----------

[]{#type-(required)}

### type (required)

The value must be `mongo`.

[]{#host-(required)}

### host (required)

The MongoDB hostname.

[]{#port-(required)}

### port (required)

The MongoDB port.

[]{#database-(required)}

### database (required)

The database name.

[]{#collection-(required,-if-not-tag_mapped)}

### collection (required, if not tag\_mapped)

The collection name.

[]{#capped}

### capped

This option enables capped collection. This is always recommended
because MongoDB is not suited to storing large amounts of historical
data.

#### capped\_size

Sets the capped collection size.

[]{#user}

### user

The username to use for authentication.

[]{#password}

### password

The password to use for authentication.

[]{#time_key}

### time\_key

The key name of timestamp. (default is "time")

[]{#tag_mapped}

### tag\_mapped

This option will allow out\_mongo to use Fluentd's tag to determine the
destination collection. For example, if you generate records with tags
'mongo.foo', the records will be inserted into the `foo` collection
within the `fluentd` database.

``` {.CodeRay}
<match mongo.*>
  @type mongo
  host fluentd
  port 27017
  database fluentd

  # Set 'tag_mapped' if you want to use tag mapped mode.
  tag_mapped

  # If the tag is "mongo.foo", then the prefix "mongo." is removed.
  # The inserted collection name is "foo".
  remove_tag_prefix mongo.

  # This configuration is used if the tag is not found. The default is 'untagged'.
  collection misc
</match>
```

This option is useful for flexible log collection.

[]{#buffered-output-parameters}

Buffered Output Parameters
--------------------------

For advanced usage, you can tune Fluentd's internal buffering mechanism
with these parameters.

[]{#buffer_type}

### buffer\_type

The buffer type is `memory` by default ([buf\_memory](buf_memory)) for
the ease of testing, however `file` ([buf\_file](buf_file)) buffer type
is always recommended for the production deployments. If you use `file`
buffer type, `buffer_path` parameter is required.

[]{#buffer_queue_limit,-buffer_chunk_limit}

### buffer\_queue\_limit, buffer\_chunk\_limit

The length of the chunk queue and the size of each chunk, respectively.
Please see the [Buffer Plugin Overview](buffer-plugin-overview) article
for the basic buffer structure. The default values are 64 and 8m,
respectively. The suffixes "k" (KB), "m" (MB), and "g" (GB) can be used
for buffer\_chunk\_limit.

[]{#flush_interval}

### flush\_interval

The interval between data flushes. The default is 60s. The suffixes "s"
(seconds), "m" (minutes), and "h" (hours) can be used.

[]{#flush_at_shutdown}

### flush\_at\_shutdown

If set to true, Fluentd waits for the buffer to flush at shutdown. By
default, it is set to true for Memory Buffer and false for File Buffer.

[]{#retry_wait,-max_retry_wait}

### retry\_wait, max\_retry\_wait

The initial and maximum intervals between write retries. The default
values are 1.0 seconds and unset (no limit). The interval doubles (with
+/-12.5% randomness) every retry until `max_retry_wait` is reached.

Since td-agent will retry 17 times before giving up by default (see the
`retry_limit` parameter for details), the sleep interval can be up to
approximately 131072 seconds (roughly 36 hours) in the default
configurations.

[]{#retry_limit,-disable_retry_limit}

### retry\_limit, disable\_retry\_limit

The limit on the number of retries before buffered data is discarded,
and an option to disable that limit (if true, the value of `retry_limit`
is ignored and there is no limit). The default values are 17 and false
(not disabled). If the limit is reached, buffered data is discarded and
the retry interval is reset to its initial value (`retry_wait`).

[]{#num_threads}

### num\_threads

The number of threads to flush the buffer. This option can be used to
parallelize writes into the output(s) designated by the output plugin.
Increasing the number of threads improves the flush throughput to hide
write / network latency. The default is 1.

[]{#slow_flush_log_threshold}

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

Please see the [logging article](logging) for further details.

[]{#further-reading}

Further Reading
---------------

-   [fluent-plugin-mongo
    repository](https://github.com/fluent/fluent-plugin-mongo)

::: {style="text-align:right"}
Last updated: 2015-12-01 21:20:32 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/out_mongo) \| ***v0.12*
(td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
