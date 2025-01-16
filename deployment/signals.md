# Signals

This article explains how `fluentd` handles UNIX signals.

## Process Model

When you launch Fluentd, it creates two processes: supervisor and worker. The supervisor process controls the life cycle of the worker process. Make sure to send signals to the supervisor process only.

## Signals

### SIGINT or SIGTERM

Stops the daemon gracefully. Fluentd will try to flush the entire memory buffer at once, but will not retry if the flush fails. Fluentd will not flush the file buffer; the logs are persisted on the disk by default.

### SIGUSR1

Forces the buffered messages to be flushed and reopens Fluentd's log. Fluentd will try to flush the current buffer \(both memory and file\) immediately, and keep flushing at `flush_interval`.

### SIGUSR2

Since v1.18, it has two features: Zero-downtime restart and Graceful reload.

Non-Windows:

| process    | feature                                    | version      |
| :---       | :---                                       | :---         |
| Supervisor | Zero-downtime restart                      | v1.18.0 ~    |
| Supervisor | Graceful reload (forwarded to all workers) | v1.9 ~ v1.17 |
| Worker     | Graceful reload                            | v1.9 ~       |

Windows:

| process    | feature                                    | version |
| :---       | :---                                       | :---    |
| Supervisor | Graceful reload (forwarded to all workers) | v1.9 ~  |
| Worker     | Graceful reload                            | v1.9 ~  |

#### Zero-downtime restart

This feature supports a complete restart of Fluentd.
This restarts Fluentd so that some input plugins don't have down time.

See [Zero-downtime restart](zero-downtime-restart.md) for details.

**Comparison with SIGHUP**

`SIGHUP` gracefully restarting the worker process to reload.

This method does not cause socket downtime, so if there is no need to restart the supervisor, `SIGHUP` is a lighter zero-downtime restart method.

**Comparison with Graceful reload**

You can still use Graceful reload feature by sending `SIGUSR2` directly to the worker process or using [RPC](rpc.md) even after v1.18.0.

This allows you to reload without restarting the process, but there are some limitations.
Please use zero-downtime restart or `SIGHUP` unless there is a special reason.

#### Graceful reload

Reloads the configuration file by gracefully re-constructing the data pipeline. Fluentd will try to flush the entire memory buffer at once, but will not retry if the flush fails. Fluentd will not flush the file buffer; the logs are persisted on the disk by default.

Limitations:

* A change to System Configuration (`<system>`) is ignored.
* All plugins must not use class variable.

### SIGHUP

Reloads the configuration file by gracefully restarting the worker process. Fluentd will try to flush the entire memory buffer at once, but will not retry if the flush fails. Fluentd will not flush the file buffer; the logs are persisted on the disk by default.

This does not cause socket downtime because the supervisor process keeps the normal sockets, as long as the socket is provided as a shared socket by [server_helper](../plugin-helper-overview/api-plugin-helper-server.md).

### SIGCONT

Calls SIGDUMP to dump fluentd internal status. See [troubleshooting](trouble-shooting.md#dump-fluentds-internal-information) article.

### SIGWINCH

Cancels [Source Only Mode](source-only-mode.md).

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
