# Unix Domain Socket Input Plugin

The `in_unix` Input plugin enables Fluentd to retrieve records from
the Unix Domain Socket. The wire protocol is the same as
[in_forward](/plugins/input/forward), but the transport layer is
different.

## Example Configuration

`in_unix` is included in Fluentd's core. No additional installation
process is required.

    <source>
      @type unix
      path /path/to/socket.sock
    </source>

NOTE: Please see the [Config File](/configuration/config-file) article
for the basic structure and syntax of the configuration file.

## Parameters

### @type (required)

The value must be `unix`.

### path

| type   | default                                   | version |
|:------:|:-----------------------------------------:|:-------:|
| string | `/var/run/fluent/fluent.sock` (see below) | 0.14.0  |

The path to your Unix Domain Socket.

Fluentd will use the environment variable `FLUENT_SOCKET` if defined.

### backlog

| type    | default | version |
|:-------:|:-------:|:-------:|
| integer | 1024    | 0.14.0  |

The backlog of Unix Domain Socket.

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
