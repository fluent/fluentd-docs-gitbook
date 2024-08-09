# Performance Tuning

This article describes how to optimize Fluentd performance within a single process. If your traffic is up to 5,000 messages/sec, the following techniques should be enough.

With more traffic, Fluentd tends to be more CPU bound. In this case, consider using [`multi-worker`](multi-process-workers.md) feature.

## Check your OS Configuration

Follow the [Pre-installation Guide](../installation/before-install.md) to configure your OS properly. This can drastically improve performance, and prevent many unnecessary problems.

## Check `top` Command

If Fluentd does not perform well as expected, check with the `top` command first. Try to identify which part of your system is becoming a bottleneck \(CPU, Memory, Disk I/O, etc.\).

## Avoid Extra Computations

This is a general recommendation. It is suggested **NOT TO HAVE** extra computations inside Fluentd. Fluentd is flexible to do quite a bit internally, but adding too much logic to configuration file makes it difficult to read and maintain while making it less robust. The configuration file should be as simple as possible.

## Use `flush_thread_count` Parameter

If the destination of your logs is remote storage or service, adding a `flush_thread_count` option will parallelize your outputs \(the default is 1\). Using multiple threads can hide the IO/network latency. This parameter is available for all output plugins.

```text
<match test>
  @type output_plugin
  <buffer ...>
    flush_thread_count 8
    # ...
  </buffer>
  # ...
</match>
```

Note that this option does not improve the processing performance e.g. numerical computation, mutating record, etc.

## Use External `gzip` Command for S3/TD

Ruby has GIL \(Global Interpreter Lock\), which allows only one thread to execute at a time. While I/O tasks can be multiplexed, CPU-intensive tasks will block other jobs. One of the CPU-intensive tasks in Fluentd is compression.

The S3/Treasure Data plugin allows compression outside of the Fluentd process, using `gzip`. This frees up the Ruby interpreter while allowing Fluentd to process other tasks.

```text
# S3
<match ...>
  @type s3
  store_as gzip_command
  <buffer ...>
    flush_thread_count 8
    # ...
  </buffer>
  # ...
</match>

# Treasure Data
<match ...>
  @type tdlog
  use_gzip_command
  <buffer ...>
    flush_thread_count 8
    # ...
  </buffer>
  # ...
</match>
```

While not a perfect solution to leverage multiple CPU cores, this can be effective for most Fluentd deployments. As before, you can run this with `flush_thread_count` option as well.

## Reduce Memory Usage

Ruby has several GC parameters to tune GC performance and you can configure these parameters via an environment variable \([Parameter list](https://github.com/ruby/ruby/blob/61701ae1675f790ee3f59207283642dbe64c2d37/gc.c#L7417)\). To reduce memory usage, set `RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR` to a lower value. `RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR` is used for full GC trigger and the default is `2.0`.

Here's a quote from the documentation:

> Do full GC when the number of old objects is more than R * N
> where R is this factor and N is the number of old objects just after last full GC.

So, the default GC behavior does not call full GC until the number of old objects reaches `2.0 * before old objects`. This improves the throughput but it grows the total memory usage. This setting is not good for the low resource environment e.g. a small container. For such cases, try `RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.2`.

{% hint style='danger' %}
Do not set a value lower than `1.0` unless there is a special reason, because there are cases where setting a value lower than `1.0` causes a performance degrade. e.g. delay of launching Fluentd.
{% endhint %}

See [Ruby 2.1 Garbage Collection: ready for production](https://samsaffron.com/archive/2014/04/08/ruby-2-1-garbage-collection-ready-for-production) and [Watching and Understanding the Ruby 2.1 Garbage Collector at Work](https://thorstenball.com/blog/2014/03/12/watching-understanding-ruby-2.1-garbage-collector/) articles for more detail.

## Multi-workers

The CPU is often the bottleneck for Fluentd instances that handle billions of incoming records. To utilize multiple CPU cores, we recommend using the `multi workers` feature.

```text
<system>
  workers 8
</system>
```

For more details on this feature, please read [multi process workers](multi-process-workers.md) article.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

