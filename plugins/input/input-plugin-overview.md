# Input Plugin Overview

Fluentd has 6 types of plugins: [Input](/plugins/input/input-plugin-overview.md),
[Parser](/plugins/parser/parser-plugin-overview.md), [Filter](/plugins/filter/filter-plugin-overview.md),
[Output](/plugins/output/output-plugin-overview.md), [Formatter](/plugins/formatter/formatter-plugin-overview.md)
and [Buffer](/plugins/buffer/buffer-plugin-overview.md). This article gives an overview of
Input Plugin.


## Overview

Input plugins extend Fluentd to retrieve and pull event logs from
external sources. An input plugin typically creates a thread socket and
a listen socket. It can also be written to periodically pull data from
data sources.

## List of Input Plugins

-   [in\_forward](/plugins/input/in_forward.md)
-   [in\_unix](/plugins/input/in_unix.md)
-   [in\_http](/plugins/input/in_http.md)
-   [in\_tail](/plugins/input/in_tail.md)
-   [in\_exec](/plugins/input/in_exec.md)
-   [in\_syslog](/plugins/input/in_syslog.md)

## Other Input Plugins

Please refer to this list of available plugins to find out about other
Input plugins.

-   [Fluentd plugins](http://fluentd.org/plugin/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
