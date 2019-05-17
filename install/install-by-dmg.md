# Installing Fluentd using .dmg Installer (MacOS X)

This article explains how to install td-agent, the stable Fluentd
distribution package maintained by [Treasure Data, Inc](https://www.treasuredata.com/), on MacOS X.


## What is td-agent?

Fluentd is written in Ruby for flexibility, with performance sensitive
parts written in C. However, casual users may have difficulty installing
and operating a Ruby daemon.

That's why [Treasure Data, Inc](https://www.treasuredata.com/) is
providing **the stable distribution of Fluentd**, called `td-agent`. The
differences between Fluentd and td-agent can be found
[here](https://www.fluentd.org/faqs).

For MacOS X, we're using the OS native .dmg Installer to distribute
td-agent.


## Step1: Install td-agent

Please download the `.dmg` file from here, and install the software.

-   [Download](https://td-agent-package-browser.herokuapp.com/3/macosx)


## Step2: Launch td-agent

You can launch `td-agent` with `launchctl` command. Please make sure the
daemon started correctly from the log
(`/var/log/td-agent/td-agent.log`).

```
$ sudo launchctl load /Library/LaunchDaemons/td-agent.plist
$ less /var/log/td-agent/td-agent.log
2018-01-01 16:55:03 -0700 [info]: starting fluentd-1.0.2
2018-01-01 16:55:03 -0700 [info]: reading config file path="/etc/td-agent/td-agent.conf"
```

**Your configuration file** is located at `/etc/td-agent/td-agent.conf`.
Your plugin directory is at `/etc/td-agent/plugin`. In case you want to
stop the agent, please execute the command below.

```
$ sudo launchctl unload /Library/LaunchDaemons/td-agent.plist
```


## Step3: Post Sample Logs via HTTP

By default, `/etc/td-agent/td-agent.conf` is configured to take logs
from HTTP and route them to stdout (`/var/log/td-agent/td-agent.log`).
You can post sample log records using the curl command.

```
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
$ tail -n 1 /var/log/td-agent/td-agent.log
2018-01-01 17:51:47 -0700 debug.test: {"json":"message"}
```


## Uninstall td-agent

td-agent for Mac doesn't provide uninstallation app unlike rpm / deb. If
you want to uninstall td-agent from your Mac, remove these files /
directories.

-   /Library/LaunchDaemons/td-agent.plist
-   /etc/td-agent
-   /opt/td-agent
-   /var/log/td-agent


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

Please refer to the resources below for further steps.

-   [ChangeLog of td-agent](http://docs.treasuredata.com/articles/td-agent-changelog)
-   [Chef Cookbook](https://github.com/treasure-data/chef-td-agent/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
