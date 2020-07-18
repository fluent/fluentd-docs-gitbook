# HTTP RPC

HTTP RPC enables you to manage your Fluentd instance through HTTP
endpoints. You can use this feature as a replacement of [Unix signals](/deployment/signals.md).

It is especially useful for environments where signals are not supported well
e.g. Windows.This require fluentd start not with --no-supervisor.


## Configuration

By default, HTTP RPC is not enabled. To use this feature, set the `rpc_endpoint`
option:

```
<system>
  rpc_endpoint 127.0.0.1:24444
</system>
```

Now, you can manage your Fluentd instance using an HTTP client:

```
$ curl http://127.0.0.1:24444/api/plugins.flushBuffers
{"ok":true}
```

As evident from the output above, each endpoint returns a JSON object as its
response.


## HTTP Endpoints

| Endpoint | Replacement of | Description |
| -------- |:--------------:|:-----------:|
| `/api/processes.interruptWorkers` | [SIGINT](/deployment/signals.md/#sigint-or-sigterm) | Stops the daemon. |
| `/api/processes.killWorkers` | [SIGTERM](/deployment/signals.md/#sigint-or-sigterm) | Stops the daemon. |
| `/api/processes.flushBuffersAndKillWorkers` | [SIGUSR1](/deployment/signals.md/#sigusr1) and [SIGTERM](/deployment/signals.md/#sigint-or-sigterm) | Flushes buffer and stops the daemon. |
| `/api/plugins.flushBuffers` | [SIGUSR1](/deployment/signals.md/#sigusr1) | Flushes the buffered messages. |
| `/api/config.gracefulReload` | [SIGUSR2](/deployment/signals.md/#sigusr2) | Reloads configuration. |
| `/api/config.reload` | [SIGHUP](/deployment/signals.md/#sighup) | Reloads configuration. |


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
