# Input Plugin Overview

Fluentd has 7 types of plugins: [Input](/plugins/input/README.md),
[Parser](/plugins/parser/README.md), [Filter](/plugins/filter/README.md),
[Output](/plugins/output/README.md),
[Formatter](/plugins/formatter/README.md),
[Storage](/plugins/storage/README.md) and [Buffer](/plugins/buffer/README.md).
This article gives an overview of Input Plugin.


## Overview

Input plugins extend Fluentd to retrieve and pull event logs from
external sources. An input plugin typically creates a thread socket and
a listen socket. It can also be written to periodically pull data from
data sources.


## List of Input Plugins

-   [in\_tail](/plugins/input/tail.md)
-   [in\_forward](/plugins/input/forward.md)
-   [in\_udp](/plugins/input/udp.md)
-   [in\_tcp](/plugins/input/tcp.md)
-   [in\_unix](/plugins/input/unix.md)
-   [in\_http](/plugins/input/http.md)
-   [in\_syslog](/plugins/input/syslog.md)
-   [in\_exec](/plugins/input/exec.md)
-   [in\_dummy](/plugins/input/dummy.md)
-   [in\_windows\_eventlog](/plugins/input/windows_eventlog.md)


## Other Input Plugins

Please refer to this list of available plugins to find out about other
Input plugins.

-   [Fluentd plugins](http://fluentd.org/plugin/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
