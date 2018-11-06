::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/in_exec) \| ***v0.12*
(td-agent2) **
:::
:::

------------------------------------------------------------------------

exec Input Plugin
=================

The `in_exec` Input plugin executes external programs to receive or pull
event logs. It will then read TSV (tab separated values), JSON or
MessagePack from the stdout of the program.

You can run a program periodically or permanently. To run periodically,
please use the run\_interval parameter.


### Table of Contents

[Example Configuration](#example-configuration)

[Parameters](#parameters)

-   [\@type (required)](#@type-(required))
-   [command (required)](#command-(required))
-   [format](#format)
-   [tag (required if tag\_key is not
    specified)](#tag-(required-if-tag_key-is-not-specified))
-   [tag\_key](#tag_key)
-   [time\_key](#time_key)
-   [time\_format](#time_format)
-   [run\_interval](#run_interval)

[Real World Use Case: using in\_exec to scrape Hacker News Top
Page](#real-world-use-case:-using-in_exec-to-scrape-hacker-news-top-page)
:::

Example Configuration
---------------------

`in_exec` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<source>
  @type exec
  command cmd arg arg
  keys k1,k2,k3
  tag_key k1
  time_key k2
  time_format %Y-%m-%d %H:%M:%S
  run_interval 10s
</source>
```
:::
:::
:::

Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

[]{#parameters}

Parameters
----------

[]{#@type-(required)}

### \@type (required)

The value must be `exec`.

[]{#command-(required)}

### command (required)

The command (program) to execute.

[]{#format}

### format

The format used to map the program output to the incoming event.

The following formats are supported:

-   tsv (default)
-   json
-   msgpack
-   [parser plugin formats](parser-plugin-overview), e.g. ltsv, none.

When using the tsv format, please also specify the comma-separated
`keys` parameter.

``` {.CodeRay}
keys k1,k2,k3
```

When using the json format, this plugin uses the Yajl library to parse
the program output. Yajl buffers data internally so the output isn\'t
always instantaneous.

[]{#tag-(required-if-tag_key-is-not-specified)}

### tag (required if tag\_key is not specified)

tag of the output events.

[]{#tag_key}

### tag\_key

The key to use as the event tag instead of the value in the event
record. If this parameter is not specified, the `tag` parameter will be
used instead.

[]{#time_key}

### time\_key

The key to use as the event time instead of the value in the event
record. If this parameter is not specified, the current time will be
used instead.

[]{#time_format}

### time\_format

The format of the event time used for the time\_key parameter. The
default is UNIX time (integer).

[]{#run_interval}

### run\_interval

The interval time between periodic program runs. If no specify value,
command script runs only once.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.

[]{#real-world-use-case:-using-in_exec-to-scrape-hacker-news-top-page}

Real World Use Case: using in\_exec to scrape Hacker News Top Page
------------------------------------------------------------------

If you already have a script that runs periodically (say, via `cron`)
that you wish to store the output to multiple backend systems (HDFS,
AWS, Elasticsearch, etc.), in\_exec is a great choice.

The only requirement for the script is that it outputs TSV, JSON or
MessagePack.

For example, the [following
script](https://gist.github.com/kiyoto/1bd903ad1bdd6ac51fcc) scrapes the
front page of [Hacker News](http://news.ycombinator.com) and scrapes
information about each post:

Suppose that script is called `hn.rb`. Then, you can run it every 5
minutes with the following configuration

``` {.CodeRay}
<source>
  @type exec
  format json
  tag hackernews
  command ruby /path/to/hn.rb
  run_interval 5m # don't hit HN too frequently!
</source>
<match hackernews>
  @type stdout
</match>
```

And if you run Fluentd with it, you will see the following output (if
you are impatient, ctrl-C to flush the stdout buffer)

``` {.CodeRay}
2014-05-26 21:51:35 +0000 hackernews: {"time":1401141095,"rank":1,"title":"Rap Genius Co-Founder Moghadam Fired","points":128,"user_name":"obilgic","duration":"2 hours ago  ","num_comments":108}
2014-05-26 21:51:35 +0000 hackernews: {"time":1401141095,"rank":2,"title":"Whitewood Under Siege: Wooden Shipping Pallets","points":128,"user_name":"drjohnson","duration":"3 hours ago  ","num_comments":20}
2014-05-26 21:51:35 +0000 hackernews: {"time":1401141095,"rank":3,"title":"Organic Cat Litter Chief Suspect In Nuclear Waste Accident","points":55,"user_name":"timr","duration":"2 hours ago  ","num_comments":12}
2014-05-26 21:51:35 +0000 hackernews: {"time":1401141095,"rank":4,"title":"Do We Really Know What Makes Us Healthy? (2007)","points":27,"user_name":"gwern","duration":"1 hour ago  ","num_comments":9}
```

Of course, you can use Fluentd's many output plugins to store the data
into various backend systems like
[Elasticsearch](free-alternative-to-splunk-by-fluentd),
[HDFS](http-to-hdfs), [MongoDB](apache-to-mongodb), [AWS](apache-to-s3),
etc.

::: {style="text-align:right"}
Last updated: 2016-07-26 23:53:19 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/in_exec) \| ***v0.12*
(td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
