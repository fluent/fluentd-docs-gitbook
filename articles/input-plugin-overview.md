Input Plugin Overview
=====================

Fluentd has 6 types of plugins: [Input](/articles/input-plugin-overview.md),
[Parser](/articles/parser-plugin-overview.md), [Filter](/articles/filter-plugin-overview.md),
[Output](/articles/output-plugin-overview.md), [Formatter](/articles/formatter-plugin-overview.md)
and [Buffer](/articles/buffer-plugin-overview.md). This article gives an overview of
Input Plugin.


Overview
--------

Input plugins extend Fluentd to retrieve and pull event logs from
external sources. An input plugin typically creates a thread socket and
a listen socket. It can also be written to periodically pull data from
data sources.

List of Input Plugins
---------------------

-   [in\_forward](/articles/in_forward.md)
-   [in\_unix](/articles/in_unix.md)
-   [in\_http](/articles/in_http.md)
-   [in\_tail](/articles/in_tail.md)
-   [in\_exec](/articles/in_exec.md)
-   [in\_syslog](/articles/in_syslog.md)

Other Input Plugins
-------------------

Please refer to this list of available plugins to find out about other
Input plugins.

-   [Fluentd plugins](http://fluentd.org/plugin/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
