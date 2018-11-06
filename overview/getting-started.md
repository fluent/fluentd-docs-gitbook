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

-   [Install Fluentd by RPM package](articles/install-by-rpm) (Redhat Linux)
-   [Install Fluentd by Deb package](articles/install-by-deb) (Ubuntu/Debian
    Linux)
-   [Install Fluentd by DMG package](articles/install-by-dmg) (Mac OS X)
-   [Install Fluentd by Ruby Gem](articles/install-by-gem)
-   [Install Fluentd by Chef](articles/install-by-chef)
-   [Install Fluentd from source](articles/install-from-source)

Fluentd v0.12 doesn\'t support Windows environment. Please see
[Collecting Log Data from Windows](windows) for details. Fluentd v1.x
supports Windows.

Step2: Use Cases
----------------

The articles shown below cover the typical use cases of Fluentd. Please
refer to the article(s) that suits your needs.

-   Use Cases
    -   [Data Search like Splunk](/articles/free-alternative-to-splunk-by-fluentd)
    -   [Data Filtering and Alerting](/articles/splunk-like-grep-and-alert-email)
    -   [Data Analytics with Treasure Data](/articles/http-to-td)
    -   [Data Collection to MongoDB](/articles/apache-to-mongodb)
    -   [Data Collection to HDFS](/articles/http-to-hdfs)
    -   [Data Archiving to Amazon S3](/articles/apache-to-s3)
    -   [Windows Event Collection](/articles/windows)
-   Basic Configuration
    -   [Config File](/articles/config-file)
-   Application Logs
    -   [Ruby](/articles/ruby), [Java](/articles/java), [Python](/articles/python), [PHP](/articles/php),
        [Perl](/articles/perl), [Node.js](/articles/nodejs), [Scala](/articles/scala)
-   Happy Users :)
    -   [Users](/articles/users)

Step3: Learn More
-----------------

The articles shown below will provide detailed information for you to
learn more about Fluentd.

-   [Architecture Overview](/articles/architecture)
-   [Life of a Fluentd Event](/articles/life-of-a-fluentd-event)
-   Plugin Overview
    -   [Input Plugins](/articles/input-plugin-overview)
    -   [Output Plugins](/articles/output-plugin-overview)
    -   [Buffer Plugins](/articles/buffer-plugin-overview)
    -   [Filter Plugins](/articles/filter-plugin-overview)
    -   [Parser Plugins](/articles/parser-plugin-overview)
    -   [Formatter Plugins](/articles/formatter-plugin-overview)
-   [High Availability Configuration](/articles/high-availability)
-   [FAQ](/articles/faq)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
