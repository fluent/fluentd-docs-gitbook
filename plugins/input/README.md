# Input Plugin Overview

Fluentd has eight (8) types of plugins:

-   [Input](/plugins/input/README.md)
-   [Parser](/plugins/parser/README.md)
-   [Filter](/plugins/filter/README.md)
-   [Output](/plugins/output/README.md)
-   [Formatter](/plugins/formatter/README.md)
-   [Storage](/plugins/storage/README.md)
-   [Service Discovery](/plugins/service_discovery/README.md)
-   [Buffer](/plugins/buffer/README.md)

This article gives an overview of Input Plugin.


## Overview

Input plugins extend Fluentd to retrieve and pull event logs from
external sources. An input plugin typically creates a thread socket and
a listen socket. It can also be written to periodically pull data from
data sources.


## List of Input Plugins

-   [`in_tail`](/plugins/input/tail.md)
-   [`in_forward`](/plugins/input/forward.md)
-   [`in_udp`](/plugins/input/udp.md)
-   [`in_tcp`](/plugins/input/tcp.md)
-   [`in_unix`](/plugins/input/unix.md)
-   [`in_http`](/plugins/input/http.md)
-   [`in_syslog`](/plugins/input/syslog.md)
-   [`in_exec`](/plugins/input/exec.md)
-   [`in_dummy`](/plugins/input/dummy.md)
-   [`in_windows_eventlog`](/plugins/input/windows_eventlog.md)


## Other Input Plugins

Refer to this list of available plugins to find out about other Input plugins:

-   [Fluentd plugins](http://fluentd.org/plugin/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
