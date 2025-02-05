# Logging

This article describes the Fluentd logging mechanism.

Fluentd has two logging layers: global and per plugin. Different log levels can be set for global logging and plugin level logging.

## Log Level

Here is the list of supported levels in increasing order of verbosity:

* `fatal`
* `error`
* `warn`
* `info`
* `debug`
* `trace`

The default log level is `info`, and Fluentd outputs `info`, `warn`, `error` and `fatal` logs by default.

## Global Logs

Global logging is used by Fluentd core and plugins that do not set their own log levels. The global log level can be adjusted up or down.

### By Command Line Option

#### Increase Verbosity Level

The `-v` option sets the verbosity to `debug` while the `-vv` option sets the verbosity to `trace`.

```text
$ fluentd -v  ... # debug log level
$ fluentd -vv ... # trace log level
```

These options are useful for debugging purposes.

#### Decrease Verbosity Level

The `-q` option sets the verbosity to `warn` while the `-qq` option sets the verbosity to `error`:

```text
$ fluentd -q  ... # warn log level
$ fluentd -qq ... # error log level
```

### By Config File

You can also configure the logging level in `<system>` section:

```text
# same as -qq command line option

<system>
  log_level error
</system>
```

## Per Plugin Log

The `@log_level` option sets different levels of logging for each plugin. It can be set in each plugin's configuration file.

For example, in order to debug [`in_tail`](../input/tail.md) and to suppress all but fatal log messages for [`in_http`](../input/http.md), their respective `@log_level` options should be set as follows:

```text
<source>
  @type tail
  @log_level debug
  path /var/log/data.log
  # ...
</source>

<source>
  @type http
  @log_level fatal
</source>
```

If you do not specify the `@log_level` parameter, the plugin will use the global log level.

## Log Format

Following format are supported:

* `text` \(default\)
* `json`

The format can be configured through `<log>` directive under `<system>`:

```text
<system>
  <log>
    format json
    time_format %Y-%m-%d
  </log>
</system>
```

With this setting, the following log line:

```text
2017-07-27 06:44:54 +0900 [info]: #0 fluentd worker is now running worker=0
```

is changed to:

```text
{"time":"2017-07-27","level":"info","message":"fluentd worker is now running worker=0","worker_id":0}
```

## Suppress log/stacktrace messages

Fluentd provides two parameters to suppress log/stacktrace messages

* `ignore_repeated_log_interval` \(since v1.10.2\)
* `ignore_same_log_interval` \(since v1.11.3\)

### `ignore_repeated_log_interval`

```text
<system>
  ignore_repeated_log_interval 60s
</system>
```

Under high loaded environment, output destination sometimes becomes unstable and it causes lots of same log message. This parameter mitigates such situation.

### `ignore_same_log_interval`

```text
<system>
  ignore_same_log_interval 60s
</system>
```

This is similar to `ignore_repeated_log_interval` but covers more usecases. For example, if the plugin generates several log messages in one action, logs are not repeated:

```text
# Retry generates several type messages. ignore_repeated_log_interval can't suppress these messages
def write(chunk)
  # process 1...
  log.error "message1"
  # process 2...
  log.error "message2"
end
```

`ignore_same_log_interval` resolves these cases.

## Output to Log File

### By Command Line Option

By default, Fluentd outputs to the standard output. Use `-o` command line option to specify the file instead:

```text
$ fluentd -o /path/to/log_file
```

### By Config File

Since v1.18.0, You can also configure the log file path using the `<log>` directive under `<system>`:

```text
<system>
  <log>
    path /path/to/log_file
  </log>
</system>
```

## Log Rotation Setting

By default, Fluentd does not rotate log files. You can configure this behavior via system-config after v1.13.0.

It can be configured through `<log>` directive under `<system>`:

```text
<system>
  <log>
    rotate_age 5
    rotate_size 1048576
  </log>
</system>
```

You need to specify [`rotate_age`](system-config.md#rotate_age) or [`rotate_size`](system-config.md#rotate_size) options explicitly to enable log rotation.

NOTE: You can omit one of these 2 options to use the default value, but if you omit both of them, log rotation is disabled.
Actually, an external library manages these default values, resulting in this complication.

You can use command-line options too (mainly for before v1.13.0):

### `--log-rotate-age AGE`

`AGE` is an integer or a string:

* integer: Generations to keep rotated log files.
* string: frequency of rotation. \(Supported: `daily`, `weekly`, `monthly`\)

NOTE: When `--log-rotate-age` is specified on Windows, log files are separated into `log-supervisor-0.log`, `log-0.log`, ..., `log-N.log` where `N` is `generation - 1` due to the system limitation. Windows does not permit delete and rename files simultaneously owned by another process.

### `--log-rotate-size BYTES`

The byte size to rotate log files. This is applied when `--log-rotate-age` is specified with integer:

Here is an example:

```text
$ fluentd -c fluent.conf --log-rotate-age 5 --log-rotate-size 104857600
```

NOTE: When `--log-rotate-size` is specified on Windows, log files are separated into `log-supervisor-0.log`, `log-0.log`, ..., `log-N.log` where `N` is `generation - 1` due to the system limitation. Windows does not permit delete and rename files simultaneously owned by another process.

## Capture Fluentd logs

Fluentd marks its own logs with the `fluent` tag. You can process Fluentd logs by using `<match fluent.**>`\(Of course, `**` captures other logs\) in `<label @FLUENT_LOG>`. If you define `<label @FLUENT_LOG>` in your configuration, then Fluentd will send its own logs to this label. This is useful for monitoring Fluentd logs.

For example, if you have the following configuration:

```text
# omit other source / match

<label @FLUENT_LOG>
  <match fluent.*>
    @type stdout
  </match>
</label>
```

Then, Fluentd outputs `fluent.info` logs to stdout like this:

```text
2014-02-27 00:00:00 +0900 [info]: shutting down fluentd
2014-02-27 00:00:01 +0900 fluent.info: {"message":"shutting down fluentd"} # by <match fluent.*>
2014-02-27 00:00:01 +0900 [info]: process finished code = 0
```

### Case 1: Send Fluentd Logs to Monitoring Service

You can send Fluentd logs to a monitoring service by plugins e.g. datadog, sentry, irc, etc.

```text
# Add hostname for identifying the server

<label @FLUENT_LOG>
  <filter fluent.*>
    @type record_transformer
    <record>
      host "#{Socket.gethostname}"
    </record>
  </filter>

  <match fluent.*>
    @type monitoring_plugin
    # ...
  </match>
</label>
```

### Case 2: Use Aggregation/Monitoring Server

You can use [`out_forward`](../output/forward.md) to send Fluentd logs to a monitoring server. The monitoring server can then filter and send the logs to your notification system e.g. chat, irc, etc.

Leaf Server Example:

```text
# Add hostname for identifying the server and tag to filter by log level

<label @FLUENT_LOG>
  # If you want to capture only error events, use 'fluent.error' instead.

  <filter fluent.*>
    @type record_transformer
    <record>
      host "#{Socket.gethostname}"
      original_tag ${tag}
    </record>
  </filter>

  <match fluent.*>
    @type forward
    <server>
      # Monitoring server parameters
    </server>
  </match>
</label>
```

Monitoring Server Example:

```text
<source>
  @type forward
</source>

# Ignore trace, debug and info log. Of course, you can use strict matching
# like `<filter fluent.{warn,error,fatal}>` without grep filter.

<filter fluent.*>
  @type grep
  <regexp>
    key original_tag
    pattern fluent.(warn|error|fatal)
  </regexp>
</filter>

# your notification setup. This example uses irc plugin
<match fluent.*>
  @type irc
  host irc.domain
  channel notify
  message notice: %s [%s] @%s %s
  out_keys original_tag,time,host,message
</match>

# Unlike v0.12, if `<label @FLUENT_LOG>` is defined,
# `<match fluent.*>` in root is not used for log capturing.

<label @FLUENT_LOG>
  # Monitoring server's internal log
</label>
```

If an error occurs, you will get a notification message in your Slack `notify` channel:

```text
01:01  fluentd: [11:10:24] notice: fluent.warn [2014/02/27 01:00:00] @leaf.server.domain detached forwarding server 'server.name'
```

### Deprecate Top-Level Match

You can still use [v0.12 way](https://fluentd.gitbook.io/manual/v/0.12/deployment/logging#capture-fluentd-logs) without `<label @FLUENT_LOG>` but this feature is deprecated. This feature will be removed in fluentd v2.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

