# Install by DEB Package \(Debian/Ubuntu\)

This article explains how to install stable versions of `td-agent` deb packages, the stable Fluentd distribution packages maintained by [Treasure Data, Inc](http://www.treasuredata.com/) and [Calyptia, Inc.](https://www.calyptia.com/).

## What is `td-agent`?

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon.

That is why [Treasure Data, Inc](http://www.treasuredata.com/) provides **the stable distribution of Fluentd**, called `td-agent`. The differences between Fluentd and `td-agent` can be found [here](https://www.fluentd.org/faqs).

## What is `calyptia-fluentd`?

Our Calyptia also knows that Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon. And `td-agent` is still seated on Ruby 2.7 due to compatibility reasons and Ruby versioning policy, `calyptia-fluentd` uses Ruby 3 instead of Ruby 2.7 for now.

That is why [Calyptia, Inc.](https://www.calyptia.com/) provides **the alternative stable distribution of Fluentd**, called `calyptia-fluentd`. The differences between `td-agent` and `calyptia-fluentd` are bundled and running Ruby versions for now.

This installation guide is for `td-agent` v3/v4 and `calyptia-fluentd` v1. `td-agent` v3/v4 and `calyptia-fluentd` use fluentd v1 in the core. See [this page](../quickstart/td-agent-v2-vs-v3-vs-v4.md) for the comparison and supported OS.

## Installing `td-agent`

### Step 0: Before Installation

Please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

### Step 1: Install from Apt Repository

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.

NOTE: Treasure Data does not verify Debian packages. If you have any problem with Debian packages, send a patch to [`fluent-package-builder`](https://github.com/fluent-plugins-nursery/fluent-package-builder) repository.

A shell script is provided to automate the installation process for each version. The shell script registers a new apt repository at `/etc/apt/sources.list.d/treasure-data.list` and installs the `td-agent` deb package.

For Ubuntu Jammy:

```bash
# td-agent 4 (experimental)
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-jammy-td-agent4.sh | sh
```

For Ubuntu Focal:

```bash
# td-agent 4
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-focal-td-agent4.sh | sh
```

For Ubuntu Bionic:

```bash
# td-agent 4
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent4.sh | sh
# td-agent 3 (EOL)
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent3.sh | sh
```

For Ubuntu Xenial:

```bash
# td-agent 4
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent4.sh | sh
# td-agent 3 (EOL)
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent3.sh | sh
```

For Debian Bullseye:

```bash
# td-agent 4
curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-bullseye-td-agent4.sh | sh
```

For Debian Buster:

```bash
# td-agent 4
curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-buster-td-agent4.sh | sh
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

## Using to install `calyptia-fluentd`

### Step 0: Before Installation

Please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

### Step 1: Install from Apt Repository

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.

A shell script is provided to automate the installation process for each version. The shell script registers a new apt repository at `/etc/apt/sources.list.d/calyptia-fluentd.sources` and installs the `calyptia-fluentd` deb package.

For Ubuntu Focal:

```bash
# calyptia-fluentd 1
curl -fsSL https://calyptia-fluentd.s3.us-east-2.amazonaws.com/calyptia-fluentd-1-ubuntu-focal.sh | sh
```

For Ubuntu Bionic:

```bash
# calyptia-fluentd 1
curl -fsSL https://calyptia-fluentd.s3.us-east-2.amazonaws.com/calyptia-fluentd-1-ubuntu-bionic.sh | sh
```

For Ubuntu Xenial:

```bash
# calyptia-fluentd 1
curl -fsSL https://calyptia-fluentd.s3.us-east-2.amazonaws.com/calyptia-fluentd-1-ubuntu-xenial.sh | sh
```

For Debian Buster:

```bash
# calyptia-fluentd 1
curl -fsSL https://calyptia-fluentd.s3.us-east-2.amazonaws.com/calyptia-fluentd-1-debian-buster.sh | sh
```

### Step 2: Launch Daemon

### `systemd`

Use `/lib/systemd/system/calyptia-fluentd` script to `start`, `stop`, or `restart` the agent:

```text
$ sudo systemctl start calyptia-fluentd.service
$ sudo systemctl status calyptia-fluentd.service
● calyptia-fluentd.service - calyptia-fluentd: Fluentd based data collector for Calyptia Services
   Loaded: loaded (/lib/systemd/system/calyptia-fluentd.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2021-05-28 15:29:45 JST; 1s ago
     Docs: https://docs.fluentd.org/
  Process: 406739 ExecStart=/opt/calyptia-fluentd/bin/fluentd --log $CALYPTIA_FLUENTD_LOG_FILE --daemon /var/run/calyptia-fluentd/calyptia-fluentd.pid $CALYPTIA_FLUENTD_OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 406762 (fluentd)
    Tasks: 5 (limit: 4915)
   CGroup: /system.slice/calyptia-fluentd.service
           ├─406762 /opt/calyptia-fluentd/bin/ruby /opt/calyptia-fluentd/bin/fluentd --log /var/log/calyptia-fluentd/calyptia-fluentd.log --daemon /var/run/calyptia-fluentd/calyptia-fluentd.pid
           └─406835 /opt/calyptia-fluentd/bin/ruby -Eascii-8bit:ascii-8bit /opt/calyptia-fluentd/bin/fluentd --log /var/log/calyptia-fluentd/calyptia-fluentd.log --daemon /var/run/calyptia-fluentd/calyptia-fluentd.pid --under-supervisor
```

To customize `systemd` behavior, put your `calyptia-fluentd.service` in `/lib/systemd/system`.

Please make sure your configuration file path is:

```text
/etc/calyptia-fluentd/calyptia-fluentd.conf
```

### Step 3: Post Sample Logs via HTTP

The default configuration \(`/etc/calyptia-fluentd/calyptia-fluentd.conf`\) is to receive logs at an HTTP endpoint and route them to `stdout`. For `calyptia-fluentd` logs, see `/var/log/calyptia-fluentd/calyptia-fluentd.log`.

You can post sample log records with `curl` command:

```text
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
$ sudo tail -n 1 /var/log/calyptia-fluentd/calyptia-fluentd.log
2021-05-28 15:45:17.998214460 +0900 debug.test: {"json":"message"}
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

