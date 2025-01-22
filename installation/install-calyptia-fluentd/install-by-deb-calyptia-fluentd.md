# Install `calyptia-fluentd` by DEB Package \(Debian/Ubuntu\)

This article explains how to install `calyptia-fluentd`, which is maintained by [Chronosphere](https://chronosphere.io) after its acquisition of Calyptia.

## What is `calyptia-fluentd`?

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon.

That is why Chronosphere (formerly Calyptia) provides **the alternative stable distribution of Fluentd**, called `calyptia-fluentd`.

## How to install `calyptia-fluentd`

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

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
