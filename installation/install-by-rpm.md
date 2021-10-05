# Install by RPM Package \(Red Hat Linux\)

This article explains how to install the `td-agent` rpm package, the stable Fluentd distribution package maintained by [Treasure Data, Inc](http://www.treasuredata.com/).

## What is `td-agent`?

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon.

That is why [Treasure Data, Inc](http://www.treasuredata.com/) provides **the stable distribution of Fluentd**, called `td-agent`. The differences between Fluentd and `td-agent` can be found [here](https://www.fluentd.org/faqs).

## What is `calyptia-fluentd`?

Our Calyptia also knows that Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon. And `td-agent` is still seated on Ruby 2.7 due to compatibility reasons and Ruby versioning policy, `calyptia-fluentd` uses Ruby 3 instead of Ruby 2.7 for now.

That is why [Calyptia, Inc.](https://www.calyptia.com/) provides **the alternative stable distribution of Fluentd**, called `calyptia-fluentd`. The differences between `td-agent` and `calyptia-fluentd` are bundled and running Ruby versions for now.

This installation guide is for `td-agent` v3/v4 and `calyptia-fluentd` v1. `td-agent` v3/v4 and `calyptia-fluentd` use fluentd v1 in the core. See [this page](../quickstart/td-agent-v2-vs-v3-vs-v4.md) for the comparison and supported OS.

## Using to install `td-agent`

### Step 0: Before Installation

Please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

### Step 1: Install from `rpm` Repository

It is highly recommended to set up `ntpd` on the node to prevent invalid timestamps in the logs. See [Pre-installation Guide](before-install.md).

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.

#### Red Hat / CentOS

Download and execute the install script with `curl`:

```text
# td-agent 4
$ curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent4.sh | sh

# td-agent 3
$ curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
```

Executing this script will automatically install `td-agent` on your machine. This shell script registers a new `rpm` repository at `/etc/yum.repos.d/td.repo` and installs `td-agent`.

We use `$releasever` for repository path in the script and `$releasever` should be the major version only like `"7"`. If your environment uses some other format like `"7.2"`, change it to the major version only or set up TD repository manually.

#### Amazon Linux

For Amazon Linux 2:

```text
# td-agent 4
$ curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent4.sh | sh

# td-agent 3
$ curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent3.sh | sh
```

### Step 2: Launch Daemon

`td-agent` provides two \(2\) scripts:

#### `systemd`

Use `/usr/lib/systemd/system/td-agent` script to `start`, `stop`, or `restart` the agent:

```text
$ sudo systemctl start td-agent.service
$ sudo systemctl status td-agent.service
● td-agent.service - td-agent: Fluentd based data collector for Treasure Data
   Loaded: loaded (/lib/systemd/system/td-agent.service; disabled; vendor preset: enabled)
   Active: active (running) since Thu 2017-12-07 15:12:27 PST; 6min ago
     Docs: https://docs.treasuredata.com/articles/td-agent
  Process: 53192 ExecStart = /opt/td-agent/embedded/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/td-agent.pid (code = exited, statu
 Main PID: 53198 (fluentd)
   CGroup: /system.slice/td-agent.service
           ├─53198 /opt/td-agent/embedded/bin/ruby /opt/td-agent/embedded/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/td-agent
           └─53203 /opt/td-agent/embedded/bin/ruby -Eascii-8bit:ascii-8bit /opt/td-agent/embedded/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /v

Dec 07 15:12:27 ubuntu systemd[1]: Starting td-agent: Fluentd based data collector for Treasure Data...
Dec 07 15:12:27 ubuntu systemd[1]: Started td-agent: Fluentd based data collector for Treasure Data.
```

To customize `systemd` behavior, put your `td-agent.service` in `/etc/systemd/system`.

NOTE: In `td-agent` 4, the path is different i.e. `/opt/td-agent/bin` instead of `/opt/td-agent/embedded/bin`.

#### `init.d`

This is for CentOS 6, non-`systemd` based system.

Use `/etc/init.d/td-agent` script to `start`, `stop`, or `restart` the agent:

```text
$ sudo /etc/init.d/td-agent start
Starting td-agent: [  OK  ]
$ sudo /etc/init.d/td-agent status
td-agent (pid  21678) is running...
```

The following commands are supported:

```text
$ sudo /etc/init.d/td-agent start
$ sudo /etc/init.d/td-agent stop
$ sudo /etc/init.d/td-agent restart
$ sudo /etc/init.d/td-agent status
```

Please make sure your configuration file path is:

```text
/etc/td-agent/td-agent.conf
```

### Step 3: Post Sample Logs via HTTP

The default configuration \(`/etc/td-agent/td-agent.conf`\) is to receive logs at an HTTP endpoint and route them to `stdout`. For `td-agent` logs, see `/var/log/td-agent/td-agent.log`.

You can post sample log records with `curl` command:

```text
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
$ tail -n 1 /var/log/td-agent/td-agent.log
2018-01-01 17:51:47 -0700 debug.test: {"json":"message"}
```

## Using to install `calyptia-fluentd`

### Step 0: Before Installation

Please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

### Step 1: Install from `rpm` Repository

It is highly recommended to set up `ntpd` on the node to prevent invalid timestamps in the logs. See [Pre-installation Guide](before-install.md).

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.

#### Red Hat / CentOS

Download and execute the install script with `curl`:

```text
# calyptia-fluentd 1
$ curl -L https://calyptia-fluentd.s3.us-east-2.amazonaws.com/calyptia-fluentd-1-redhat.sh | sh
```

Executing this script will automatically install `calyptia-fluentd` on your machine. This shell script registers a new `rpm` repository at `/etc/yum.repos.d/Calyptia-Fluentd.repo` and installs `calyptia-fluentd`.

We use `$releasever` for repository path in the script and `$releasever` should be the major version only like `"7"`. If your environment uses some other format like `"7.2"`, change it to the major version only or set up TD repository manually.

#### CentOS Stream

For CentOS Stream 8:

```text
# calyptia-fluentd 1
$ curl -L https://calyptia-fluentd.s3.us-east-2.amazonaws.com/calyptia-fluentd-1-centos-stream.sh
```

#### Amazon Linux

For Amazon Linux 2:

```text
# calyptia-fluentd 1
$ curl -L https://calyptia-fluentd.s3.us-east-2.amazonaws.com/calyptia-fluentd-1-amazon-2.sh | sh
```

### Step 2: Launch Daemon

`calyptia-fluentd` only provides systemd's unit file:

#### `systemd`

Use `/usr/lib/systemd/system/calyptia-fluentd` script to `start`, `stop`, or `restart` the agent:

```text
$ sudo systemctl start calyptia-fluentd.service
$ sudo systemctl status calyptia-fluentd.service
● calyptia-fluentd.service - calyptia-fluentd: Fluentd based data collector for Calyptia Services
   Loaded: loaded (/usr/lib/systemd/system/calyptia-fluentd.service; enabled; vendor preset: disabled)
   Active: active (running) since Mon 2021-05-31 01:37:47 UTC; 4h 38min ago
     Docs: https://docs.fluentd.org/
  Process: 694 ExecStart=/opt/calyptia-fluentd/bin/fluentd --log $CALYPTIA_FLUENTD_LOG_FILE --daemon /var/run/calyptia-fluentd/calyptia-fluentd.pid $CALYPTIA_FLUENTD_OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 1365 (fluentd)
   CGroup: /system.slice/calyptia-fluentd.service
           ├─1365 /opt/calyptia-fluentd/bin/ruby /opt/calyptia-fluentd/bin/fluentd --log /var/log/calyptia-fluentd/calyptia-fluentd.log --daem...
           └─1368 /opt/calyptia-fluentd/bin/ruby -Eascii-8bit:ascii-8bit /opt/calyptia-fluentd/bin/fluentd --log /var/log/calyptia-fluentd/cal...
```

To customize `systemd` behavior, put your `calyptia-fluentd.service` in `/etc/systemd/system`.

Please make sure your configuration file path is:

```text
/etc/calyptia-fluentd/calyptia-fluentd.conf
```

### Step 3: Post Sample Logs via HTTP

The default configuration \(`/etc/calyptia-fluentd/calyptia-faluentd.conf`\) is to receive logs at an HTTP endpoint and route them to `stdout`. For `calyptia-fluentd` logs, see `/var/log/calyptia-fluentd/calyptia-fluentd.log`.

You can post sample log records with `curl` command:

```text
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
$ sudo tail -n 1 /var/log/calyptia-fluentd/calyptia-fluentd.log
2021-05-31 06:19:04.415878392 +0000 debug.test: {"json":"message"}
```

## Next Steps

You are now ready to collect real logs with Fluentd. Refer to the following tutorials on how to collect data from various sources:

* Basic Configuration
  * [Config File](../configuration/config-file.md)
* Application Logs
  * [Ruby](../language-bindings/ruby.md), [Java](../language-bindings/java.md), [Python](../language-bindings/python.md), [PHP](../language-bindings/php.md),

    [Perl](../language-bindings/perl.md), [Node.js](../language-bindings/nodejs.md), [Scala](../language-bindings/scala.md)
* Examples
  * [Store Apache Log into Amazon S3](../how-to-guides/apache-to-s3.md)
  * [Store Apache Log into MongoDB](../how-to-guides/apache-to-mongodb.md)
  * [Data Collection into HDFS](../how-to-guides/http-to-hdfs.md)

For further steps, follow these:

* [ChangeLog of td-agent](https://docs.treasuredata.com/display/public/PD/The+td-agent+Change+Log)
* [Chef Cookbook](https://github.com/treasure-data/chef-td-agent/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

