# Quickstart Guide

Let's get started with **Fluentd**! **Fluentd** is a fully free and
fully open-source log collector that instantly enables you to have a
'**Log Everything**' architecture with [125+ types of systems](https://www.fluentd.org/plugins).

![](/images/fluentd-architecture.png)

Fluentd treats logs as JSON, a popular machine-readable format. It is
written primarily in C with a thin-Ruby wrapper that gives users
flexibility.

Fluentd's scalability has been proven in the field: its largest user
currently collects logs from **50,000+ servers**.


## Step 1: Installing Fluentd

Please follow the installation/quickstart guides below that matches your
environment.

-   [Install Fluentd by RPM package](/install/install-by-rpm.md) (Redhat Linux)
-   [Install Fluentd by Deb package](/install/install-by-deb.md) (Ubuntu/Debian Linux)
-   [Install Fluentd by MSI package](/install/install-by-msi.md) (Windows msi)
-   [Install Fluentd by Ruby Gem](/install/install-by-gem.md)
-   [Install Fluentd from source](/install/install-from-source.md)


## Step 2: Use Cases

The articles shown below cover the typical use cases of Fluentd. Please
refer to the article(s) that suits your needs.

-   Use Cases
    -   [Data Search like Splunk](/guides/free-alternative-to-splunk-by-fluentd.md)
    -   [Data Filtering and Alerting](/guides/splunk-like-grep-and-alert-email.md)
    -   [Data Analytics with Treasure Data](/guides/http-to-td.md)
    -   [Data Collection to MongoDB](/guides/apache-to-mongodb.md)
    -   [Data Collection to HDFS](/guides/http-to-hdfs.md)
    -   [Data Archiving to Amazon S3](/guides/apache-to-s3.md)
-   Basic Configuration
    -   [Config File](/configuration/config-file.md)
-   Application Logs
    -   [Ruby](/language/ruby.md), [Java](/language/java.md), [Python](/language/python.md), [PHP](/language/php.md),
        [Perl](/language/perl.md), [Node.js](/language/nodejs.md), [Scala](/language/scala.md)
-   Happy Users :)
    -   [Users](https://www.fluentd.org/testimonials)


## Step 3: Learn More

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

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
