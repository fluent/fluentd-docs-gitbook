# Installing Fluentd Using Ruby Gem

This article explains how to install Fluentd using Ruby gem.

[]{#step-0:-before-installation}

## Step 0: Before Installation

Please follow the [Preinstallation Guide](/articles/before-install.md) to configure
your OS properly. This will prevent many unnecessary problems.

[]{#step-1:-install-ruby-interpreter}

## Step 1: Install Ruby interpreter

Please install Ruby \>= 2.1 on your local environment. In addition,
install ruby-dev package via package manager to build native extension
gems.

[]{#step-2:-install-fluentd-gem}

## Step 2: Install Fluentd gem

Fetch and install the `fluentd` Ruby gem using the `gem` command. The
official ruby gem page is [here](https://rubygems.org/gems/fluentd).

``` {.CodeRay}
$ gem install fluentd --no-ri --no-rdoc
```

[]{#step-3:-run}

## Step 3: Run

Run the following commands to confirm that Fluentd was installed
successfully:

``` {.CodeRay}
$ fluentd --setup ./fluent
$ fluentd -c ./fluent/fluent.conf -vv &
$ echo '{"json":"message"}' | fluent-cat debug.test
```

The second command start Fluentd daemon in background. If you want to
stop daemon, you can use `$ pkill -f fluentd`. The last command sends
Fluentd a message '{"json":"message"}' with a "debug.test" tag. If the
installation was successful, Fluentd will output the following message:

``` {.CodeRay}
2011-07-10 16:49:50 +0900 debug.test: {"json":"message"}
```

It\'s HIGHLY recommended that you set up **ntpd** on the node to prevent
invalid timestamps in your logs.

For large deployments, you must use
[jemalloc](http://www.canonware.com/jemalloc/) to avoid memory
fragmentation. This is already included in the [rpm](/articles/install-by-rpm.md) and
[deb](/articles/install-by-deb.md) packages.

The Fluentd gem doesn\'t come with /etc/init.d/ scripts. You should use
process management tools such as
[daemontools](http://cr.yp.to/daemontools.html),
[runit](http://smarden.org/runit/),
[supervisord](http://supervisord.org/),
[upstart](http://upstart.ubuntu.com/), or systemd.


## Next Steps

You're now ready to collect your real logs using Fluentd. Please see the
following tutorials to learn how to collect your data from various data
sources.

-   Basic Configuration
    -   [Config File](/articles/config-file.md)
-   Application Logs
    -   [Ruby](/articles/ruby.md), [Java](/articles/java.md), [Python](/articles/python.md), [PHP](/articles/php.md),
        [Perl](/articles/perl.md), [Node.js](/articles/nodejs.md), [Scala](/articles/scala.md)
-   Examples
    -   [Store Apache Log into Amazon S3](/articles/apache-to-s3.md)
    -   [Store Apache Log into MongoDB](/articles/apache-to-mongodb.md)
    -   [Data Collection into HDFS](/articles/http-to-hdfs.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
