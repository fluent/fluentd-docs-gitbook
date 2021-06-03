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

## List of 3rd party storage plugins

NOTE: This 3rd party storage plugin list does not fully covers all of them.

* [fluent-plugin-storage-leveldb](https://github.com/cosmo0920/fluent-plugin-storage-leveldb)
* [fluent-plugin-storage-memcached](https://github.com/cosmo0920/fluent-plugin-storage-memcached)
* [fluent-plugin-storage-mongo](https://github.com/cosmo0920/fluent-plugin-storage-mongo)
* [fluent-plugin-storage-redis](https://github.com/cosmo0920/fluent-plugin-storage-redis)

## List of 3rd party Plugins with Storage support

NOTE: This 3rd party plugin list does not fully covers all of them.

* [fluent-plugin-systemd](https://github.com/fluent-plugin-systemd/fluent-plugin-systemd)
* [fluent-plugin-windows-eventlog](https://github.com/fluent/fluent-plugin-windows-eventlog)

{% include "../.gitbook/assets/footer.txt" %}
