# Stream Processing with Norikra

This article explains how to use [Fluentd](https://www.fluentd.org/) and [Norikra](https://norikra.github.io) to create a SQL-based realtime complex event processing platform.

## Background

[Fluentd](https://www.fluentd.org/) is an advanced open-source log collector originally developed at [Treasure Data, Inc](https://www.treasuredata.com/). Fluentd is not only a log collector, but also an all-purpose stream processing platform. Plugins can be written to handle many kinds of events.

However, Fluentd is not primarily designed for stream processing. We must restart Fluentd after making modifications to its configuration/code, making it unsuitable for running _both_ short-span \(seconds or minutes\) calculations and long-span \(hours or days\) calculations. If we restart Fluentd to perform a short-span calculation, all existing internal statuses of short and long span calculations are lost. For large scale stream processing platforms, code/processes must be added/removed without any such losses.

[Norikra](https://norikra.github.io/) is an open-source stream processing server based on [Esper](https://github.com/espertechinc/esper) by [EsperTech](https://www.espertech.com/). It allows you to subscribe/unsubscribe to data streams anytime and add/remove SQL queries anytime. [Norikra](https://norikra.github.io/) is written by [@tagomoris](https://github.com/tagomoris), a committer of the Fluentd project.

This article will show you how to integrate [Fluentd](https://fluentd.org/), [Norikra](https://norikra.github.io/), and the [Fluentd norikra plugin](https://github.com/norikra/fluent-plugin-norikra) to create a robust stream data processing platform.

## Architecture

The figure below shows the high-level architecture:

![Fluentd + Norikra Overview](../.gitbook/assets/fluentd-norikra-overview%20%281%29%20%282%29.png)

## Prerequisites

The following software/services are required to be set up correctly:

* [Fluentd](https://fluentd.org/)
* [Fluentd Norikra Plugin](https://github.com/norikra/fluent-plugin-norikra/)
* [Norikra](https://norikra.github.io/)

You can install Fluentd via major packaging systems.

* [Installation](../installation/)

### Installing Fluentd Norikra Plugin

If `out_norikra` (fluent-plugin-norikra) is not installed yet, please install it manually.

See [Plugin Management](../installation/post-installation-guide#plugin-management) section how to install fluent-plugin-norikra on your environment.

### Installing Norikra

Norikra requires JRuby. You can download the JRuby binary directly from the [official site](https://www.jruby.org/download) and export the PATH of `JRUBY_INSTALL_DIRECTORY/bin`.

Once JRuby is set up, install Norikra:

```text
jgem install norikra
```

### Verify Installation

We'll start the Norikra server after installation. The `norikra start` command will launch the Norikra server in your console.

```text
....
2014-05-20 20:36:01 +0900 [INFO] : Loading UDF plugins
2014-05-20 20:36:01 +0900 [INFO] : RPC server 0.0.0.0:26571, 2 threads
2014-05-20 20:36:01 +0900 [INFO] : WebUI server 0.0.0.0:26578, 2 threads
2014-05-20 20:36:01 +0900 [INFO] : Norikra server started.
```

You can also check the current Norikra's status via the WebUI \([http://localhost:26578/](http://localhost:26578/)\).

## Fluentd Configuration

We'll now configure Fluentd. If you used the deb/rpm package, Fluentd's config file is located at `/etc/fluent/fluentd.conf`.

### HTTP Input

For the input source, we will set up Fluentd to accept records from HTTP. The Fluentd configuration file should look like this:

```text
<source>
  @type http
  port 8888
</source>
```

### Norikra Output

The output destination will be Norikra. The output configuration should look like this:

```text
<match data.*>
  @type norikra
  norikra localhost:26571
  target_map_tag true
  remove_tag_prefix data

  <default>
    include *
    exclude time
  </default>
</match>
```

The `<match>` section specifies the glob pattern used to look for the matching tags. If the tag of a log is matched, the respective `match` configuration is used \(i.e. the log is routed accordingly\).

The `norikra` attribute specifies the Norikra server's RPC host and port \(default: `26571`\). By `target_map_tag true` and `remove_tag_prefix data`, `out_norikra` handle the rest of tags \(e.g. `foo` for `data.foo`\) as the target, which is the name of the set of events as same as table name of RDBMS.

The `<default>` section specifies which fields are sent to the Norikra server. We can also specify these sets per target with `<target NAME>...</target>`. For more details, refer to [`fluent-plugin-norikra`](https://github.com/norikra/fluent-plugin-norikra).

## Test

To test the configuration, just post the JSON to Fluentd \(we use the `curl` command in this example\):

```text
$ curl -X POST -d 'json={"action":"login","user":2}' \
  http://localhost:8888/data.access
```

Norikra's console log will show that Fluentd has opened the target `access` and sent a message with fields of `action` and `user`.

```text
2014-05-20 20:43:22 +0900 [INFO] : opening target, target:"access", fields:{}, auto_field:true
2014-05-20 20:43:23 +0900 [INFO] : opening lazy target, target:#<Norikra::Target:0x69c04611 @last_modified=nil, @fields={}, @name="access", @auto_field=true>
2014-05-20 20:43:23 +0900 [INFO] : target successfully opened (snip)
```

We can check its fields with `norikra-client` command from the console that has the `PATH` to JRuby:

```text
$ norikra-client target list
TARGET  AUTO_FIELD
access  true
1 targets found.
$ norikra-client field list access
FIELD   TYPE    OPTIONAL
action  string  false
user    integer false
2 fields found.
```

### Registering Queries and Fetching Outputs

We can add queries on opened targets via the WebUI or CLI. The following query \(just SQL!\) counts the number of events with a non-zero `user` per 10 second interval, with a 'group by' `action`:

```text
SELECT
  action,
  count(*) AS c
FROM access.win:time_batch(10 sec)
WHERE user != 0
GROUP BY action
```

To register a query, issue `norikra-client query add` on the CLI:

```text
$ norikra-client query add test_query "SELECT action, count(*) AS c FROM access.win:time_batch(10 sec) WHERE user != 0 GROUP BY action"
$ norikra-client query list
NAME    GROUP   TARGETS QUERY
test_query  default access  SELECT action, count(*) AS c FROM access.win:time_batch(10 sec) WHERE user != 0 GROUP BY action
1 queries found.
```

Once the query has been registered, post the events that you want:

```text
$ curl -X POST -d 'json={"action":"login","user":2}' \
  http://localhost:8888/data.access
$ curl -X POST -d 'json={"action":"login","user":0}' \
  http://localhost:8888/data.access
$ curl -X POST -d 'json={"action":"write","user":2}' \
  http://localhost:8888/data.access
$ curl -X POST -d 'json={"action":"save","user":2}' \
  http://localhost:8888/data.access
$ curl -X POST -d 'json={"action":"logout","user":2}' \
  http://localhost:8888/data.access
$ curl -X POST -d 'json={"action":"logout","user":0}' \
  http://localhost:8888/data.access
$ curl -X POST -d 'json={"action":"login","user":2}' \
  http://localhost:8888/data.access
```

And fetch output events from this `test_query` query:

```text
$ norikra-client event fetch test_query
{"time":"2014/05/20 21:00:24","c":1,"action":"logout"}
{"time":"2014/05/20 21:00:24","c":1,"action":"save"}
{"time":"2014/05/20 21:00:24","c":1,"action":"write"}
{"time":"2014/05/20 21:00:24","c":2,"action":"login"}
{"time":"2014/05/20 21:00:34","c":0,"action":"logout"}
{"time":"2014/05/20 21:00:34","c":0,"action":"save"}
{"time":"2014/05/20 21:00:34","c":0,"action":"write"}
{"time":"2014/05/20 21:00:34","c":0,"action":"login"}
$
```

If posts are done in 10 seconds, this query calculates all the events in first 10 seconds, and counts events per `action` for events with `user != 0` only, and outputs events at "2014/05/20 21:00:24". At "2014/05/20 21:00:34", just after next 10 seconds, this query reports that no events arrived \(These are teardown records, and reported only once\).

## Conclusion

We can create a stream data processing platform without any schema definitions, using Fluentd and Norikra. This platform enables an agile stream processing environment that can handle real workloads.

## Learn More

* [Fluentd Architecture](https://www.fluentd.org/architecture)
* [Fluentd Get Started](../quickstart/)
* [Norikra: Query Syntax](https://norikra.github.io/query.html)
* [Norikra: Query Examples](https://norikra.github.io/examples.html)
* [Slides: fluent-plugin-norikra](https://www.slideshare.net/tagomoris/fluentpluginnorikra-fluentdcasual)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

