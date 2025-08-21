# Overview

* Fluentd
  * 👀treats logs -- as -- JSON👀
  * written | C + thin-Ruby wrapper
  * can collect logs -- from -- **50,000+ servers**

## Step 1: Installing Fluentd

* [Installation](../installation/)

## Step 2: Use Cases

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
