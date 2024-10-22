# Install by RPM Package \(Red Hat Linux\)

This article explains how to install stable versions of `fluent-package` rpm packages, the stable Fluentd distribution packages maintained by [Fluentd Project](https://www.fluentd.org/) and `calyptia-fluentd` which is maintained by [Chronosphere](https://chronosphere.io) after its acquisition of Calyptia.

## What is `fluent-package`?

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon.

That is why [Fluentd Project](https://www.fluentd.org/) provides **the stable distribution of Fluentd**, called `fluent-package` (formerly known as `td-agent`). The differences between Fluentd and `fluent-package` can be found [here](https://www.fluentd.org/faqs).

## What is `calyptia-fluentd`?

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon. And `td-agent` is still seated on Ruby 2.7 due to compatibility reasons and Ruby versioning policy, `calyptia-fluentd` uses Ruby 3 instead of Ruby 2.7 for now.

That is why Chronosphere (formerly Calyptia) provides **the alternative stable distribution of Fluentd**, called `calyptia-fluentd`. The differences between `td-agent` and `calyptia-fluentd` are bundled and running Ruby versions for now.

This installation guide is for `fluent-package` v5 and `calyptia-fluentd` v1. `fluent-package` v5 and `calyptia-fluentd` use fluentd v1 in the core. See [fluent-package-v5-vs-td-agent](../quickstart/fluent-package-v5-vs-td-agent.md) or [td-agent-v2-vs-v3-vs-v4](../quickstart/td-agent-v2-vs-v3-vs-v4.md) for the comparison and supported OS.

## Using to install `fluent-package`

{% hint style='info' %}
NOTE:

* About deprecated [Treasure Agent (td-agent) v4 (EOL)](https://www.fluentd.org/blog/schedule-for-td-agent-4-eol), See [Install by RPM Package v4](install-by-rpm-td-agent-v4.md).
* About deprecated [Treasure Agent (td-agent) 3 will not be maintained anymore](https://www.fluentd.org/blog/schedule-for-td-agent-3-eol), see [Install by DEB Package  v3](install-by-deb-td-agent-v3.md).
* `fluent-package` will be shipped in two flavors - normal release version and LTS (Long Term Support) version. See [Scheduled support lifecycle announcement about Fluent Package](https://www.fluentd.org/blog/fluent-package-scheduled-lifecycle) about difference between this two flavors.
* If you upgrade from `td-agent` v4, See [Upgrade to fluent-package v5](https://www.fluentd.org/blog/upgrade-td-agent-v4-to-v5).
* Do not directly upgrade from v3 to v5. Such a workflow is not supported. It causes a trouble. Upgrade in stages. (v3 to v4, then v4 to v5)
{% endhint %}

### Step 0: Before Installation

Please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

### Step 1: Install from `rpm` Repository

It is highly recommended to set up `ntpd` on the node to prevent invalid timestamps in the logs. See [Pre-installation Guide](before-install.md).

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.

#### Red Hat

Download and execute the install script with `curl`:

##### fluent-package 5 (LTS)

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-redhat-fluent-package5-lts.sh | sh
```

##### fluent-package 5

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-redhat-fluent-package5.sh | sh
```

Executing this script will automatically install `fluent-package` on your machine. This shell script registers a new `rpm` repository at `/etc/yum.repos.d/fluent-package.repo` (or `/etc/yum.repos.d/fluent-package-lts.repo`) and installs `fluent-package`.

We use `$releasever` for repository path in the script and `$releasever` should be the major version only like `"9"`. If your environment uses some other format like `"9.2"`, change it to the major version only or set up .repo file manually.

{% hint style='danger' %}
Since v5.0.4, RHEL 7 / CentOS 7 is not supported anymore because CentOS 7 has reached EOL (June, 2024). Please consider migrating to another release.
{% endhint %}

#### Amazon Linux

##### For Amazon Linux 2023:

###### fluent-package 5 (LTS)

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-amazon2023-fluent-package5-lts.sh | sh
```

###### fluent-package 5

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-amazon2023-fluent-package5.sh | sh
```

##### For Amazon Linux 2:

###### fluent-package 5 (LTS)

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-amazon2-fluent-package5-lts.sh | sh
```

###### fluent-package 5

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-amazon2-fluent-package5.sh | sh
```

### Step 2: Launch Daemon

Use `/usr/lib/systemd/system/fluentd` service to `start`, `stop`, or `restart` the agent:

```text
$ sudo systemctl start fluentd.service
$ sudo systemctl status fluentd.service
* fluentd.service - fluentd: All in one package of Fluentd
   Loaded: loaded (/usr/lib/systemd/system/fluentd.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2023-08-02 05:35:16 UTC; 41s ago
     Docs: https://docs.fluentd.org/
  Process: 1901 ExecStart=/opt/fluent/bin/fluentd --log $FLUENT_PACKAGE_LOG_FILE --daemon /var/run/fluent/fluentd.pid $FLUENT_PACKAGE_OPTIONS (code=exited, status=0/SUCCESS)
 Main PID: 1907 (fluentd)
   CGroup: /system.slice/fluentd.service
           |-1907 /opt/fluent/bin/ruby /opt/fluent/bin/fluentd --log /var/log/fluent/fluentd.log --daemon /var/run/fluent/fluentd.pid
           `-1910 /opt/fluent/bin/ruby -Eascii-8bit:ascii-8bit /opt/fluent/bin/fluentd --log /var/log/fluent/fluentd.log --daemon /var/ru...

```

To customize `systemd` behavior, put your `fluentd.service` in `/etc/systemd/system`.

NOTE: In `fluent-package` v5, the path is different i.e. `/opt/fluent/bin` instead of `/opt/td-agent/bin`.

### Step 3: Post Sample Logs via HTTP

The default configuration \(`/etc/fluent/fluentd.conf`\) is to receive logs at an HTTP endpoint and route them to `stdout`. For `fluentd` logs, see `/var/log/fluent/fluentd.log`.

You can post sample log records with `curl` command:

```text
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
$ tail -n 1 /var/log/fluent/fluentd.log
2023-08-02 05:37:29.185634777 +0000 debug.test: {"json":"message"}
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

For further steps, follow these:

* [ChangeLog of td-agent](https://docs.treasuredata.com/display/public/PD/The+td-agent+Change+Log)
* [Chef Cookbook](https://github.com/treasure-data/chef-td-agent/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

