UDP Input Plugin
================

The `in_udp` Input plugin enables Fluentd to accept UDP payload.


Example Configuration
---------------------

`in_udp` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<source>
  @type udp
  tag mytag # required
  format /^(?<field1>\d+):(?<field2>\w+)$/ # required
  port 20001 # optional. 5160 by default
  bind 0.0.0.0 # optional. 0.0.0.0 by default
  body_size_limit 1MB # optional. 4096 bytes by default
</source>
```
Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

We\'ve observed the drastic performance improvements on Linux, with
proper kernel parameter settings (e.g. \`net.core.rmem\_max\`
parameter). If you have high-volume UDP traffic, please make sure to
follow the instruction described at [Before Installing
Fluentd](before-install).

Parameters
----------

### \@type (required)

The value must be `udp`.

### tag (required)

tag of output events.

#### port

The port to listen to. Default Value = 5160

### bind

The bind address to listen to. Default Value = 0.0.0.0

### source\_hostname\_key

The field name of the client's hostname. If set the value, the client's
hostname will be set to its key. The default is nil (no adding
hostname).

If you set following configuration:

``` {.CodeRay}
source_hostname_key client_host
```

then the client's hostname is set to `client_host` field.

``` {.CodeRay}
{
    ...
    "foo": "bar",
    "client_host": "client.hostname.org"
}
```

### format (required)

The format of the UDP payload. `in_udp` uses parser plugin to parse the
payload. See [parser article](parser-plugin-overview) for more detail.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.

FAQ
---

### How to prevent request drop?

If in\_udp gots lots of packets within 1 sec, some packets are dropped.
For example, you can see bigger RcvbufErrors number via `netstat -su`.

This means in\_udp with one process can't handle such traffic. Try
[fluent-plugin-multiprocess](https://github.com/fluent/fluent-plugin-multiprocess)
to resolve the problem. See [issue
1334](https://github.com/fluent/fluentd/issues/1334) for more detail.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
