# System Configuration

This article describes Fluentd's system configurations for the `<system>` section and command-line options.

## Overview

System Configuration is one way to set up system-wide configuration such as enabling RPC, multiple workers, etc.

## Parameters

### `workers`

| type | default | version |
| :--- | :--- | :--- |
| integer | 1 | 0.14.12 |

Specifies the number of workers.

### `restart_worker_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | 0 | 1.15.0 |

Specifies interval to restart workers that has stopped for some reason. By default, Fluentd immediately restarts stopped workers. You can use this option for stopping workers for a certain period of time.

### `root_dir`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.11 |

Specifies the root directory.

### `log_level`

| type | default | version |
| :--- | :--- | :--- |
| enum | "info" | 0.14.0 |

Specifies the log level e.g. `trace`, `debug`, `info`, `warn`, `error`, or `fatal`.

### `suppress_repeated_stacktrace`

| type | default | version |
| :--- | :--- | :--- |
| bool | nil | 0.14.0 |

Suppresses the repeated stacktrace.

### `emit_error_log_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | nil | 0.14.0 |

Specifies the time value of the emitting of error log interval.

### `ignore_repeated_log_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | nil | 1.10.2 |

Specify interval to ignore repeated log/stacktrace messages.

See also [Logging article](logging.md#ignore_repeated_log_interval).

### `ignore_same_log_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | nil | 1.11.3 |

Specify interval to ignore same log/stacktrace messages.

See also [Logging article](logging.md#ignore_same_log_interval).

### `suppress_config_dump`

| type | default | version |
| :--- | :--- | :--- |
| bool | nil | 0.14.0 |

Suppresses the configuration dump.

### `log_event_verbose`

| type | default | version |
| :--- | :--- | :--- |
| bool | nil | 0.14.12 |

Logs event verbosely.

### `without_source`

| type | default | version |
| :--- | :--- | :--- |
| bool | nil | 0.14.0 |

Invokes fluentd without input plugins.

### `rpc_endpoint`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.0 |

Specifies an RPC endpoint. Refer to the [RPC](rpc.md) article for more detail.

### `enable_get_dump`

| type | default | version |
| :--- | :--- | :--- |
| bool | nil | 0.14.0 |

Enables to get dump.

### `process_name`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.0 |

Specifies the process name.

### `enable_msgpack_time_support`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.9.0 |

Allows `Time` object in buffer's MessagePack serde. This is useful when the log contains multiple time fields.

### `file_permission`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.0 |

Specifies the file permission in the octal format.

### `dir_permission`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.0 |

Specifies the directory permission in the octal format.

### `strict_config_value`

| type | default | version |
| :--- | :--- | :--- |
| bool | nil | 1.8.0 |

Parses config values strictly. Invalid numerical or boolean values are not allowed. Fluentd raises configuration error instead of replacing them with `0` or `true` implicitly.

### `disable_shared_socket`

| type | default | version |
| :--- | :--- | :--- |
| bool | nil | 1.12.1 |

Force disable the shared socket which is for listening a same port across multiple worker processes. When the shared socket is enabled \(it's the default behavior\), a socket is always created to enable workers to communicate with the supervisor. On Windows, it consumes a dynamic \(a.k.a ephemeral\) TCP port. If you don't prefer it, set this option as `true`. When it's disabled, you may not use plugins that listen a port such as in\_forward, in\_http and in\_syslog.

### `enable_jit` (experimental)

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.15.2 |

Enable JIT for worker processes. Internally, this configuration enables Ruby's `--jit` command-line option.

### `<log>` section

#### `path`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.18.0 |

Specifies the log file path.

Please see also [Output to Log File](logging.md#output-to-log-file).

#### `format`

| type | default | version |
| :--- | :--- | :--- |
| enum | text | 0.14.20 |

Specifies the logging format e.g. `text` or `json`.

#### `time_format`

| type | default | version |
| :--- | :--- | :--- |
| string | `%Y-%m-%d %H:%M:%S %z` | 0.14.20 |

Specifies time format.

#### `rotate_age`

| type | default | version |
| :--- | :--- | :--- |
| enum or integer | 7 | 1.13.0 |

Specifies `daily`, `weekly`, `monthly` or integer which indicates age of log rotation.

By default, Fluentd does not rotate log files. You need to specify `rotate_age` or `rotate_size` options explicitly to enable log rotation.

NOTE: When enabling log rotation on Windows, log files are separated into `log-supervisor-0.log`, `log-0.log`, ..., `log-N.log` where `N` is `generation - 1` due to the system limitation. Windows does not permit delete and rename files simultaneously owned by another process.

Please see also [Log Rotation Setting](logging.md#log-rotation-setting).

#### `rotate_size`

| type | default | version |
| :--- | :--- | :--- |
| size | 1048576 | 1.13.0 |

Specifies log file size limitation.

By default, Fluentd does not rotate log files. You need to specify `rotate_age` or `rotate_size` options explicitly to enable log rotation.

NOTE: When enabling log rotation on Windows, log files are separated into `log-supervisor-0.log`, `log-0.log`, ..., `log-N.log` where `N` is `generation - 1` due to the system limitation. Windows does not permit delete and rename files simultaneously owned by another process.

Please see also [Log Rotation Setting](logging.md#log-rotation-setting).

#### `enable_input_metrics`

| type | default | version |
| :--- | :---    | :---    |
| bool | nil     | 1.14.0  |

Specifies whether measuring input metrics should be enabled or not.

#### `enable_size_metrics`

| type | default | version |
| :--- | :---    | :---    |
| bool | nil     | 1.14.0  |

Specifies whether measuring record size metrics should be enabled or not.
It can be useful for calculating flow rate on Fluentd instances.

### `Fluent::SystemConfig::Mixin` Methods

#### `.system_config`

Returns `Fluent::SystemConfig` instance.

For code example, please refer to [`api-plugin-base`](../plugin-development/api-plugin-base.md)'s `.system_config` description.

#### `.system_config_override(options = {})`

Overwrites the system configuration.

This is for internal use and plugin testing.

For code example, please refer to [`api-plugin-base`](../plugin-development/api-plugin-base.md)'s `.system_config_override` description.

## Command-Line Options

* `-s`, `--setup [DIR=/etc/fluent]`: Installs sample configuration file to the directory.
* `-c`, `--config PATH`: Specifies the configuration file path. \(Default: `/etc/fluent/fluent.conf`\)
* `--dry-run`: Verifies the fluentd setup without launching.
* `--show-plugin-config=PLUGIN` \(obsolete\): Use `fluent-plugin-config-format` command instead.
* `-p`, `--plugin DIR`: Specifies the plugins' directory.
* `-I PATH`: Specifies the library path.
* `-r NAME`: Loads the library.
* `-d`, `--daemon PIDFILE`: Daemonizes the fluentd process.
* `--under-supervisor`: Runs the fluent worker under supervisor \(this option is NOT for users\).
* `--no-supervisor`: Runs the fluent worker without supervisor.
* `--workers NUM`: Specifies the number of workers under supervisor.
* `--user USER`: Changes user.
* `--group GROUP`: Changes group.
* `--umask UMASK`: Specifies umask to use, in octal form. Defaults to 0.
* `-o`, `--log PATH`: Specifies the log file path.
* `--log-rotate-age AGE`: Specifies the generations to keep rotated log files.
* `--log-rotate-size BYTES`: Sets the byte size to rotate log files.
* `--log-event-verbose`: Enables the events logging during startup/shutdown.
* `-i CONFIG_STRING`, `--inline-config CONFIG_STRING`: Specifies the inlined configuration which is appended to the config file on-the-fly.
* `--emit-error-log-interval SECONDS`: Suppresses the interval \(seconds\) to emit error logs.
* `--suppress-repeated-stacktrace [VALUE]`: Suppress the repeated stacktrace.
* `--without-source`: Invokes fluentd without input plugins.
* `--use-v1-config`: Uses v1 configuration format \(default\).
* `--use-v0-config`: Uses v0 configuration format.
* `--strict-config-value`: Parses the configuration values strictly. Invalid numerical or boolean values are rejected. Fluentd raises configuration error exceptions instead of replacing them with `0` or `true` implicitly.
* `-v`, `--verbose`: Increases the verbosity level \(`-v`: debug, `-vv`: trace\).
* `-q`, `--quiet`: Decreases the verbosity level \(`-q`: warn, `-qq`: error\).
* `--suppress-config-dump`: Suppresses the configuration dumping on start.
* `-g`, `--gemfile GEMFILE`: Specifies the Gemfile path.
* `-G`, `--gem-path GEM_INSTALL_PATH`: Specifies the Gemfile install path. \(Default: `$(dirname $gemfile)/vendor/bundle`\)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

