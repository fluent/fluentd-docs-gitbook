# Input Plugins

Fluentd has 6 types of plugins: [Input](./), [Parser](../parser/), [Filter](../filter/), [Output](../output/), [Formatter](../formatter/) and [Buffer](../buffer/). This article gives an overview of Input Plugin.

## Overview

Input plugins extend Fluentd to retrieve and pull event logs from external sources. An input plugin typically creates a thread socket and a listen socket. It can also be written to periodically pull data from data sources.

## List of Input Plugins

* [in\_forward](forward.md)
* [in\_unix](unix.md)
* [in\_http](http.md)
* [in\_tail](tail.md)
* [in\_exec](exec.md)
* [in\_syslog](syslog.md)

## Other Input Plugins

Please refer to this list of available plugins to find out about other Input plugins.

* [Fluentd plugins](http://fluentd.org/plugin/)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

