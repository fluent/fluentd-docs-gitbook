# High Availability Config

For high-traffic websites, we recommend using a high-availability configuration for `Fluentd`.

See also [The Patterns of Distributed Logging and Containers](https://www.slideshare.net/tagomoris/the-patterns-of-distributed-logging-and-containers) slide for understanding pros/cons of deployment patterns.

## Message Delivery Semantics

Fluentd is designed primarily for event-log delivery systems.

In such systems, several delivery guarantees are possible:

* **At most once**: Messages are immediately transferred. If the

  transfer succeeds, the message is never sent out again. However,

  many failure scenarios can cause lost messages \(e.g. no more write

  capacity\).

* **At least once**: Each message is delivered at least once. In failure

  cases, messages may be delivered twice.

* **Exactly once**: Each message is delivered once and only once. This

  is the most desirable.

If the system "**can't lose a single event**" and must also transfer "**exactly once**", then the system must stop ingesting events when it runs out of write capacity. The proper approach would be to use synchronous logging and return errors when the event cannot be accepted.

That's why Fluentd provides "**at most once**" and "**at least once**" transfers. To collect massive amounts of data without impacting application performance, a data logger must transfer data asynchronously. This improves performance at the cost of potential delivery failures.

However, most failure scenarios are preventable. The following sections describe how to set up Fluentd's topology for high-availability.

## Network Topology

To configure Fluentd for high-availability, we assume that your network consists of **log forwarders** and **log aggregators**.

![Fluentd&apos;s High-Availability Overview](../.gitbook/assets/fluentd_ha%20%281%29%20%281%29%20%281%29.png)

'**Log forwarders**' are typically installed on every node to receive local events. Once an event is received, they forward it to the 'log aggregators' through the network. For log forwarders, [fluent-bit](https://fluentbit.io/) is also good candidate for light-weight processing.

'**Log aggregators**' are daemons that continuously receive events from the log forwarders. They buffer the events and periodically upload the data into the cloud.

Fluentd can act as either a log forwarder or a log aggregator, depending on its configuration. The next sections describe the respective setups. We assume that the active log aggregator has an IP **192.168.0.1** and the backup has IP **192.168.0.2**.

## Log Forwarder Configuration

Use the following configuration to configure **log forwarders** to transfer logs to **log aggregators**:

```text
# TCP input
<source>
  @type forward
  port 24224
</source>

# HTTP input
<source>
  @type http
  port 8888
</source>

# Log Forwarding
<match mytag.**>
  @type forward

  # primary host
  <server>
    host 192.168.0.1
    port 24224
  </server>
  # use secondary host
  <server>
    host 192.168.0.2
    port 24224
    standby
  </server>

  # use longer flush_interval to reduce CPU usage.
  # note that this is a trade-off against latency.
  <buffer>
    flush_interval 60s
  </buffer>
</match>
```

When the active aggregator \(192.168.0.1\) dies, the logs will instead be sent to the backup aggregator \(192.168.0.2\). If both servers die, the logs are buffered on-disk at the corresponding forwarder nodes.

## Log Aggregator Configuration

Use the following configuration for **log aggregators** to configure the input source for the log transfer as TCP:

```text
# Input
<source>
  @type forward
  port 24224
</source>

# Output
<match mytag.**>
  # ...
</match>
```

The incoming logs are buffered, then periodically uploaded to the cloud. If the upload fails, the logs are stored on the local disk until the retransmission succeeds.

## Failure Case Scenarios

### Forwarder Failure

When a log forwarder receives events from applications, the events are first written into a disk buffer \(specified by `<buffer>`'s `path`\). After every `flush_interval`, the buffered data is forwarded to aggregators.

This process is inherently robust against data loss. If a log forwarder's fluentd process dies, then on its restart, the buffered data is properly transferred to its aggregator. If the network between forwarders and aggregators breaks, the data transfer is automatically retried.

However, possible message loss scenarios do exist:

* The process dies immediately after receiving the events, but before writing

  them into the buffer.

* The forwarder's disk is broken, and the file buffer is lost.

### Aggregator Failure

When log aggregators receive events from log forwarders, the events are first written into a disk buffer \(specified by `<buffer>`'s `path`\). After every `flush_interval`, the buffered data is uploaded to the cloud.

This process is inherently robust against data loss. If a log aggregator's fluentd process dies, then on its restart, the data from the log forwarder is properly retransferred. If the network between aggregators and the cloud breaks, the data transfer is automatically retried.

However, possible message loss scenarios do exist:

* The process dies immediately after receiving the events, but before writing

  them into the buffer.

* The aggregator's disk is broken, and the file buffer is lost.

## Troubleshooting

### "no nodes are available"

Please make sure that you can communicate with port 24224 using **not only TCP, but also UDP**. These commands will be useful for checking the network configuration:

```text
$ telnet host 24224
$ nmap -p 24224 -sU host
```

Please note that there is one [known issue](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2019944) where VMware will occasionally lose small UDP packages used for the heartbeat.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

