# Install `fluent-package` by Homebrew \(macOS\)

This article explains how to install `fluent-package` on Apple Silicon Macs with [Homebrew](https://brew.sh/).

## What is `fluent-package`?

Please see [fluent-package-v5-vs-td-agent](../../quickstart/fluent-package-v5-vs-td-agent.md).

## How to install `fluent-package`

{% hint style='danger' %}
The following are deprecated td-agent (EOL) information:

* About Treasure Agent (td-agent) v4, see [Install by .dmg Package \(macOS\)](../install-by-dmg-td-agent-v4.md).
* About deprecated [Treasure Agent (td-agent) 3 will not be maintained anymore](https://www.fluentd.org/blog/schedule-for-td-agent-3-eol), see [Install by DEB Package  v3](../install-by-deb-td-agent-v3.md).
{% endhint %}

The Homebrew formula currently supports Apple Silicon (ARM64) Macs.

### Step 1: Install `fluent-package`

Install Homebrew first if it is not already installed, then add the Fluent Package tap and install the formula:

```console
brew tap fluent/package-builder https://github.com/fluent/fluent-package-builder
brew install fluent/package-builder/fluent-package
```

### Step 2: Start Fluentd

Start Fluentd as a background service managed by `launchd`. Without `sudo`, it starts when the current user logs in:

```console
brew services start fluent/package-builder/fluent-package
```

To start Fluentd at boot, before any user logs in, register it as a system service with `sudo`:

```console
sudo brew services start fluent/package-builder/fluent-package
```

Use the same form (`sudo` or no `sudo`) when stopping or restarting the service:

```console
brew services stop fluent/package-builder/fluent-package
brew services restart fluent/package-builder/fluent-package
sudo brew services stop fluent/package-builder/fluent-package
sudo brew services restart fluent/package-builder/fluent-package
```

`brew services run` runs Fluentd without registering it to start at login or boot.

### Configuration, logs, and plugins

The configuration file is `$(brew --prefix)/etc/fluent/fluentd.conf`, and the service log is `$(brew --prefix)/var/log/fluent/fluentd.log`. On a standard Apple Silicon Homebrew installation, `brew --prefix` is `/opt/homebrew`.

Install additional plugins with the formula's `fluent-gem` command so they are available to Fluentd:

```console
fluent-gem install fluent-plugin-s3
```

### Uninstall `fluent-package`

Stop the service using the same form (`sudo` or no `sudo`) that you used to start it, then uninstall the formula:

```console
brew services stop fluent/package-builder/fluent-package
sudo brew services stop fluent/package-builder/fluent-package
brew uninstall fluent/package-builder/fluent-package
```

Homebrew removes the formula's commands but keeps the configuration, logs, and user-installed gems under the Homebrew prefix. Remove those files manually if you want to delete all Fluentd data.

## Next Steps

You are now ready to collect real logs with Fluentd. Refer to the following tutorials on how to collect data from various sources:

* Basic Configuration
  * [Config File](../../configuration/config-file.md)
* Application Logs
  * [Ruby](../../language-bindings/ruby.md), [Java](../../language-bindings/java.md), [Python](../../language-bindings/python.md), [PHP](../../language-bindings/php.md),

    [Perl](../../language-bindings/perl.md), [Node.js](../../language-bindings/nodejs.md), [Scala](../../language-bindings/scala.md)
* Examples
  * [Store Apache Log into Amazon S3](../../how-to-guides/apache-to-s3.md)
  * [Store Apache Log into MongoDB](../../how-to-guides/apache-to-mongodb.md)
  * [Data Collection into HDFS](../../how-to-guides/http-to-hdfs.md)

{% hint style='info' %}
There are some commercial supports for Fluentd, see [Enterprise Services](https://www.fluentd.org/enterprise_services).
If you use Fluentd on production, Let's share your use-case/testimonial on [Testimonials](https://www.fluentd.org/testimonials) page.
Please consider to feedback via [GitHub](https://github.com/fluent/fluentd-website/issues/new?template=testimonials.yml).
{% endhint %}
