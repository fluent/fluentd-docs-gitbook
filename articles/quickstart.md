# Quickstart

Let's get started with **Fluentd**! **Fluentd** is a fully free and fully open-source log collector that instantly enables you to have a '**Log Everything**' architecture with [600+ types of systems](http://fluentd.org/plugin/).

![](../.gitbook/assets/fluentd-architecture%20%281%29.png)

Fluentd treats logs as JSON, a popular machine-readable format. It is written primarily in C with a thin-Ruby wrapper that gives users flexibility.

Fluentd's scalability has been proven in the field: its largest user currently collects logs from **500,000+ servers**.

## Step1: Installing Fluentd

Please follow the installation/quickstart guides below that matches your environment.

* [Install Fluentd by RPM package](install-by-rpm.md) \(Redhat Linux\)
* [Install Fluentd by Deb package](install-by-deb.md) \(Ubuntu/Debian Linux\)
* [Install Fluentd by DMG package](install-by-dmg.md) \(Mac OS X\)
* [Install Fluentd by Ruby Gem](install-by-gem.md)
* [Install Fluentd by Chef](install-by-chef.md)
* [Install Fluentd from source](install-from-source.md)

Fluentd v0.12 doesn't support Windows environment. Please see [Collecting Log Data from Windows](../use-cases/windows.md) for details. Fluentd v1.x supports Windows.

## Step2: Use Cases

The articles shown below cover the typical use cases of Fluentd. Please refer to the article\(s\) that suits your needs.

* Use Cases
  * [Data Search like Splunk](free-alternative-to-splunk-by-fluentd.md)
  * [Data Filtering and Alerting](splunk-like-grep-and-alert-email.md)
  * [Data Analytics with Treasure Data](http-to-td.md)
  * [Data Collection to MongoDB](apache-to-mongodb.md)
  * [Data Collection to HDFS](http-to-hdfs.md)
  * [Data Archiving to Amazon S3](apache-to-s3.md)
  * [Windows Event Collection](../use-cases/windows.md)
* Basic Configuration
  * [Config File](../configuration/config-file.md)
* Application Logs
  * [Ruby](ruby.md), [Java](java.md), [Python](python.md), [PHP](php.md),

    [Perl](perl.md), [Node.js](nodejs.md), [Scala](scala.md)
* Happy Users :\)
  * [Users](https://github.com/fluent/fluentd-docs-gitbook/tree/c21f9269df12a1f728b4ec63fa20b57ff387ba2d/articles/users.md)

## Step3: Learn More

The articles shown below will provide detailed information for you to learn more about Fluentd.

* [Architecture Overview](https://www.fluentd.org/architecture)
* [Life of a Fluentd Event](../quickstart/life-of-a-fluentd-event.md)
* Plugin Overview
  * [Input Plugins](../input/)
  * [Output Plugins](../output/)
  * [Buffer Plugins](../buffer/)
  * [Filter Plugins](../filter/)
  * [Parser Plugins](../parser/)
  * [Formatter Plugins](../formatter/)
* [High Availability Configuration](../deployment/high-availability.md)
* [FAQ](../quickstart/faq.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

