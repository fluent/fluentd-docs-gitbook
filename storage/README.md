# Storage Plugins

Fluentd has eight \(8\) types of plugins:

* [Input](../input/)
* [Parser](../parser/)
* [Filter](../filter/)
* [Output](../output/)
* [Formatter](../formatter/)
* [Storage](./)
* [Service Discovery](../service_discovery/)
* [Buffer](../buffer/)

This article gives an overview of Storage Plugin.

## Overview

Sometimes, the input/filter/output plugin needs to save its internal state in memory, storage, or key-value store. Fluentd has a pluggable system called Storage that lets a plugin store and reuse its internal state as key-value pairs.

## How To Use

For an input, an output, and filter plugin that supports Storage, the `<storage>` directive can be used to store key-value pair into a key-value store such as a JSON file, MongoDB, Redis, etc.

Here is an example with `in_sample`:

```text
<source>
  @type sample
  tag docs.fluentd.storage
  <storage awesome_path>
    @type my_custom_storage
  </storage>
</source>
```

## List of Built-in Storage

* [`local`](local.md)

## List of Core Plugins with Storage support

* [`in_sample`](../input/sample.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
