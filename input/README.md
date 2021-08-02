# Input Plugins

Fluentd has nine \(9\) types of plugins:

* [Input](./)
* [Parser](../parser/)
* [Filter](../filter/)
* [Output](../output/)
* [Formatter](../formatter/)
* [Storage](../storage/)
* [Service Discovery](../service_discovery/)
* [Buffer](../buffer/)
* [Metrics](../metrics/)

This article gives an overview of the Input Plugin.

## Overview

Input plugins extend Fluentd to retrieve and pull event logs from the external sources. An input plugin typically creates a thread, socket, and a listening socket. It can also be written to periodically pull data from the data sources.

## List of Input Plugins

* [`in_tail`](tail.md)
* [`in_forward`](forward.md)
* [`in_udp`](udp.md)
* [`in_tcp`](tcp.md)
* [`in_unix`](unix.md)
* [`in_http`](http.md)
* [`in_syslog`](syslog.md)
* [`in_exec`](exec.md)
* [`in_sample`](sample.md)
* [`in_windows_eventlog`](windows_eventlog.md)

## Other Input Plugins

Refer to this list of available plugins to find out about other Input plugins:

* [Fluentd plugins](http://fluentd.org/plugin/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

