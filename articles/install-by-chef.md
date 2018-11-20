# Installing Fluentd Using Chef

This article explains how to install Fluentd using Chef.


## Step0: Before Installation

Please follow the [Preinstallation Guide](/articles/before-install.md) to configure
your OS properly. This will prevent many unnecessary problems.

## Step1: Import Recipe

The chef recipe to install td-agent can be found
[here](https://github.com/treasure-data/chef-td-agent). Please import
the recipe, add it to run\_list, and upload it to the Chef Server.

## Step2: Run chef-client

Please run chef-client to install td-agent across your machines.

## Next Steps

You're now ready to collect your real logs using Fluentd. Please see the
following tutorials to learn how to collect your data from various data
sources.

-   Basic Configuration
    -   [Config File](/configuration/config-file.md)
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
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
