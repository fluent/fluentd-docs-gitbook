forward Output Plugin
=====================

The `out_forward` Buffered Output plugin forwards events to other
fluentd nodes. This plugin supports load-balancing and automatic
fail-over (a.k.a. active-active backup). For replication, please use the
[out\_copy](out_copy) plugin.

The `out_forward` plugin detects server faults using a "φ accrual
failure detector" algorithm. You can customize the parameters of the
algorithm. When a server fault recovers, the plugin makes the server
available automatically after a few seconds.

The `out_forward` plugin supports at-most-once and at-least-once
semantics. The default is at-most-once.
Do **NOT** use this plugin for inter-DC or public internet data transfer
without secure connections. All the data is not encrypted, and this
plugin is not designed for high-latency network environment. If you
require a secure connection between nodes, please consider using
[in\_secure\_forward](in_secure_forward).


Example Configuration
---------------------

`out_forward` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<match pattern>
  @type forward
  send_timeout 60s
  recover_wait 10s
  hard_timeout 60s

  <server>
    name myserver1
    host 192.168.1.3
    port 24224
    weight 60
  </server>
  <server>
    name myserver2
    host 192.168.1.4
    port 24224
    weight 60
  </server>
  ...

  <secondary>
    @type file
    path /var/log/fluent/forward-failed
  </secondary>
</match>
```

Please see the [Config File](config-file.md) article for the basic
structure and syntax of the configuration file.

Parameters
----------

### \@type (required)

The value must be `forward`.

### \<server\> (at least one is required)

The destination servers. Each server must have following information.

-   *name*: The name of the server. This parameter is used in error
    messages.
-   *host* (required): The IP address or host name of the server.
-   *port*: The port number of the host. The default is `24224`. Note
    that both TCP packets (event stream) and UDP packets (heartbeat
    message) are sent to this port.
-   *weight*: The load balancing weight. If the weight of one server is
    20 and the weight of the other server is 30, events are sent in a
    2:3 ratio. The default weight is 60.
-   *standby*: Set the destination to standby node. The default is
    `false`. standby servers will be selected when all non-standby
    servers went down.

### require\_ack\_response

Change the protocol to at-least-once. The plugin waits the ack from
destination's in\_forward plugin.

### ack\_response\_timeout

This option is used when `require_ack_response` is `true`. The default
is 190. This default value is based on popular tcp\_syn\_retries.

If set `0`, this plugin doesn't wait the ack response.

### \<secondary\> (optional)

The backup destination that is used when all servers are unavailable.

### send\_timeout

The timeout time when sending event logs. The default is 60 seconds.

### recover\_wait

The wait time before accepting a server fault recovery. The default is
10 seconds.

### heartbeat\_type

The transport protocol to use for heartbeats. The default is "udp", but
you can select "tcp" as well. Set "none" to disable heartbeat.

### heartbeat\_interval

The interval of the heartbeat packer. The default is 1 second.

### phi\_failure\_detector

Use the "Phi accrual failure detector" to detect server failure. The
default value is `true`.

### phi\_threshold

The threshold parameter used to detect server faults. The default value
is 16.

\`phi\_threshold\` is deeply related to \`heartbeat\_interval\`. If you
are using longer \`heartbeat\_interval\`, please use the larger
\`phi\_threshold\`. Otherwise you will see frequent detachments of
destination servers. The default value 16 is tuned for
\`heartbeat\_interval\` 1s.

### hard\_timeout

The hard timeout used to detect server failure. The default value is
equal to the send\_timeout parameter.

### standby

Marks a node as the standby node for an Active-Standby model between
Fluentd nodes. When an active node goes down, the standby node is
promoted to an active node. The standby node is not used by the
`out_forward` plugin until then.

``` {.CodeRay}
<match pattern>
  @type forward
  ...

  <server>
    name myserver1
    host 192.168.1.3
    weight 60
  </server>
  <server>  # forward doesn't use myserver2 until myserver1 goes down
    name myserver2
    host 192.168.1.4
    weight 60
    standby
  </server>
  ...
</match>
```

### expire\_dns\_cache

Set TTL to expire DNS cache in seconds. Set 0 not to use DNS Cache. The
default is nil (which means the persistent cache).

### dns\_round\_robin

Enable client-side DNS round robin. Uniform randomly pick an IP address
to send data when a hostname has serveral IP addresses.

\`heartbeat\_type udp\` is not available with \`dns\_round\_robin
true\`. Use \`heartbeat\_type tcp\` or \`heartbeat\_type none\`.

Buffered Output Parameters
--------------------------

For advanced usage, you can tune Fluentd's internal buffering mechanism
with these parameters.

### buffer\_type

The buffer type is `memory` by default ([buf\_memory](buf_memory)) for
the ease of testing, however `file` ([buf\_file](buf_file)) buffer type
is always recommended for the production deployments. If you use `file`
buffer type, `buffer_path` parameter is required.

### buffer\_queue\_limit, buffer\_chunk\_limit

The length of the chunk queue and the size of each chunk, respectively.
Please see the [Buffer Plugin Overview](buffer-plugin-overview.md) article
for the basic buffer structure. The default values are 64 and 8m,
respectively. The suffixes "k" (KB), "m" (MB), and "g" (GB) can be used
for buffer\_chunk\_limit.

### flush\_interval

The interval between data flushes. The default is 60s. The suffixes "s"
(seconds), "m" (minutes), and "h" (hours) can be used.

### flush\_at\_shutdown

If set to true, Fluentd waits for the buffer to flush at shutdown. By
default, it is set to true for Memory Buffer and false for File Buffer.

### retry\_wait, max\_retry\_wait

The initial and maximum intervals between write retries. The default
values are 1.0 seconds and unset (no limit). The interval doubles (with
+/-12.5% randomness) every retry until `max_retry_wait` is reached.

Since td-agent will retry 17 times before giving up by default (see the
`retry_limit` parameter for details), the sleep interval can be up to
approximately 131072 seconds (roughly 36 hours) in the default
configurations.

### retry\_limit, disable\_retry\_limit

The limit on the number of retries before buffered data is discarded,
and an option to disable that limit (if true, the value of `retry_limit`
is ignored and there is no limit). The default values are 17 and false
(not disabled). If the limit is reached, buffered data is discarded and
the retry interval is reset to its initial value (`retry_wait`).

### num\_threads

The number of threads to flush the buffer. This option can be used to
parallelize writes into the output(s) designated by the output plugin.
Increasing the number of threads improves the flush throughput to hide
write / network latency. The default is 1.

### slow\_flush\_log\_threshold

The threshold for checking chunk flush performance. The default value is
`20.0` seconds. Note that parameter type is `float`, not `time`.

If chunk flush takes longer time than this threshold, fluentd logs
warning message like below:

``` {.CodeRay}
2016-12-19 12:00:00 +0000 [warn]: buffer flush took longer time than slow_flush_log_threshold: elapsed_time = 15.0031226690043695 slow_flush_log_threshold=10.0 plugin_id="foo"
```

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging.md) for further details.

Troubleshooting
---------------

### "no nodes are available"

Please make sure that you can communicate with port 24224 using **not
only TCP, but also UDP**. These commands will be useful for checking the
network configuration.

``` {.CodeRay}
$ telnet host 24224
$ nmap -p 24224 -sU host
```

Please note that there is one [known
issue](http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2019944)
where VMware will occasionally lose small UDP packets used for
heartbeat.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
