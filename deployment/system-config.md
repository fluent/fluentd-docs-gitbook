# System Configuration

This article describes the Fluentd's system configurations for `<system>`
section and command line options.


## Overview

System Configuration is one way to set up system-wide configuration such as
enabling RPC, multiple workers, etc.


## Parameters


### `workers`

| type    | default | version |
|:--------|:--------|:--------|
| integer | 1       | 0.14.12 |

Specifies the number of workers.


### `root_dir`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.11 |

Specifies the root directory.


### `log_level`

| type | default | version |
|:-----|:--------|:--------|
| enum | "info"  | 0.14.0  |

Specifies the log level e.g. `trace`, `debug`, `info`, `warn`, `error`, or `fatal`.


### `suppress_repeated_stacktrace`

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.0  |

Suppresses the repeated stacktrace.


### `emit_error_log_interval`

| type | default | version |
|:-----|:--------|:--------|
| time | nil     | 0.14.0  |

Specifies the time value of emitting error log interval.


### `suppress_config_dump`

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.0  |

Suppresses the configuration dump.


### `log_event_verbose`

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.12 |

Logs event verbosely.


### `without_source`

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.0  |

Invokes fluentd without input plugins.


### `rpc_endpoint`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

Specifies an RPC endpoint. Refer to the [RPC](/deployment/rpc.md) article for more detail.


### `enable_get_dump`

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 0.14.0  |

Enables to get dump.


### `process_name`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

Specifies the process name.


### `enable_msgpack_time_support`

| type   | default | version |
|:-------|:--------|:--------|
| bool   | false   | 1.9.0   |

Allows `Time` object in buffer's MessagePack serde. This is useful when the log contains multiple time fields.


### `file_permission`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

Specifies the file permission in octal format.


### `dir_permission`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

Specifies the directory permission in octal format.


### `strict_config_value`

| type | default | version |
|:-----|:--------|:--------|
| bool | nil     | 1.8.0   |

Parses config values strictly. Invalid numerical or boolean values
are not allowed. Fluentd raises configuration error instead of
replacing them with `0` or `true` implicitly.


### `<log>` section


#### `format`

| type | default | version |
|:-----|:--------|:--------|
| enum | text    | 0.14.20 |

Specifies the logging format e.g. `text` or `json`.


#### `time_format`

| type   | default                | version |
|:-------|:-----------------------|:--------|
| string | `%Y-%m-%d %H:%M:%S %z` | 0.14.20 |

Specifies time format.


### `Fluent::SystemConfig::Mixin` Methods


#### `.system_config`

Returns `Fluent::SystemConfig` instance.

For code example, please refer to
[`api-plugin-base`](/developer/api-plugin-base.md)'s `.system_config`
description.


#### `.system_config_override(options = {})`

Overwrites the system configuration.

This is for internal use and plugin testing.

For code example, please refer to
[`api-plugin-base`](/developer/api-plugin-base.md)'s
`.system_config_override` description.


## Command Line Options


-   `-s`, `--setup [DIR=/etc/fluent]`: Installs sample configuration file to
    the directory.

-   `-c`, `--config PATH`: Specifies the configuration file path. (Default:
    `/etc/fluent/fluent.conf`)

-   `--dry-run`: Verifies the fluentd setup without launching.

-   `--show-plugin-config=PLUGIN` (obsolete): Use `fluent-plugin-config-format`
    command instead.

-   `-p`, `--plugin DIR`: Specifies the plugins' directory.

-   `-I PATH`: Specifies the library path.

-   `-r NAME`: Loads the library.

-   `-d`, `--daemon PIDFILE`: Daemonizes the fluentd process.

-   `--under-supervisor`: Runs the fluent worker under supervisor (this option
    is NOT for users).

-   `--no-supervisor`: Runs the fluent worker without supervisor.

-   `--workers NUM`: Specifies the number of workers under supervisor.

-   `--user USER`: Changes user.

-   `--group GROUP`: Changes group.

-   `-o`, `--log PATH`: Specifies the log file path.

-   `--log-rotate-age AGE`: Specifies the generations to keep rotated log files.

-   `--log-rotate-size BYTES`: Sets the byte size to rotate log files.

-   `--log-event-verbose`: Enables the events logging during startup/shutdown.

-   `-i CONFIG_STRING`, `--inline-config CONFIG_STRING`: Specifies the inlined
    configuration which is appended to the config file on-the-fly.

-   `--emit-error-log-interval SECONDS`: Suppresses the interval (seconds) to
    emit error logs.

-   `--suppress-repeated-stacktrace [VALUE]`: Suppress the repeated stacktrace.

-   `--without-source`: Invokes fluentd without input plugins.

-   `--use-v1-config`: Uses v1 configuration format (default).

-   `--use-v0-config`: Uses v0 configuration format.

-   `--strict-config-value`: Parses the configuration values strictly. Invalid
    numerical or boolean values are rejected. Fluentd raises configuration error
    exceptions instead of replacing them with `0` or `true` implicitly.

-   `-v`, `--verbose`: Increases the verbosity level (`-v`: debug, `-vv`: trace).

-   `-q`, `--quiet`: Decreases the verbosity level (`-q`: warn, `-qq`: error).

-   `--suppress-config-dump`: Suppresses the configuration dumping on start.

-   `-g`, `--gemfile GEMFILE`: Specifies the Gemfile path.

-   `-G`, `--gem-path GEM_INSTALL_PATH`: Specifies the Gemfile install path.
    (Default: `$(dirname $gemfile)/vendor/bundle`)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
