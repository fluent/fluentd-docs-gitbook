# Install by Ruby Gem

This article explains how to install Fluentd using Ruby `gem`.

## Step 0: Before Installation

Please follow the [Pre-installation Guide](before-install.md) to configure your OS properly.

## Step 1: Install Ruby Interpreter

Install Ruby `>= 2.7` on your local environment. In addition, install `ruby-dev` package via Package Manager to build native extension gems.

## Step 2: Install Fluentd Gem

Fetch and install the `fluentd` Ruby gem using `gem` command:

```text
$ gem install fluentd --no-doc
```

The official RubyGems page is [here](https://rubygems.org/gems/fluentd).

## Step 3: Run

Run the following commands to verify the Fluentd installation:

```text
$ fluentd --setup ./fluent
$ fluentd -c ./fluent/fluent.conf -vv &
$ echo '{"json":"message"}' | fluent-cat debug.test
```

The second command starts Fluentd as a daemon. If you want to stop its daemon, you can use `$ pkill -f fluentd`. The last command sends Fluentd a message '{"json":"message"}' with a `debug.test` tag. If the installation is successful, Fluentd will output the following message:

```text
2011-07-10 16:49:50 +0900 debug.test: {"json":"message"}
```

It is highly recommended to set up `ntpd` on the node to prevent invalid timestamps in your logs.

For large deployments, you must use [`jemalloc`](http://www.canonware.com/jemalloc/) to avoid memory fragmentation. This is already included in the [`rpm`](install-by-rpm-fluent-package.md) and [`deb`](install-by-deb-fluent-package.md) packages.

The Fluentd gem does not come with `/etc/init.d/` scripts. You should use Process Management tools such as:

* [`daemontools`](http://cr.yp.to/daemontools.html)
* [`runit`](http://smarden.org/runit/)
* [`supervisord`](http://supervisord.org/)
* [`upstart`](http://upstart.ubuntu.com/)
* `systemd`

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

