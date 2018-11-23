# Installing Fluentd Using rpm Package

This article explains how to install the
[td-agent](https://docs.treasuredata.com/articles/td-agent) rpm package,
the stable Fluentd distribution package maintained by [Treasure Data, Inc](http://www.treasuredata.com/).


## What is td-agent?

Fluentd is written in Ruby for flexibility, with performance sensitive
parts written in C. However, some users may have difficulty installing
and operating a Ruby daemon.

That's why [Treasure Data, Inc](http://www.treasuredata.com/) is
providing **the stable distribution of Fluentd**, called `td-agent`. The
differences between Fluentd and td-agent can be found
[here](//www.fluentd.org/faqs).

This installation guide is for td-agent v3, the new stable version.
td-agent v3 uses fluentd v1.0 in the core. See [this page](/articles/td-agent-v2-vs-v3.md) for the comparison between v2 and v3.


## Step 0: Before Installation

Please follow the [Preinstallation Guide](/articles/before-install.md) to configure
your OS properly. This will prevent many unnecessary problems.


## Step 1: Install from rpm Repository

It's HIGHLY recommended that you set up **ntpd** on the node to prevent
invalid timestamps in your logs. Please check the [Preinstallation Guide](/articles/before-install.md).


### Redhat / CentOS

CentOS and RHEL 6, 7 64bit are currently supported.

Executing
[install-redhat-td-agent3.sh](https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh)
will automatically install td-agent on your machine. This shell script
registers a new rpm repository at `/etc/yum.repos.d/td.repo` and
installs the `td-agent` rpm package.

``` {.CodeRay}
$ curl -L https://toolbelt.treasuredata.com/sh/install-redhat-td-agent3.sh | sh
```

We use \$releasever for repository path in the script and \$releasever
should be only major version like \"7\". If your environment uses other
format like \"7.2\", change it to only major version or setup TD
repository manually.


### Amazon Linux

Mainly for Amazon Linux 2. Recent two 64bit versions are supported for
amazon linux 1. This means if latest version is `2018.03`, rpm is
provided for `2018.03` and `2017.09`.

``` {.CodeRay}
# Amazon Linux 2
$ curl -L https://toolbelt.treasuredata.com/sh/install-amazon2-td-agent3.sh | sh
# Amazon Linux 1
$ curl -L https://toolbelt.treasuredata.com/sh/install-amazon1-td-agent3.sh | sh
```

Newer td-agent 3 no longer support Amazon Linux 1. If you want to use
latest td-agent 3, please upgrade your Amazon Linux 1 to Amazon Linux 2.

We use \$releasever for repository path in the script and \$releasever
should be \"year.month\" format like \"2017.09\". On AWS, some services
modify \$releasever to own format and it will cause installation
failure. If your environment\'s \$releasever is non-\"year.month\"
format, change it to \"year.month\" format or setup TD repository
manually.


## Step 2: Launch Daemon

td-agent provides 2 scripts:


### systemd

The `/usr/lib/systemd/system/td-agent` script is provided to start,
stop, or restart the agent.

``` {.CodeRay}
$ sudo systemctl start td-agent.service
$ sudo systemctl status td-agent.service
● td-agent.service - td-agent: Fluentd based data collector for Treasure Data
   Loaded: loaded (/lib/systemd/system/td-agent.service; disabled; vendor preset: enabled)
   Active: active (running) since Thu 2017-12-07 15:12:27 PST; 6min ago
     Docs: https://docs.treasuredata.com/articles/td-agent
  Process: 53192 ExecStart = /opt/td-agent/embedded/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/td-agent.pid (code = exited, statu
 Main PID: 53198 (fluentd)
   CGroup: /system.slice/td-agent.service
           ├─53198 /opt/td-agent/embedded/bin/ruby /opt/td-agent/embedded/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/td-agent
           └─53203 /opt/td-agent/embedded/bin/ruby -Eascii-8bit:ascii-8bit /opt/td-agent/embedded/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /v

Dec 07 15:12:27 ubuntu systemd[1]: Starting td-agent: Fluentd based data collector for Treasure Data...
Dec 07 15:12:27 ubuntu systemd[1]: Started td-agent: Fluentd based data collector for Treasure Data.
```

If you want to customize systemd behaviour, put your `td-agent.service`
into `/etc/systemd/system`


### init.d

The `/etc/init.d/td-agent` script is provided to start, stop, or restart
the agent.

``` {.CodeRay}
$ sudo /etc/init.d/td-agent start
Starting td-agent: [  OK  ]
$ sudo /etc/init.d/td-agent status
td-agent (pid  21678) is running...
```

The following commands are supported:

``` {.CodeRay}
$ sudo /etc/init.d/td-agent start
$ sudo /etc/init.d/td-agent stop
$ sudo /etc/init.d/td-agent restart
$ sudo /etc/init.d/td-agent status
```

Please make sure **your configuration file** is located at
`/etc/td-agent/td-agent.conf`.


## Step 3: Post Sample Logs via HTTP

By default, `/etc/td-agent/td-agent.conf` is configured to take logs
from HTTP and route them to stdout (`/var/log/td-agent/td-agent.log`).
You can post sample log records using the curl command.

``` {.CodeRay}
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
```


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

Please refer to the resources below for further steps.

-   [ChangeLog of td-agent](http://docs.treasuredata.com/articles/td-agent-changelog)
-   [Chef Cookbook](https://github.com/treasure-data/chef-td-agent/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
