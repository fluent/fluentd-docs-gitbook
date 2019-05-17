# exec Input Plugin

![](/images/plugins/input/exec.png)

The `in_exec` Input plugin executes external programs to receive or pull
event logs. It will then read TSV (tab separated values), JSON or
MessagePack from the stdout of the program.

You can run a program periodically or permanently. To run periodically,
please use the run\_interval parameter.


## Example Configuration

`in_exec` is included in Fluentd's core. No additional installation
process is required.

```
<source>
  @type exec
  command cmd arg arg
  <parse>
    keys k1,k2,k3
  </parse>
  <extract>
    tag_key k1
    time_key k2
    time_format %Y-%m-%d %H:%M:%S
  </extract>
  run_interval 10s
</source>
```

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.


## Plugin helpers

-   [compat\_parameters](/developer/api-plugin-helper-compat_parameters.md)
-   [extract](/developer/api-plugin-helper-extract.md)
-   [parser](/developer/api-plugin-helper-parser.md)
-   [child\_process](/developer/api-plugin-helper-child_process.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

### @type

The value must be `exec`.


### command

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.0  |

The command (program) to execute.


### tag

| type   | default                                       | version |
|:-------|:----------------------------------------------|:--------|
| string | required if extract/tag\_key is not specified | 0.14.0  |

Tag of the output events.


### run\_interval

| type | default | version |
|:-----|:--------|:--------|
| time | nil     | 0.14.0  |

The interval time between periodic program runs. If no specify value,
command script runs only once.


### read\_block\_size

| type | default | version |
|:-----|:--------|:--------|
| size | 10240   | 0.14.9  |

The default block size to read if parser requires partial read.


### &lt;parse&gt; section

| required | multi | version |
|:---------|:------|:--------|
| false    | false | 0.14.9  |

For more details about parse section, see followings

-   [Parser plugin overview](/plugins/parser/README.md)
-   [Parse section configuration](/configuration/parse-section.md)

#### @type

| type   | default | version |
|:-------|:--------|:--------|
| string | tsv     | 0.14.9  |

Overwrite default value in this plugin.

#### time\_type

| type   | default | version |
|:-------|:--------|:--------|
| string | float   | 0.14.9  |

Overwrite default value in this plugin.

#### time\_key

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.9  |

Overwrite default value in this plugin.

#### estimate\_current\_event

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.9  |

Overwrite default value in this plugin.


### &lt;extract&gt; section

| required | multi | version |
|:---------|:------|:--------|
| false    | false | 0.14.9  |

See [Extract section configurations](/configuration/extract-section.md)

#### time\_type

| type   | default | version |
|:-------|:--------|:--------|
| string | float   | 0.14.9  |

Overwrite default value in this plugin.


## Use Cases


### Monitor Load Averages

Here is a simple example to fetch load average stats on Linux systems.
This configuration instructs Fluentd to read `/proc/loadavg` once per
minute and emit the file content as events.

```
<source>
  @type exec
  tag system.loadavg
  command cat /proc/loadavg | cut -d ' ' -f 1,2,3
  run_interval 1m
  <parse>
    @type tsv
    keys avg1,avg5,avg15
    delimiter " "
  </parse>
</source>
```

This configuration emits events like below:

```
2018-06-29 17:27:35.115878527 +0900 system.loadavg: {"avg1":"0.30","avg5":"0.20","avg15":"0.05"}
```


### Real World Example: Scrape Hacker News Top Page

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

```
<source>
  @type exec
  <parse>
    @type json
  </parse>
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

```
2017-12-08 14:19:33.160567411 +0900 hackernews: {"time":1512710373,"rank":1,"title":"Japan eyes startup visa program","points":160,"user_name":"benguild","duration":"4 hours ago  ","num_comments":0,"unique_id":"item?id=15875627","hiring_notice":false}
2017-12-08 14:19:33.160735378 +0900 hackernews: {"time":1512710373,"rank":2,"title":"Bookbinding: A Tutorial","points":46,"user_name":"jstrieb","duration":"2 hours ago  ","num_comments":0,"unique_id":"item?id=15876260","hiring_notice":false}
2017-12-08 14:19:33.160769125 +0900 hackernews: {"time":1512710373,"rank":3,"title":"My Quadriplegic Husband and Me","points":92,"user_name":"mooreds","duration":"4 hours ago  ","num_comments":0,"unique_id":"item?id=15875772","hiring_notice":false}
2017-12-08 14:19:33.160799115 +0900 hackernews: {"time":1512710373,"rank":4,"title":"Wall Street banks hit pause button on Bitcoin","points":16,"user_name":"tadasv","duration":"1 hour ago  ","num_comments":0,"unique_id":"item?id=15876497","hiring_notice":false}
2017-12-08 14:19:33.160824386 +0900 hackernews: {"time":1512710373,"rank":5,"title":"A Spectator Who Threw a Wrench in the Waymo/Uber Lawsuit","points":107,"user_name":"kynthelig","duration":"4 hours ago  ","num_comments":0,"unique_id":"item?id=15875685","hiring_notice":false}
```

Of course, you can use Fluentd's many output plugins to store the data
into various backend systems like
[Elasticsearch](/guides/free-alternative-to-splunk-by-fluentd.md),
[HDFS](/guides/http-to-hdfs.md), [MongoDB](/guides/apache-to-mongodb.md), [AWS](/guides/apache-to-s3.md),
etc.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
