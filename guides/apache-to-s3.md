# Store Apache Logs into Amazon S3

This article explains how to use [Fluentd](http://fluentd.org/)'s Amazon
S3 Output plugin ([out\_s3](/plugins/output/s3.md)) to aggregate semi-structured logs
in real-time.


## Background

[Fluentd](http://fluentd.org/) is an advanced open-source log collector
originally developed at [Treasure Data, Inc](http://www.treasuredata.com/). One of the main objectives of log aggregation is data archiving. [Amazon S3](http://aws.amazon.com/s3/), the cloud object storage provided by Amazon, is a popular solution for data archiving.

This article will show you how to use [Fluentd](http://fluentd.org/) to
import Apache logs into Amazon S3.


## Mechanism

Fluentd does 3 things:

1.  It continuously "tails" the access log file.
2.  It parses the incoming log entries into meaningful fields (such as
    `ip`, `path`, etc.) and buffers them.
3.  It writes the buffered data to Amazon S3 periodically.


## Install

For simplicity, this article will describe how to set up an one-node
configuration. Please install the following software on the same node.

-   [Fluentd](http://fluentd.org/)
-   [Amazon S3 Output Plugin](/plugins/output/s3.md)
-   Your Amazon Web Services Account
-   Apache (with the Combined Log Format)

The Amazon S3 Output plugin is included in the latest version of
Fluentd's deb/rpm package. If you want to use Ruby Gems to install the
plugin, please use `gem install fluent-plugin-s3`.

-   [Debian Package](/install/install-by-deb.md)
-   [RPM Package](/install/install-by-rpm.md)
-   [Ruby gem](/install/install-by-gem.md)


## Configuration

Let's start configuring Fluentd. If you used the deb/rpm package,
Fluentd's config file is located at /etc/td-agent/td-agent.conf.
Otherwise, it is located at /etc/fluentd/fluentd.conf.


### Tail Input

For the input source, we will set up Fluentd to track the recent Apache
logs (typically found at /var/log/apache2/access\_log) The Fluentd
configuration file should look like this:

```
<source>
  @type tail
  path /var/log/apache2/access_log
  pos_file /var/log/td-agent/apache2.access_log.pos
  <parse>
    @type apache2
  </parse>
  tag s3.apache.access
</source>
```

Please make sure that your Apache outputs are in the default
\'combined\' format. \`format apache2\` cannot parse custom log formats.
Please see the [in\_tail](/plugins/input/tail.md) article for more information.

Let's go through the configuration line by line.

1.  `type tail`: The tail Input plugin continuously tracks the log file.
    This handy plugin is included in Fluentd's core.
2.  `@type apache2` in `<parse>`: Uses Fluentd's built-in Apache log
    parser.
3.  `path /var/log/apache2/access_log`: The location of the Apache log.
    This may be different for your particular system.
4.  `tag s3.apache.access`: `s3.apache.access` is used as the tag to
    route the messages within Fluentd.

That's it! You should now be able to output a JSON-formatted data stream
for Fluentd to process.


### Amazon S3 Output

The output destination will be Amazon S3. The output configuration
should look like this:

```
<match s3.*.*>
  @type s3

  aws_key_id YOUR_AWS_KEY_ID
  aws_sec_key YOUR_AWS_SECRET/KEY
  s3_bucket YOUR_S3_BUCKET_NAME
  path logs/

  <buffer>
    @type file
    path /var/log/td-agent/s3
    timekey_wait 10m
    chunk_limit_size 256m
  </buffer>

  time_slice_format %Y%m%d%H
</match>
```

The match section specifies the regexp used to look for matching tags.
If a matching tag is found in a log, then the config inside
`<match>...</match>` is used (i.e. the log is routed according to the
config inside). In this example, the `s3.apache.access` tag (generated
by `tail`) is always used.


## Test

To test the configuration, just ping the Apache server. This example
uses the `ab` (Apache Bench) program.

```
$ ab -n 100 -c 10 http://localhost/
```

Then, log into your [AWS Console](https://console.aws.amazon.com/s3/home) and look at your
bucket.

WARNING: By default, files are created on an hourly basis (around
xx:10). This means that when you first import records using the plugin,
no file is created immediately. The file will be created when the
`time_slice_format` condition has been met. To change the output
frequency, please modify the `time_slice_format` value. To write files
every minute, please use `%Y%m%d%H%M` for the `time_slice_format`.


## Conclusion

Fluentd + Amazon S3 makes real-time log archiving simple.


## Learn More

-   [Fluentd Architecture](//www.fluentd.org/architecture)
-   [Fluentd Get Started](/overview/quickstart.md)
-   [Amazon S3 Output plugin](/plugins/output/s3.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
