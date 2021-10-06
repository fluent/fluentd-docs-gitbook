# Send Syslog Data to InfluxDB

This article shows how to collect `syslog` data into [InfluxDB](http://github.com/influxdb/influxdb) using Fluentd.

![Syslog + Fluentd + InfluxDB](../.gitbook/assets/syslog-fluentd-influxdb.png)

## Prerequisites

* A basic understanding of Fluentd
* A running instance of `rsyslogd`

**In this guide, we assume we are running `td-agent` \(Fluentd package for Linux and macOS\) on Ubuntu Xenial.**

## Step 1: Install InfluxDB

InfluxDB supports Ubuntu, RedHat and macOS \(via `brew`\).

For more details, see [here](http://influxdb.com/download/).

Since we are assumed to be on Ubuntu, the following two lines install InfluxDB:

```text
$ wget https://dl.influxdata.com/influxdb/releases/influxdb_1.7.3_amd64.deb
$ sudo dpkg -i influxdb_1.7.3_amd64.deb
```

Once it is installed, you can run it with:

```text
$ sudo systemctl start influxdb
```

Then, you can verify that InfluxDB is running:

```text
$ curl "http://localhost:8086/query?q=show+databases"
```

If InfluxDB is running normally, you will see an object that contains the `_internal` database:

```javascript
{"results":[{"statement_id":0,"series":[{"name":"databases","columns":["name"],"values":[["_internal"]]}]}]}
```

Also, the following two lines install Chronograf:

```text
$ wget https://dl.influxdata.com/chronograf/releases/chronograf_1.7.7_amd64.deb
$ sudo dpkg -i chronograf_1.7.7_amd64.deb
```

Once it is installed, you can run it with:

```text
$ sudo systemctl start chronograf
```

Then, go to localhost:8888 \(or wherever you are hosting Chronograf\) to access Chronograf's web console which is the successor to InfluxDB's web console.

Create a database called `test`. This is where we will be storing `syslog` data:

```text
$ curl -i -XPOST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE test"
```

If you prefer command line or cannot access port 8083 from your local machine, running the following command creates a database called `test`:

```text
$ curl -i -X POST 'http://localhost:8086/write?db=test' --data-binary 'task,host=server01,region=us-west value=1 1434055562000000000'
```

We are done for now.

## Step 2: Install Fluentd and the InfluxDB plugin

On your aggregator server, set up Fluentd.

For more details, see [here](https://www.fluentd.org/download).

```text
$ curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent3.sh | sh
```

Next, install the InfluxDB output plugin:

```text
/usr/sbin/td-agent-gem install fluent-plugin-influxdb
```

For the vanilla Fluentd, run:

```text
fluent-gem install fluent-plugin-influxdb
```

You might need `sudo` to install the plugin.

Finally, configure `/etc/td-agent/td-agent.conf` as follows:

```text
<source>
  @type syslog
  port 42185
  tag system
</source>

<match system.*.*>
  @type influxdb
  dbname test
  flush_interval 10s # for testing
  host YOUR_INFLUXDB_HOST # default: localhost
  port YOUR_INFLUXDB_PORT # default: 8086
</match>
```

Restart `td-agent` with `sudo service td-agent restart`.

## Step 3: Configure `rsyslogd`

If remote `rsyslogd` instances are already collecting data into the aggregator `rsyslogd`, the settings for `rsyslog` should remain unchanged. However, if this is a brand new setup, start forward `syslog` output by adding the following line to `/etc/rsyslogd.conf`:

```text
*.* @182.39.20.2:42185
```

You should replace `182.39.20.2` with the IP address of your aggregator server. Also, there is nothing special about port `42185` \(do make sure this port is open though\).

Now, restart `rsyslogd`:

```text
$ sudo systemctl restart rsyslog
```

## Step 4: Confirm Data Flow

Your `syslog` data should be flowing into InfluxDB every 10 seconds \(this is configured by `flush_interval`\).

Clicking on `Explore` brings up the query interface that **lets you write SQL queries against your log data**.

And then click `Visualization` and select the line chart:

![Chronograf: Explore Data](../.gitbook/assets/chronograf-explore-data.png)

Now, to count the number of lines of `syslog` messages per facility/priority:

```sql
SELECT COUNT(ident) FROM test.autogen./^system\./ GROUP BY time(1s)
```

Click on **Submit Query** to get a graph like this:

![Chronograf: Query](../.gitbook/assets/chronograf-query.png)

Here is another screenshot for the `system.daemon.info` series:

![Chronograf: Query](../.gitbook/assets/chronograf-query-2.png)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

