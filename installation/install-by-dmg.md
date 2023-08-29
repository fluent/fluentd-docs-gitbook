# Install by .dmg Package \(macOS\)

This article explains how to install stable versions of `fluent-package` dmg packages, the stable Fluentd distribution packages maintained by [Fluentd Project](https://www.fluentd.org/) and `calyptia-fluentd` which is maintained by [Calyptia, Inc.](https://www.calyptia.com/) on macOS.

## What is `fluent-package`?

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon.

That is why [Fluentd Project](https://www.fluentd.org/) provides **the stable distribution of Fluentd**, called `fluent-package`. The differences between Fluentd and `fluent-package` can be found [here](https://www.fluentd.org/faqs).

## What is `calyptia-fluentd`?

Our Calyptia also knows that Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon. And `td-agent` is still seated on Ruby 2.7 due to compatibility reasons and Ruby versioning policy, `calyptia-fluentd` uses Ruby 3 instead of Ruby 2.7 for now.

That is why [Calyptia, Inc.](https://www.calyptia.com/) provides **the alternative stable distribution of Fluentd**, called `calyptia-fluentd`. The differences between `td-agent` and `calyptia-fluentd` are bundled and running Ruby versions for now.

For macOS, `td-agent` is distributed as `.dmg` installer.

## `fluent-package` v5

NOTE:

* About Treasure Agent (td-agent) v4, see [Install by .dmg Package \(macOS\)](install-by-dmg-td-agent-v4.md).
* About deprecated [Treasure Agent (td-agent) 3 will not be maintained anymore](https://www.fluentd.org/blog/schedule-for-td-agent-3-eol), see [Install by DEB Package  v3](install-by-deb-td-agent-v3.md).
* `fluent-package` is not be shipped yet, we plan to migrate to homebrew ecosystem in the future.

<!-- Revise instructions when fluent-package with homebrew was released

### Step 1: Install `fluent-package`

Download and install the `.dmg` package:

* [fluent-package v5](https://td-agent-package-browser.herokuapp.com/5/macosx)

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.

### Step 2: Launch `fluentd`

Use `launchctl` command to launch `fluentd`. Make sure that the daemon is started correctly. Checks logs \(`/var/log/fluent/fluentd.log`\).

```text
$ sudo launchctl load /Library/LaunchDaemons/fluentd.plist
$ less /var/log/fluent/fluentd.log
2023-08-01 16:55:03 -0700 [info]: starting fluentd-1.16.2
2023-08-01 16:55:03 -0700 [info]: reading config file path="/etc/fluent/fluentd.conf"
```

The configuration file is located at `/etc/fluent/fluentd.conf` and the plugin directory is at `/etc/fluent/plugin`.

To stop the agent, run this command:

```text
$ sudo launchctl unload /Library/LaunchDaemons/fluentd.plist
```

### Step 3: Post Sample Logs via HTTP

The default configuration \(`/etc/fluent/fluentd.conf`\) is to receive logs at an HTTP endpoint and route them to `stdout`. For `fluentd` logs, see `/var/log/fluent/fluentd.log`.

You can post sample log records with `curl` command:

```text
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
$ tail -n 1 /var/log/fluent/fluentd.log
2023-08-01 17:51:47 -0700 debug.test: {"json":"message"}
```

### Uninstall fluent-package

On macOS, `fluent-package` does not provide any uninstallation app like `rpm` / `deb` on Ubuntu.

To uninstall `fluent-package` from macOS, remove these files / directories:

* `/Library/LaunchDaemons/fluentd.plist`
* `/etc/fluent`
* `/opt/fluent`
* `/var/log/fluent`

-->

## `calyptia-fluentd` v1

### Step 1: Install `calyptia-fluentd`

Download and install the `.dmg` package:

* [calyptia-fluentd v1](https://calyptia-fluentd.s3.us-east-2.amazonaws.com/index.html?prefix=1/macos/)

NOTE: If your OS is not supported, consider [gem installation](install-by-gem.md) instead.
NOTE: Since calyptia-fluentd v1.3.1, intel version and apple silicon version of packages are provided.
`-intel` suffix is for Intel version and `-apple` suffix is for Apple Silicon.

### Step 2: Launch `calyptia-fluentd`

Use `launchctl` command to launch `calyptia-fluentd`. Make sure that the daemon is started correctly. Checks logs \(`/var/log/calyptia-fluentd/calyptia-fluentd.log`\).

```text
$ sudo launchctl load /Library/LaunchDaemons/calyptia-fluentd.plist
$ less /var/log/calyptia-fluentd/calyptia-fluentd.log
2021-05-31 14:29:38 +0900 [info]: starting fluentd-1.12.3 pid=72608 ruby="3.0.1"
2021-05-31 14:29:38 +0900 [info]: spawn command to main:  cmdline=["/opt/calyptia-fluentd/bin/ruby", "-Eascii-8bit:ascii-8bit", "/opt/calyptia-fluentd/usr/sbin/calyptia-fluentd", "--log", "/var/log/calyptia-fluentd/calyptia-fluentd.log", "--use-v1-config", "--under-supervisor"]
```

The configuration file is located at `/etc/calyptia-fluentd/calyptia-fluentd.conf` and the plugin directory is at `/etc/calyptia-fluentd/plugin`.

To stop the agent, run this command:

```text
$ sudo launchctl unload /Library/LaunchDaemons/calyptia-fluentd.plist
```

### Step 3: Post Sample Logs via HTTP

The default configuration \(`/etc/calyptia-fluentd/calyptia-fluentd.conf`\) is to receive logs at an HTTP endpoint and route them to `stdout`. For `calyptia-fluentd` logs, see `/var/log/calyptia-fluentd/calyptia-fluentd.log`.

You can post sample log records with `curl` command:

```text
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
$ tail -n 1 /var/log/calyptia-fluentd/calyptia-fluentd.log
2021-05-31 14:32:02.707482000 +0900 debug.test: {"json":"message"}
```

### Uninstall calyptia-fluentd

On macOS, `calyptia-fluentd` uses dmg which includes macOS installer a.k.a. pkg. It does not provide any uninstallation app functionality like `rpm` / `deb` on CentOS / Ubuntu.

To uninstall `calyptia-fluentd` from macOS, remove these files / directories:

* `/Library/LaunchDaemons/calyptia-fluentd.plist`
* `/etc/calyptia-fluentd`
* `/opt/calyptia-fluentd`
* `/var/log/calyptia-fluentd`

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

