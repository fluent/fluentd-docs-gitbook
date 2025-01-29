# Install `fluent-package` by .dmg Package \(macOS\)

This article explains how to install stable versions of `fluent-package` dmg packages, the stable Fluentd distribution packages maintained by [Fluentd Project](https://www.fluentd.org/) on macOS.

## What is `fluent-package`?

Please see [fluent-package-v5-vs-td-agent](../quickstart/fluent-package-v5-vs-td-agent.md).

## How to install `fluent-package`

{% hint style='info' %}
NOTE:

* `fluent-package` is not be shipped yet, we plan to migrate to homebrew ecosystem in the future.
{% endhint %}

{% hint style='danger' %}
The following are deprecated td-agent (EOL) information:

* About Treasure Agent (td-agent) v4, see [Install by .dmg Package \(macOS\)](install-by-dmg-td-agent-v4.md).
* About deprecated [Treasure Agent (td-agent) 3 will not be maintained anymore](https://www.fluentd.org/blog/schedule-for-td-agent-3-eol), see [Install by DEB Package  v3](install-by-deb-td-agent-v3.md).
{% endhint %}

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
