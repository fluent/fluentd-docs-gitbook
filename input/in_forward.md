forward Input Plugin
====================

The `in_forward` Input plugin listens to a TCP socket to receive the
event stream. It also listens to an UDP socket to receive heartbeat
messages.

This plugin is mainly used to receive event logs from other Fluentd
instances, the fluent-cat command, or client libraries. This is by far
the most efficient way to retrieve the records.
Do **NOT** use this plugin for inter-DC or public internet data transfer
without secure connections. To provide the reliable / low-latency
transfer, we assume this plugin is only used within private networks.

If you open up the port of this plugin to the internet, the attacker can
easily crash Fluentd by using the specific packet. If you require a
secure connection between nodes, please consider using
[in\_secure\_forward](in_secure_forward).


Example Configuration
---------------------

`in_forward` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<source>
  @type forward
  port 24224
  bind 0.0.0.0
</source>
```

Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

Parameters
----------

### \@type (required)

The value must be `forward`.

### port

The port to listen to. Default Value = 24224

### bind

The bind address to listen to. Default Value = 0.0.0.0 (all addresses)

### linger\_timeout

The timeout time used to set linger option. The default is 0

### chunk\_size\_limit

The size limit of the the received chunk. If the chunk size is larger
than this value, then the received chunk is dropped. The default is nil
(no limit).

### chunk\_size\_warn\_limit

The warning size limit of the received chunk. If the chunk size is
larger than this value, a warning message will be sent. The default is
nil (no warning).

### skip\_invalid\_event (v0.12.20 or later)

Skip an event if incoming event is invalid. The default is false.

This option is useful at forwarder, not aggragator. v0.12.20 or later.

### source\_hostname\_key (v0.12.28 or later)

The field name of the client's hostname. If set the value, the client's
hostname will be set to its key. The default is nil (no adding
hostname).

This iterates incoming events. So if you sends larger chunks to
`in_forward`, it needs additional processing time.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.

Protocol
--------

This plugin accepts both JSON or [MessagePack](http://msgpack.org/)
messages and automatically detects which is used. Internally, Fluent
uses MessagePack as it is more efficient than JSON.

The time value is a platform specific integer and is based on the output
of Ruby's `Time.now.to_i` function. On Linux, BSD and MAC systems, this
is the number of seconds since 1970.

Multiple messages may be sent in the same connection.

``` {.CodeRay}
stream:
  message...

message:
  [tag, time, record]
  or
  [tag, [[time,record], [time,record], ...]]

example:
  ["myapp.access", 1308466941, {"a":1}]["myapp.messages", 1308466942, {"b":2}]
  ["myapp.access", [[1308466941, {"a":1}], [1308466942, {"b":2}]]]
```

### Communication with v1.0

v0.12 `in_forward` can't accept data from v1.0 `out_forward` because
time format is different. If you want to forward data from v1.0 to
v0.12, set `time_as_integer` in v1.0 `out_forward`.

FAQ
---

### Why in\_forward doesn't have tag parameter?

`in_forward` uses `tag` of incoming events so no fixed `tag` parameter.
See above "Protocol" section.

### How to parse incoming events?

`in_forward` doesn't provide parsing mechanism unlike `in_tail` or
`in_tcp` because `in_forward` is mainly for efficient log transfer. If
you want to parse incoming event, use [parser
filter](https://github.com/tagomoris/fluent-plugin-parser) in your
pipeline.\
See Docker logging driver usecase: [Docker
Logging](http://www.fluentd.org/guides/recipes/docker-logging)

### I got MessagePack::UnknownExtTypeError error. Why?

This error happens when forwarder's fluentd is v0.14/v1.0 and receiver's
fluentd is 0.12. To avoid this problem, set `time_as_integer` to
`out_forward` setting in v0.14/v1.0 fluentd. See "Communication with
v1.0".


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
