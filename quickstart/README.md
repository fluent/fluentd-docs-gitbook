# Overview

Let's get started with **Fluentd**! **Fluentd** is a fully free and fully open-source log collector that instantly enables you to have a '**Log Everything**' architecture with [125+ types of systems](https://www.fluentd.org/plugins).

![Fluentd Architecture](../.gitbook/assets/fluentd-architecture%20%281%29%20%282%29%20%282%29%20%282%29%20%283%29.png)

Fluentd treats logs as JSON, a popular machine-readable format. It is written primarily in C with a thin-Ruby wrapper that gives users flexibility.

Fluentd's scalability has been proven in the field: its largest user currently collects logs from **50,000+ servers**.

## Step 1: Installing Fluentd

Please follow the installation/quickstart guides below that matches your environment.

* [Install Fluentd by RPM package](../installation/install-by-rpm.md) \(Red Hat Linux\)
* [Install Fluentd by Deb package](../installation/install-by-deb.md) \(Ubuntu/Debian Linux\)
* [Install Fluentd by MSI package](../installation/install-by-msi.md) \(Windows msi\)
* [Install Fluentd by Ruby Gem](../installation/install-by-gem.md)
* [Install Fluentd from source](../installation/install-from-source.md)

## Step 2: Use Cases

The following articles cover the typical use cases of Fluentd:

* Use Cases
  * [Data Search like Splunk](../how-to-guides/free-alternative-to-splunk-by-fluentd.md)
  * [Data Filtering and Alerting](../how-to-guides/splunk-like-grep-and-alert-email.md)
  * [Data Analytics with Treasure Data](../how-to-guides/http-to-td.md)
  * [Data Collection to MongoDB](../how-to-guides/apache-to-mongodb.md)
  * [Data Collection to HDFS](../how-to-guides/http-to-hdfs.md)
  * [Data Archiving to Amazon S3](../how-to-guides/apache-to-s3.md)
* Basic Configuration
  * [Config File](../configuration/config-file.md)
* Application Logs
  * [Ruby](../language-bindings/ruby.md), [Java](../language-bindings/java.md), [Python](../language-bindings/python.md), [PHP](../language-bindings/php.md),

    [Perl](../language-bindings/perl.md), [Node.js](../language-bindings/nodejs.md), [Scala](../language-bindings/scala.md)
* Happy Users :\)
  * [Users](https://www.fluentd.org/testimonials)

## Step 3: Learn More

The following articles will provide detailed information about Fluentd:

* [Architecture Overview](https://www.fluentd.org/architecture)
* [Lifecycle of a Fluentd Event](life-of-a-fluentd-event.md)
* Plugin Overview
  * [Input Plugins](../input/)
  * [Output Plugins](../output/)
  * [Buffer Plugins](../buffer/)
  * [Filter Plugins](../filter/)
  * [Parser Plugins](../parser/)
  * [Formatter Plugins](../formatter/)
* [High Availability Configuration](../deployment/high-availability.md)
* [FAQ](faq.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under [the Apache License 2.0.](https://www.apache.org/licenses/LICENSE-2.0)

