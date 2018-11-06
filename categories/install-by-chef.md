::: {#main .section}
::: {#page}
::: {.topic_content}
::: {style="text-align:right"}
::: {style="text-align:right"}
Versions \| ***v0.12* (td-agent2) **
:::
:::

------------------------------------------------------------------------

Installing Fluentd Using Chef
=============================

This article explains how to install Fluentd using Chef.

[]{#step0:-before-installation}

::: {#table-of-contents .section}
### Table of Contents

-   [Step0: Before Installation](#step0:-before-installation)
-   [Step1: Import Recipe](#step1:-import-recipe)
-   [Step2: Run chef-client](#step2:-run-chef-client)
-   [Next Steps](#next-steps)
:::

Step0: Before Installation
--------------------------

Please follow the [Preinstallation Guide](before-install) to configure
your OS properly. This will prevent many unnecessary problems.

[]{#step1:-import-recipe}

Step1: Import Recipe
--------------------

The chef recipe to install td-agent can be found
[here](https://github.com/treasure-data/chef-td-agent). Please import
the recipe, add it to run\_list, and upload it to the Chef Server.

[]{#step2:-run-chef-client}

Step2: Run chef-client
----------------------

Please run chef-client to install td-agent across your machines.

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
Last updated: 2016-06-06 04:47:13 UTC
:::

------------------------------------------------------------------------

::: {style="text-align:right"}
Versions \| ***v0.12* (td-agent2) **
:::

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
:::
:::
:::
