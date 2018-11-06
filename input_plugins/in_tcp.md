
Versions \| [v1.0 (td-agent3)](/v1.0/articles/in_tcp) \| ***v0.12*(td-agent2) **
------------------------------------------------------------------------

TCP Input Plugin
================

The `in_tcp` Input plugin enables Fluentd to accept TCP payload.

Don't use this plugin for receiving logs from client libraries. Use
`in_forward` for such cases.


### Table of Contents

[Example Configuration](#example-configuration)

[Parameters](#parameters)

-   [\@type (required)](#@type-(required))
-   [tag (required)](#tag-(required))
-   [port](#port)
-   [bind](#bind)
-   [delimiter](#delimiter)
-   [source\_hostname\_key](#source_hostname_key)
-   [format (required)](#format-(required))
Example Configuration
---------------------

`in_tcp` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<source>
  @type tcp
  tag tcp.events # required
  format /^(?<field1>\d+):(?<field2>\w+)$/ # required
  port 20001 # optional. 5170 by default
  bind 0.0.0.0 # optional. 0.0.0.0 by default
  delimiter \n # optional. \n (newline) by default
</source>
```
Please see the [Config File](config-file) article for the basic
structure and syntax of the configuration file.

We\'ve observed the drastic performance improvements on Linux, with
proper kernel parameter settings. If you have high-volume TCP traffic,
please make sure to follow the instruction described at [Before
Installing Fluentd](before-install).

Parameters
----------

### \@type (required)

The value must be `tcp`.

### tag (required)

tag of output events.

### port

The port to listen to. Default Value = 5170

### bind

The bind address to listen to. Default Value = 0.0.0.0

### delimiter

The payload is read up to this character. By default, it is "\\n".

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

The format of the TCP payload. Here is the example by regular
expression.

``` {.CodeRay}
format /^(?<field1>\d+):(?<field2>\w+)$/
```

If you execute following command:

``` {.CodeRay}
$ echo '123456:awesome' | netcat 0.0.0.0 5170
```

then got parsed result like below:

``` {.CodeRay}
{"field1":"123456","field2":"awesome}
```

`in_tcp` uses parser plugin to parse the payload. See [parser
article](parser-plugin-overview) for more detail.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging) for further details.


Last updated: 2016-10-21 06:29:58 UTC
------------------------------------------------------------------------
Versions \| [v1.0 (td-agent3)](/v1.0/articles/in_tcp) \| ***v0.12*(td-agent2) **
------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
