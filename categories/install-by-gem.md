::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/install-by-gem) \|
***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

Installing Fluentd Using Ruby Gem
=================================

This article explains how to install Fluentd using Ruby gem.

[]{#step0:-before-installation}

::: {#table-of-contents .section}
### Table of Contents

-   [Step0: Before Installation](#step0:-before-installation)
-   [Step1: Install Ruby interpreter](#step1:-install-ruby-interpreter)
-   [Step2: Install Fluentd gem](#step2:-install-fluentd-gem)
-   [Step3: Run](#step3:-run)
-   [Next Steps](#next-steps)
:::

Step0: Before Installation
--------------------------

Please follow the [Preinstallation Guide](before-install) to configure
your OS properly. This will prevent many unnecessary problems.

[]{#step1:-install-ruby-interpreter}

Step1: Install Ruby interpreter
-------------------------------

Please install Ruby \>= 1.9.3 on your local environment. In addition,
install ruby-dev package via package manager to build native extension
gems.

[]{#step2:-install-fluentd-gem}

Step2: Install Fluentd gem
--------------------------

Fetch and install the `fluentd` Ruby gem using the `gem` command. The
official ruby gem page is [here](https://rubygems.org/gems/fluentd).

``` {.CodeRay}
$ gem install fluentd -v "~> 0.12.0" --no-ri --no-rdoc
```

`-v "~> 0.12.0"` is needed for v0.12 installation. Without it, you
install v0.14 series.

[]{#step3:-run}

Step3: Run
----------

Run the following commands to confirm that Fluentd was installed
successfully:

``` {.CodeRay}
$ fluentd --setup ./fluent
$ fluentd -c ./fluent/fluent.conf -vv & # -vv enables trace level logs. You can omit -vv option.
$ echo '{"json":"message"}' | fluent-cat debug.test
```

The last command sends Fluentd a message '{"json":"message"}' with a
"debug.test" tag. If the installation was successful, Fluentd will
output the following message:

``` {.CodeRay}
2011-07-10 16:49:50 +0900 debug.test: {"json":"message"}
```
:::
:::
:::

It\'s HIGHLY recommended that you set up **ntpd** on the node to prevent
invalid timestamps in your logs.

For large deployments, you must use
[jemalloc](http://www.canonware.com/jemalloc/) to avoid memory
fragmentation. This is already included in the [rpm](install-by-rpm) and
[deb](install-by-deb) packages.

The Fluentd gem doesn\'t come with /etc/init.d/ scripts. You should use
process management tools such as
[daemontools](http://cr.yp.to/daemontools.html),
[runit](http://smarden.org/runit/),
[supervisord](http://supervisord.org/), or
[upstart](http://upstart.ubuntu.com/).

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

::: {style="text-align:right"}
Last updated: 2017-01-31 02:32:30 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| [v1.0 (td-agent3)](/v1.0/articles/install-by-gem) \|
***v0.12* (td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
