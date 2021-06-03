# Install from Source

This article explains how to install Fluentd from source \(git repository\). This is useful for developers.

## Step 1: Install Ruby Interpreter

Install Ruby `>= 2.1` and `bundler` on your local environment.

## Step 2: Fetch Source Code

Fetch the source code from GitHub. The official repository is located [here](http://github.com/fluent/fluentd/).

```text
$ git clone https://github.com/fluent/fluentd.git
$ cd fluentd
```

The `master` branch is now for `v1` development.

## Step 3: Build and Install

Build the package with `rake` and install it with `gem`:

```text
$ bundle install
Fetching gem metadata from https://rubygems.org/.........
...
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
$ bundle exec rake build
fluentd xxx built to pkg/fluentd-xxx.gem.
$ gem install pkg/fluentd-xxx.gem
```

## Step 4: Run

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

For large deployments, you must use [`jemalloc`](http://www.canonware.com/jemalloc/) to avoid memory fragmentation. This is already included in the [`rpm`](install-by-rpm.md) and [`deb`](install-by-deb.md) packages.

## Troubleshooting

### Cannot install on M1 macOS

There is a known problem in the system Ruby on M1 macOS that `fluentd --setup ./fluent` command in Step.4 fails with an error similar to the following.

```text
.../kernel_require.rb:XX:in `require': dlopen(...):
missing compatible arch in ... (LoadError)
```

The system Ruby on macOS, which is like `universal.XXX-darwinXX` \(you can check it by `$ ruby -v`\) may cause this error. If you use the system Ruby, this error can be resolved by reinstalling Ruby.

As an example, you can reinstall Ruby by using [Homebrew](https://brew.sh/).

```text
$ brew reinstall --build-from-source ruby
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

