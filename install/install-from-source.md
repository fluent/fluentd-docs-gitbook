# Installing Fluentd from Source

This article explains how to install Fluentd from source code (git
repository). This is useful for developers.


## Step-1: Install Ruby interpreter

Please install Ruby \>= 2.1 and bundler on your local environment.


## Step-2: Fetch Source Code

Fetch the source code from github. The official repository is located
[here](http://github.com/fluent/fluentd/).

```
$ git clone https://github.com/fluent/fluentd.git
$ cd fluentd
```

"master" branch is now for v1 development.


## Step-3: Build and Install

Build the package with `rake` and install it with `gem`.

```
$ bundle install
Fetching gem metadata from https://rubygems.org/.........
...
Your bundle is complete!
Use `bundle show [gemname]` to see where a bundled gem is installed.
$ bundle exec rake build
fluentd xxx built to pkg/fluentd-xxx.gem.
$ gem install pkg/fluentd-xxx.gem
```


## Step-4: Run

Run the following commands to to confirm that Fluentd was installed
successfully:

```
$ fluentd --setup ./fluent
$ fluentd -c ./fluent/fluent.conf -vv &
$ echo '{"json":"message"}' | fluent-cat debug.test
```

The second command start Fluentd daemon in background. If you want to
stop daemon, you can use `$ pkill -f fluentd`. The last command sends
Fluentd a message '{"json":"message"}' with a "debug.test" tag. If the
installation was successful, Fluentd will output the following message:

```
2011-07-10 16:49:50 +0900 debug.test: {"json":"message"}
```

It's HIGHLY recommended that you set up **ntpd** on the node to prevent
invalid timestamps in your logs.

For large deployments, you must use
[jemalloc](http://www.canonware.com/jemalloc/) to avoid memory
fragmentation. This is already included in the [rpm](/install/install-by-rpm.md) and
[deb](/install/install-by-deb.md) packages.


## Next Steps

You're now ready to collect your real logs using Fluentd. Please see the
following tutorials to learn how to collect your data from various data
sources.

-   Basic Configuration
    -   [Config File](/configuration/config-file.md)
-   Application Logs
    -   [Ruby](/language/ruby.md), [Java](/language/java.md), [Python](/language/python.md), [PHP](/language/php.md),
        [Perl](/language/perl.md), [Node.js](/language/nodejs.md), [Scala](/language/scala.md)
-   Examples
    -   [Store Apache Log into Amazon S3](/guides/apache-to-s3.md)
    -   [Store Apache Log into MongoDB](/guides/apache-to-mongodb.md)
    -   [Data Collection into HDFS](/guides/http-to-hdfs.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
