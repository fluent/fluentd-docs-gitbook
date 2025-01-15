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

Reloads the configuration file by gracefully re-constructing the data pipeline. Fluentd will try to flush the entire memory buffer at once, but will not retry if the flush fails. Fluentd will not flush the file buffer; the logs are persisted on the disk by default.

This signal has been supported since v1.9.0.

### SIGHUP

Reloads the configuration file by gracefully restarting the worker process. Fluentd will try to flush the entire memory buffer at once, but will not retry if the flush fails. Fluentd will not flush the file buffer; the logs are persisted on the disk by default.

If you use fluentd v1.9.0 or later, use `SIGUSR2` instead.

### SIGCONT

Calls SIGDUMP to dump fluentd internal status. See [troubleshooting](trouble-shooting.md#dump-fluentds-internal-information) article.

### SIGWINCH

Cancels [Source Only Mode](source-only-mode.md).

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
