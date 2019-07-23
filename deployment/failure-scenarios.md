# Failure Scenarios

This article lists various Fluentd failure scenarios. We will assume
that you have configured Fluentd for [High Availability](/deployment/high-availability.md), so that each app node has its local
*forwarders* and all logs are aggregated into multiple *aggregators*.


## Apps Cannot Post Records to Forwarder

In the failure scenario, the application sometimes fails to post records
to its local Fluentd instance when using logger libraries of various
languages. Depending on the maturity of each logger library, some clever
mechanisms have been implemented to prevent data loss.

#### 1) Memory Buffering (available for [Ruby](/articles/ruby.md), [Java](/articles/java.md), [Python](/articles/python.md), [Perl](/articles/perl.md))

If the destination Fluentd instance dies, certain logger implementations
will use extra memory to hold incoming logs. When Fluentd comes back,
these loggers will automatically send out the buffered logs to Fluentd
again. Once the maximum buffer memory size is reached, most current
implementations will write the data onto the disk or throw away the
logs.

#### 2) Exponential Backoff (available for [Ruby](/articles/ruby.md), [Java](/articles/java.md))

When trying to resend logs to the local forwarder, some implementations
will use exponential backoff to prevent excessive re-connect requests.

## Forwarder or Aggregator Fluentd Goes Down

What happens when a Fluentd process dies for some reason? It depends on
your buffer configuration.

#### buf\_memory

If you're using [buf\_memory](/plugins/buffer/memory.md), the buffered data is
completely lost. This is a tradeoff for higher performance. Lowering the
flush\_interval will reduce the probability of losing data, but will
increase the number of transfers between forwarders and aggregators.

#### buf\_file

If you're using [buf\_file](/plugins/buffer/file.md), the buffered data is stored on
the disk. After Fluentd recovers, it will try to send the buffered data
to the destination again.

Please note that the data will be lost if the buffer file is broken due
to I/O errors. The data will also be lost if the disk is full, since
there is nowhere to store the data on disk.

## Storage Destination Goes Down

If the storage destination (e.g. Amazon S3, MongoDB, HDFS, etc.) goes
down, Fluentd will keep trying to resend the buffered data. The retry
logic depends on the plugin implementation.

If you're using [buf\_memory](/plugins/buffer/memory.md), aggregators will stop
accepting new logs once they reach their buffer limits. If you're using
[buf\_file](/plugins/buffer/file.md), aggregators will continue accepting logs until
they run out of disk space.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
