# exec Input Plugin

The `in_exec` Input plugin executes external programs to receive or pull
event logs. It will then read TSV (tab separated values), JSON or
MessagePack from the stdout of the program.

You can run a program periodically or permanently. To run periodically,
please use the run\_interval parameter.


## Example Configuration

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
Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

## Parameters

### \@type (required)

The value must be `exec`.

### command (required)

The command (program) to execute.

### format

The format used to map the program output to the incoming event.

The following formats are supported:

-   tsv (default)
-   json
-   msgpack
-   [parser plugin formats](/plugins/parser/parser-plugin-overview.md), e.g. ltsv, none.

When using the tsv format, please also specify the comma-separated
`keys` parameter.

``` {.CodeRay}
keys k1,k2,k3
```

When using the json format, this plugin uses the Yajl library to parse
the program output. Yajl buffers data internally so the output isn\'t
always instantaneous.

### tag (required if tag\_key is not specified)

tag of the output events.

### tag\_key

The key to use as the event tag instead of the value in the event
record. If this parameter is not specified, the `tag` parameter will be
used instead.

### time\_key

The key to use as the event time instead of the value in the event
record. If this parameter is not specified, the current time will be
used instead.

### time\_format

The format of the event time used for the time\_key parameter. The
default is UNIX time (integer).

### run\_interval

The interval time between periodic program runs. If no specify value,
command script runs only once.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.

## Real World Use Case: using in\_exec to scrape Hacker News Top Page

If you already have a script that runs periodically (say, via `cron`)
that you wish to store the output to multiple backend systems (HDFS,
AWS, Elasticsearch, etc.), in\_exec is a great choice.

The only requirement for the script is that it outputs TSV, JSON or
MessagePack.

For example, the [following script](https://gist.github.com/kiyoto/1bd903ad1bdd6ac51fcc) scrapes the
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
[Elasticsearch](/articles/free-alternative-to-splunk-by-fluentd.md),
[HDFS](/articles/http-to-hdfs.md), [MongoDB](/articles/apache-to-mongodb.md), [AWS](/articles/apache-to-s3.md),
etc.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
