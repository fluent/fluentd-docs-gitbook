Input Plugin Overview
=====================

Fluentd has 6 types of plugins: [Input](input-plugin-overview),
[Parser](parser-plugin-overview), [Filter](filter-plugin-overview),
[Output](output-plugin-overview), [Formatter](formatter-plugin-overview)
and [Buffer](buffer-plugin-overview). This article gives an overview of
Input Plugin.


Overview
--------

Input plugins extend Fluentd to retrieve and pull event logs from
external sources. An input plugin typically creates a thread socket and
a listen socket. It can also be written to periodically pull data from
data sources.

List of Input Plugins
---------------------

-   [in\_forward](in_forward)
-   [in\_unix](in_unix)
-   [in\_http](in_http)
-   [in\_tail](in_tail)
-   [in\_exec](in_exec)
-   [in\_syslog](in_syslog)

Other Input Plugins
-------------------

Please refer to this list of available plugins to find out about other
Input plugins.

-   [Fluentd plugins](http://fluentd.org/plugin/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us
know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
