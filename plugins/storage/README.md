# Storage Plugin Overview

Fluentd has 8 types of plugins: [Input](/plugins/input/README.md),
[Parser](/plugins/parser/README.md), [Filter](/plugins/filter/README.md),
[Output](/plugins/output/README.md),
[Formatter](/plugins/formatter/README.md),
[Storage](/plugins/storage/README.md),
[Service Discovery](/plugins/service_discovery/README.md) and [Buffer](/plugins/buffer/README.md).
This article gives an overview of Storage Plugin.

## Overview

Sometimes, the plugin states for an output, a filter, and an input
plugin should save into in-memory or storage or other key-value stores.
Fluentd has a pluggable system called Storage that lets the plugin
internal states extract to in-memory or storage or other key-value
stores and re-use stored key-value pair value.


## How To Use

For an input, an output, and filter plugin that supports Storage, the
`<storage>` directive can be used to store key-value pair into the
key-vaule store such as json file, MongoDB, Redis and so on.

Here is an example with in\_dummy:

```
<source>
  @type dummy
  tag docs.fluentd.storage
  <storage awesome_path>
    @type my_custom_storage
  </storage>
</source>
```


## List of Built-in Storage

-   [local](/plugins/storage/local.md)


## List of Core Plugins with Storage support

-   [in\_dummy](/plugins/input/dummy.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
