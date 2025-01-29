# Install `fluent-package` by DEB Package \(Debian/Ubuntu\)

This article explains how to install stable versions of `fluent-package` deb packages, the stable Fluentd distribution packages maintained by [Fluentd Project](https://www.fluentd.org/).

## What is `fluent-package`?

Please see [fluent-package-v5-vs-td-agent](../quickstart/fluent-package-v5-vs-td-agent.md).

## How to install `fluent-package`

{% hint style='info' %}
NOTE:

* `fluent-package` will be shipped in two flavors - normal release version and LTS (Long Term Support) version. See [Scheduled support lifecycle announcement about Fluent Package](https://www.fluentd.org/blog/fluent-package-scheduled-lifecycle) about difference between this two flavors.
* If you upgrade from `td-agent` v4, See [Upgrade to fluent-package v5](https://www.fluentd.org/blog/upgrade-td-agent-v4-to-v5).
* Do not directly upgrade from v3 to v5. Such a workflow is not supported. It causes a trouble. Upgrade in stages. (v3 to v4, then v4 to v5)
{% endhint %}

{% hint style='danger' %}
The following are deprecated td-agent (EOL) information:

* About [Treasure Agent (td-agent) v4 (EOL)](https://www.fluentd.org/blog/schedule-for-td-agent-4-eol), See [Install by DEB Package v4](install-by-deb-td-agent-v4.md).
* About [Treasure Agent (td-agent) 3 will not be maintained anymore](https://www.fluentd.org/blog/schedule-for-td-agent-3-eol), see [Install by DEB Package  v3](install-by-deb-td-agent-v3.md).
{% endhint %}

### Step 0: Before Installation

Please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

### Step 1: Install from Apt Repository

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.

A shell script is provided to automate the installation process for each version. The shell script registers a new apt repository at `/etc/apt/sources.list.d/fluent.sources` (or `/etc/apt/sources.list.d/fluent-lts.sources`) and installs the `fluent-package` deb package.

#### For Ubuntu Noble:

##### fluent-package 5 (LTS)

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-noble-fluent-package5-lts.sh | sh
```

##### fluent-package 5

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-noble-fluent-package5.sh | sh
```

#### For Ubuntu Jammy:

##### fluent-package 5 (LTS)

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-jammy-fluent-package5-lts.sh | sh
```

##### fluent-package 5

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-jammy-fluent-package5.sh | sh
```

#### For Ubuntu Focal:

##### fluent-package 5 (LTS)

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-focal-fluent-package5-lts.sh | sh
```

##### fluent-package 5

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-ubuntu-focal-fluent-package5.sh | sh
```

#### For Debian Bookworm:

##### fluent-package 5 (LTS)

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-bookworm-fluent-package5-lts.sh | sh
```

##### fluent-package 5

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-bookworm-fluent-package5.sh | sh
```

#### For Debian Bullseye:

##### fluent-package 5 (LTS)

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-bullseye-fluent-package5-lts.sh | sh
```

##### fluent-package 5

```bash
curl -fsSL https://toolbelt.treasuredata.com/sh/install-debian-bullseye-fluent-package5.sh | sh
```

### Step 2: Launch Daemon

### `systemd`

Use `/lib/systemd/system/fluentd` script to `start`, `stop`, or `restart` the agent:

```text
$ sudo systemctl start fluentd.service
$ sudo systemctl status fluentd.service
 sudo systemctl status fluentd
● fluentd.service - fluentd: All in one package of Fluentd
     Loaded: loaded (/lib/systemd/system/fluentd.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2023-08-16 08:18:22 UTC; 18s ago
       Docs: https://docs.fluentd.org/
    Process: 494 ExecStart=/opt/fluent/bin/fluentd --log $FLUENT_PACKAGE_LOG_FILE --daemon /var/run/fluent/fluentd.pid $FLUENT_PACKAGE_OPTI>
   Main PID: 826 (fluentd)
      Tasks: 9 (limit: 4660)
     Memory: 95.4M
        CPU: 731ms
     CGroup: /system.slice/fluentd.service
             ├─826 /opt/fluent/bin/ruby /opt/fluent/bin/fluentd --log /var/log/fluent/fluentd.log --daemon /var/run/fluent/fluentd.pid
             └─833 /opt/fluent/bin/ruby -Eascii-8bit:ascii-8bit /opt/fluent/bin/fluentd --log /var/log/fluent/fluentd.log --daemon /var/run>
```

To customize `systemd` behavior, put your `fluentd.service` in `/etc/systemd/system`.

NOTE: In fluent-package v5, path is different. `/opt/fluent/bin` instead of `/opt/td-agent/bin`

### Step 3: Post Sample Logs via HTTP

The default configuration \(`/etc/fluent/fluentd.conf`\) is to receive logs at an HTTP endpoint and route them to `stdout`. For `fluent-package` logs, see `/var/log/fluent/fluentd.log`.

You can post sample log records with `curl` command:

```text
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
$ tail -n 1 /var/log/fluent/fluentd.log
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

{% hint style='info' %}
There are some commercial supports for Fluentd, see [Enterprise Services](https://www.fluentd.org/enterprise_services).
If you use Fluentd on production, Let's share your use-case/testimonial on [Testimonials](https://www.fluentd.org/testimonials) page.
Please consider to feedback via [GitHub](https://github.com/fluent/fluentd-website/issues/new?template=testimonials.yml).
{% endhint %}

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
