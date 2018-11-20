# HTTP RPC

HTTP RPC enables you to manage your Fluentd instance through HTTP
endpoints. You can use this feature as a replacement of [Unix signals](/articles/signals.md).

It's especially useful for environments where signals are not supported
well (e.g. Windows).


## Configuration

HTTP RPC is not enabled by default. To use this feature, set the
`rpc_endpoint` option as follows.

``` {.CodeRay}
<system>
  rpc_endpoint 127.0.0.1:24444
</system>
```

Now you can manage your Fluentd instance using a HTTP client:

``` {.CodeRay}
$ curl http://127.0.0.1:24444/api/plugins.flushBuffers
{"ok":true}
```

As shown in the above example, each endpoint returns a JSON object as
its response.


## HTTP endpoints


### /api/processes.interruptWorkers

Replacement of signal's [SIGINT](/articles/signals.md/#sigint-or-sigterm). Stop the
daemon.


### /api/processes.killWorkers

Replacement of signal's [SIGTERM](/articles/signals.md/#sigint-or-sigterm). Stop the
daemon.


### /api/processes.flushBuffersAndKillWorkers

This is essentially a combination of [SIGUSR1](/articles/signals.md/#sigusr1) and
[SIGTERM](/articles/signals.md/#sigint-or-sigterm). Flush the buffer then stop the
daemon.


### /api/plugins.flushBuffers

Replacement of signal's [SIGUSR1](/articles/signals.md/#sigusr1). Flush the buffered
messages.


### /api/config.reload

Replacement of signal's [SIGHUP](/articles/signals.md/#sighup). Reload configuration.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
