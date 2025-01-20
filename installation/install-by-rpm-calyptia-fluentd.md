# Install `calyptia-fluentd` by RPM Package \(Red Hat Linux\)

This article explains how to install `calyptia-fluentd`, which is maintained by [Chronosphere](https://chronosphere.io) after its acquisition of Calyptia.

## What is `calyptia-fluentd`?

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon.

That is why Chronosphere (formerly Calyptia) provides **the alternative stable distribution of Fluentd**, called `calyptia-fluentd`.

## How to install `calyptia-fluentd`

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

The default configuration \(`/etc/calyptia-fluentd/calyptia-fluentd.conf`\) is to receive logs at an HTTP endpoint and route them to `stdout`. For `calyptia-fluentd` logs, see `/var/log/calyptia-fluentd/calyptia-fluentd.log`.

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

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
