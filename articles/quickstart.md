# Quickstart Guide

Let's get started with **Fluentd**! **Fluentd** is a fully free and fully open-source log collector that instantly enables you to have a '**Log Everything**' architecture with [600+ types of systems](http://fluentd.org/plugin/).

![](/images/fluentd-architecture.png)

Fluentd treats logs as JSON, a popular machine-readable format. It is
written primarily in C with a thin-Ruby wrapper that gives users flexibility.

Fluentd's scalability has been proven in the field: its largest user
currently collects logs from **500,000+ servers**.


## Step1: Installing Fluentd

Please follow the installation/quickstart guides below that matches your
environment.

-   [Install Fluentd by RPM package](/articles/install-by-rpm.md) (Redhat Linux)
-   [Install Fluentd by Deb package](/articles/install-by-deb.md) (Ubuntu/Debian Linux)
-   [Install Fluentd by DMG package](/articles/install-by-dmg.md) (Mac OS X)
-   [Install Fluentd by Ruby Gem](/articles/install-by-gem.md)
-   [Install Fluentd by Chef](/articles/install-by-chef.md)
-   [Install Fluentd from source](/articles/install-from-source.md)

Fluentd v0.12 doesn't support Windows environment. Please see
[Collecting Log Data from Windows](/use-cases/windows.md) for details. Fluentd v1.x supports Windows.

## Step2: Use Cases

The articles shown below cover the typical use cases of Fluentd. Please
refer to the article(s) that suits your needs.

-   Use Cases
    -   [Data Search like Splunk](/articles/free-alternative-to-splunk-by-fluentd.md)
    -   [Data Filtering and Alerting](/articles/splunk-like-grep-and-alert-email.md)
    -   [Data Analytics with Treasure Data](/articles/http-to-td.md)
    -   [Data Collection to MongoDB](/articles/apache-to-mongodb.md)
    -   [Data Collection to HDFS](/articles/http-to-hdfs.md)
    -   [Data Archiving to Amazon S3](/articles/apache-to-s3.md)
    -   [Windows Event Collection](/use-cases/windows.md)
-   Basic Configuration
    -   [Config File](/configuration/config-file.md)
-   Application Logs
    -   [Ruby](/articles/ruby.md), [Java](/articles/java.md), [Python](/articles/python.md), [PHP](/articles/php.md),
        [Perl](/articles/perl.md), [Node.js](/articles/nodejs.md), [Scala](/articles/scala.md)
-   Happy Users :)
    -   [Users](/articles/users.md)

## Step3: Learn More

The articles shown below will provide detailed information for you to
learn more about Fluentd.

-   [Architecture Overview](https://www.fluentd.org/architecture)
-   [Life of a Fluentd Event](/overview/life-of-a-fluentd-event.md)
-   Plugin Overview
    -   [Input Plugins](/plugins/input/README.md)
    -   [Output Plugins](/plugins/output/README.md)
    -   [Buffer Plugins](/plugins/buffer/README.md)
    -   [Filter Plugins](/plugins/filter/README.md)
    -   [Parser Plugins](/plugins/parser/README.md)
    -   [Formatter Plugins](/plugins/formatter/README.md)
-   [High Availability Configuration](/deployment/high-availability.md)
-   [FAQ](/overview/faq.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
