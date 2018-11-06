::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/install-by-deb) \|
***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

Installing Fluentd Using deb Package
====================================

This article explains how to install the td-agent deb package, the
stable Fluentd distribution package maintained by [Treasure Data,
Inc](http://www.treasuredata.com/).


### Table of Contents

-   [What is td-agent?](#what-is-td-agent?)
-   [Step 0: Before Installation](#step-0:-before-installation)
-   [Step 1 : Install from Apt
    Repository](#step-1-:-install-from-apt-repository)
-   [Step2: Launch Daemon](#step2:-launch-daemon)
-   [Step3: Post Sample Logs via
    HTTP](#step3:-post-sample-logs-via-http)
-   [Next Steps](#next-steps)
:::

What is td-agent?
-----------------

Fluentd is written in Ruby for flexibility, with performance sensitive
parts written in C. However, some users may have difficulty installing
and operating a Ruby daemon.

That's why [Treasure Data, Inc](http://www.treasuredata.com/) is
providing **the stable community distribution of Fluentd**, called
`td-agent`. The differences between Fluentd and td-agent can be found
[here](//www.fluentd.org/faqs).

Currently, td-agent 2 deb has two versions, td-agent 2.5 / td-agent 2.3.
The different point is bundled ruby version. td-agent 2.5 or later uses
ruby 2.5 and td-agent 2.3 or earlier uses ruby 2.1. ruby 2.1 is EOL so
we recommend to use td-agent 2.5 for new deployment. td-agent 2.5 and
td-agent 2.3 use fluentd v0.12 serise so the behaviour is same.

[]{#step-0:-before-installation}

Step 0: Before Installation
---------------------------

Please follow the [Preinstallation Guide](before-install) to configure
your OS properly. This will prevent many unnecessary problems.

[]{#step-1-:-install-from-apt-repository}

Step 1 : Install from Apt Repository
------------------------------------

For Ubuntu, we currently support "Ubuntu 18.04 LTS / Bionic 64bit",
"Ubuntu 16.04 LTS / Xenial 64bit", "Ubuntu 14.04 LTS / Trusty
64bit/32bit", "Ubuntu 12.04 LTS / Precise 64bit/32bit", "Ubuntu 10.04
LTS / Lucid 64bit/32bit".

For Debian, we currently support Jessie, Wheezy and Squeeze. There is no
32bit packages for Debian.
:::
:::
:::

We might not provide td-agent for older distributions. For example, we
don\'t provide latest td-agent version for squeeze and lucid for now.

A shell script is provided to automate the installation process for each
version. The shell script registers a new apt repository at
`/etc/apt/sources.list.d/treasure-data.list` and installs the `td-agent`
deb package.

For Bionic,

``` {.CodeRay}
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent2.5.sh | sh
```

For Xenial,

``` {.CodeRay}
# td-agent 2.5 or later
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent2.5.sh | sh
# td-agent 2.3 or earlier
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-xenial-td-agent2.sh | sh
```

For Trusty,

``` {.CodeRay}
# td-agent 2.5 or later
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.5.sh | sh
# td-agent 2.3 or earlier
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-trusty-td-agent2.sh | sh
```

For Precise,

``` {.CodeRay}
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-precise-td-agent2.sh | sh
```

For Lucid,

``` {.CodeRay}
curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-lucid-td-agent2.sh | sh
```

For Debian Stretch,

``` {.CodeRay}
curl -L https://toolbelt.treasuredata.com/sh/install-debian-stretch-td-agent2.sh | sh
```

For Debian Jessie,

``` {.CodeRay}
curl -L https://toolbelt.treasuredata.com/sh/install-debian-jessie-td-agent2.sh | sh
```

For Debian Wheezy,

``` {.CodeRay}
curl -L https://toolbelt.treasuredata.com/sh/install-debian-wheezy-td-agent2.sh | sh
```

For Debian Squeeze,

``` {.CodeRay}
curl -L https://toolbelt.treasuredata.com/sh/install-debian-squeeze-td-agent2.sh | sh
```

It's HIGHLY recommended that you set up **ntpd** on the node to prevent
invalid timestamps in your logs. Please check the [Preinstallation
Guide](before-install).

[]{#step2:-launch-daemon}

Step2: Launch Daemon
--------------------

The `/etc/init.d/td-agent` script is provided to start, stop, or restart
the agent.

``` {.CodeRay}
$ sudo /etc/init.d/td-agent restart
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

[]{#step3:-post-sample-logs-via-http}

Step3: Post Sample Logs via HTTP
--------------------------------

By default, `/etc/td-agent/td-agent.conf` is configured to take logs
from HTTP and route them to stdout (`/var/log/td-agent/td-agent.log`).
You can post sample log records using the curl command.

``` {.CodeRay}
$ curl -X POST -d 'json={"json":"message"}' http://localhost:8888/debug.test
```

[]{#next-steps}

Next Steps
----------

You're now ready to collect your real logs using Fluentd. Please see the
following tutorials to learn how to collect your data from various data
sources.

-   Basic Configuration
    -   [Config File](config-file)
-   Application Logs
    -   [Ruby](ruby), [Java](java), [Python](python), [PHP](php),
        [Perl](perl), [Node.js](nodejs), [Scala](scala)
-   Examples
    -   [Store Apache Log into Amazon S3](apache-to-s3)
    -   [Store Apache Log into MongoDB](apache-to-mongodb)
    -   [Data Collection into HDFS](http-to-hdfs)

Please refer to the resources below for further steps.

-   [ChangeLog of
    td-agent](http://docs.treasuredata.com/articles/td-agent-changelog)
-   [Chef Cookbook](https://github.com/treasure-data/chef-td-agent/)

::: {style="text-align:right"}
Last updated: 2016-07-11 22:54:57 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/install-by-deb) \|
***v0.12* (td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
