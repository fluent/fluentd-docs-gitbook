# Fluentd's HTTP RPC

This article explains how `Fluentd` handles HTTP RPC.


## Overview

HTTP RPC is one way of managing fluentd instance. Several provided RPCs
are replacement of [signals](/deployment/signals.md). The response body is JSON format.

On signal unsupported environment, e.g. Windows, you can use RPC instead
of signals.

## Configuration

RPC is off by default. If you want to enable RPC, set `rpc_endpoint` in
`<system>` section.

``` {.CodeRay}
<system>
  rpc_endpoint 127.0.0.1:24444
</system>
```

After that, you can access to RPC like below.

``` {.CodeRay}
$ curl http://127.0.0.1:24444/api/plugins.flushBuffers
{"ok":true}
```

## RPCs

### /api/processes.interruptWorkers

Replacement of signal's [SIGINT](/deployment/signals.md/#sigint-or-sigterm). Stop the daemon.

### /api/processes.killWorkers

Replacement of signal's [SIGTERM](/deployment/signals.md/#sigint-or-sigterm). Stop the daemon.

### /api/plugins.flushBuffers

Replacement of signal's [SIGUSR1](/deployment/signals.md/#sigusr1). Flushes buffered
messages.

### /api/config.reload

Replacement of signal's [SIGHUP](/deployment/signals.md/#sighup). reload configuration.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
