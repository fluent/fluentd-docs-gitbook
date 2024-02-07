# Install by DEB Package v3 \(Debian/Ubuntu\)

This article explains how to install the `td-agent` deb package, the stable Fluentd distribution package maintained by [Treasure Data, Inc](http://www.treasuredata.com/).

## What is `td-agent`?

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon.

That is why [Treasure Data, Inc](http://www.treasuredata.com/) provides **the stable distribution of Fluentd**, called `td-agent`. The differences between Fluentd and `td-agent` can be found [here](https://www.fluentd.org/faqs).

## Installing `td-agent`

{% hint style='danger' %}
NOTE: As [Treasure Agent (td-agent) 3 will not be maintained anymore](https://www.fluentd.org/blog/schedule-for-td-agent-3-eol), recommend to [Upgrade td-agent from v3 to v4](https://www.fluentd.org/blog/upgrade-td-agent-v3-to-v4).
{% endhint %}

### Step 0: Before Installation

Please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

### Step 1: Install from Apt Repository

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.

A shell script is provided to automate the installation process for each version. The shell script registers a new apt repository at `/etc/apt/sources.list.d/treasure-data.list` and installs the `td-agent` deb package.

For Ubuntu Bionic:

```bash
# td-agent 3 (EOL)
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent3.sh | sh
```

For Ubuntu Xenial:

```bash
# td-agent 3 (EOL)
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent3.sh | sh
```

For Debian Buster:

```bash
# td-agent 3 (EOL)
curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-buster-td-agent3.sh | sh
```

### Step 2: Launch Daemon

### `systemd`

Use `/lib/systemd/system/td-agent` script to `start`, `stop`, or `restart` the agent:

```text
$ sudo systemctl start td-agent.service
$ sudo systemctl status td-agent.service
● td-agent.service - td-agent: Fluentd based data collector for Treasure Data
    Loaded: loaded (/lib/systemd/system/td-agent.service; enabled; vendor preset: enabled)
    Active: active (running) since Tue 2022-09-20 05:28:25 JST; 1 week 0 days ago
      Docs: https://docs.treasuredata.com/display/public/PD/About+Treasure+Data%27s+Server-Side+Agent
  Main PID: 2417 (fluentd)
    Tasks: 8 (limit: 38328)
    Memory: 52.2M
      CPU: 56.868s
    CGroup: /system.slice/td-agent.service
            ├─2417 /opt/td-agent/bin/ruby /opt/td-agent/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/td-agent.pid
            └─2420 /opt/td-agent/bin/ruby -Eascii-8bit:ascii-8bit /opt/td-agent/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/t>

Sept 9 20 05:28:24 Ryzen systemd[1]: Starting td-agent: Fluentd based data collector for Treasure Data...
Sept 9 20 05:28:25 Ryzen systemd[1]: Started td-agent: Fluentd based data collector for Treasure Data.
```

To customize `systemd` behavior, put your `td-agent.service` in `/etc/systemd/system`.

NOTE: In td-agent 4, path is different. `/opt/td-agent/bin` instead of `/opt/td-agent/embedded/bin`

#### `init.d`

For non systemd-based system, use `/etc/init.d/td-agent` script to `start`, `stop`, or `restart` the agent:

```text
$ sudo /etc/init.d/td-agent restart
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

* [ChangeLog of `td-agent`](https://docs.treasuredata.com/display/public/PD/The+td-agent+Change+Log)
* [Chef Cookbook](https://github.com/treasure-data/chef-td-agent/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

