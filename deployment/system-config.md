# System Configuration

This article describes Fluentd's system configuraitons configured via
`<system>` section and command line options.


## Overview

System Configuration is one way to set up system-wide configuration such
as enabling RPC, multiple workers, to obtain dump.


## Parameters


### workers

| type    | default | version |
|:--------|:--------|:--------|
| integer | 1       | 0.14.12 |

Specify number of workers.


### root\_dir

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.11 |

Specify root directory.


### log\_level

| type | default | version |
|:-----|:--------|:--------|
| enum | nil     | 0.14.0  |

Specify log\_level. Users can choose `trace`, `debug`, `info`, `warn`,
`error`, and `fatal` level.


### suppress\_repeated\_stacktrace

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.0  |

Suppress repeated stacktrace.


### emit\_error\_log\_interval

| type | default | version |
|:-----|:--------|:--------|
| time | nil     | 0.14.0  |

Specify time value of emitting error log interval.


### suppress\_config\_dump

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.0  |

Suppress config dump.


### log\_event\_verbose

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.12 |

Log event verbose.


### without\_source

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.0  |

Invoke a fluentd without input plugins.


### rpc\_endpoint

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

Specify RPC endpoint. In more detail, please refer to [RPC document](/deployment/rpc.md).


### enable\_get\_dump

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.0  |

Enabling to get dump.


### process\_name

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

Specify process name.


### file\_permission

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

Specify file permission with octal.


### dir\_permission

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

Specify directory permission with octal.


### strict\_config\_value

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 1.8.0   |

Parse config values strictly. Invalid numerical or boolean values
aren't allowed. Fluentd raises configuration error instead of
replacing them with `0` or `true` implicitly.


### &lt;log&gt; section

#### format

| type | default | version |
|:-----|:--------|:--------|
| enum | text    | 0.14.20 |

Specify logging format. Users can choose `text` and `json` format.

#### time\_format

| type   | default                | version |
|:-------|:-----------------------|:--------|
| string | `%Y-%m-%d %H:%M:%S %z` | 0.14.20 |

Specify time format.


### Fluent::SystemConfig::Mixin methods

#### .system\_config

Returns `Fluent::SystemConfig` instance.

For code example, please refer to [api-plugin-base](/developer/api-plugin-base.md)'s
`.system_config` description.

#### .system\_config\_override(options = {})

Overwrite system config.

This is for internal use and plugin testing.

For code example, please refer to [api-plugin-base](/developer/api-plugin-base.md)'s
`.system_config_override` description.


## Command Line Options


### -s, \--setup \[DIR=/etc/fluent\]

Install sample configuration file to the directory


### -c, \--config PATH

Config file path (default: /etc/fluent/fluent.conf)


### \--dry-run

Check fluentd setup is correct or not


### \--show-plugin-config=PLUGIN (obsoleted)

Use `fluent-plugin-config-format` command instead.


### -p, \--plugin DIR

Add plugin directory.


### -I PATH

Add library path.


### -r NAME

Load library.


### -d, \--daemon PIDFILE

Daemonize fluent process.


### \--under-supervisor

Run fluent worker under supervisor (this option is NOT for users).


### \--no-supervisor

Run fluent worker without supervisor.


### \--workers NUM

Specify the number of workers under supervisor.


### \--user USER

Change user.


### \--group GROUP

Change group.


### -o, \--log PATH

Log file path.


### \--log-rotate-age AGE

Generations to keep rotated log files.


### \--log-rotate-size BYTES

Sets the byte size to rotate log files.


### \--log-event-verbose

Enable log events during process startup/shutdown.


### -i CONFIG\_STRING, \--inline-config CONFIG\_STRING

Inline config which is appended to the config file on-the-fly.


### \--emit-error-log-interval SECONDS

Suppress interval seconds of emit error logs.


### \--suppress-repeated-stacktrace \[VALUE\]

Suppress repeated stacktrace.


### \--without-source

Invoke a fluentd without input plugins.


### \--use-v1-config

Use v1 configuration format (default).


### \--use-v0-config

Use v0 configuration format.


### \--strict-config-value

Parse config values strictly. Invalid numerical or boolean values
aren't allowed. Fluentd raises configuration error instead of
replacing them with `0` or `true` implicitly.


### -v, \--verbose

Increase verbose level (-v: debug, -vv: trace).


### -q, \--quiet

Decrease verbose level (-q: warn, -qq: error).


### \--suppress-config-dump

Suppress config dumping when fluentd starts.


### -g, \--gemfile GEMFILE

Gemfile path.


### -G, \--gem-path GEM\_INSTALL\_PATH

Gemfile install path (default: \$(dirname \$gemfile)/vendor/bundle).


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
