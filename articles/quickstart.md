Quickstart Guide
================

Let's get started with **Fluentd**! **Fluentd** is a fully free and
fully open-source log collector that instantly enables you to have a
'**Log Everything**' architecture with [600+ types of
systems](http://fluentd.org/plugin/).

![](/images/fluentd-architecture.png)
Fluentd treats logs as JSON, a popular machine-readable format. It is
written primarily in C with a thin-Ruby wrapper that gives users
flexibility.

Fluentd's scalability has been proven in the field: its largest user
currently collects logs from **500,000+ servers**.


Step1: Installing Fluentd
-------------------------

Please follow the installation/quickstart guides below that matches your
environment.

-   [Install Fluentd by RPM package](install-by-rpm.md) (Redhat Linux)
-   [Install Fluentd by Deb package](install-by-deb.md) (Ubuntu/Debian
    Linux)
-   [Install Fluentd by DMG package](install-by-dmg.md) (Mac OS X)
-   [Install Fluentd by Ruby Gem](install-by-gem.md)
-   [Install Fluentd by Chef](install-by-chef.md)
-   [Install Fluentd from source](install-from-source.md)
Fluentd v0.12 doesn\'t support Windows environment. Please see
[Collecting Log Data from Windows](windows.md) for details. Fluentd v1.x
supports Windows.

Step2: Use Cases
----------------

The articles shown below cover the typical use cases of Fluentd. Please
refer to the article(s) that suits your needs.

-   Use Cases
    -   [Data Search like Splunk](free-alternative-to-splunk-by-fluentd.md)
    -   [Data Filtering and Alerting](splunk-like-grep-and-alert-email.md)
    -   [Data Analytics with Treasure Data](http-to-td.md)
    -   [Data Collection to MongoDB](apache-to-mongodb.md)
    -   [Data Collection to HDFS](http-to-hdfs.md)
    -   [Data Archiving to Amazon S3](/articles/apache-to-s3.md)
    -   [Windows Event Collection](windows.md)
-   Basic Configuration
    -   [Config File](config-file.md)
-   Application Logs
    -   [Ruby](ruby.md), [Java](java.md), [Python](python.md), [PHP](php.md),
        [Perl](perl.md), [Node.js](nodejs.md), [Scala](scala.md)
-   Happy Users :)
    -   [Users](users.md)

Step3: Learn More
-----------------

The articles shown below will provide detailed information for you to
learn more about Fluentd.

-   [Architecture Overview](/articles/architecture.md)
-   [Life of a Fluentd Event](life-of-a-fluentd-event.md)
-   Plugin Overview
    -   [Input Plugins](input-plugin-overview.md)
    -   [Output Plugins](output-plugin-overview.md)
    -   [Buffer Plugins](buffer-plugin-overview.md)
    -   [Filter Plugins](filter-plugin-overview.md)
    -   [Parser Plugins](parser-plugin-overview.md)
    -   [Formatter Plugins](formatter-plugin-overview.md)
-   [High Availability Configuration](high-availability.md)
-   [FAQ](faq.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
