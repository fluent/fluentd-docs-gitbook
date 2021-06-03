# Service Discovery Plugins

Fluentd has eight \(8\) types of plugins:

* [Input](../input/)
* [Parser](../parser/)
* [Filter](../filter/)
* [Output](../output/)
* [Formatter](../formatter/)
* [Storage](../storage/)
* [Service Discovery](./)
* [Buffer](../buffer/)

This article gives an overview of the Service Discovery Plugin.

## Overview

Some plugins support `<service_discovery>` \(e.g. [`out_forward`](../output/forward.md)\). Sometimes, the service discovery for an output plugin does not meet one's needs. Fluentd has a pluggable system called Service Discovery that lets the user extend and reuse custom output service discovery.

## How To Use

Here is a simple example to update target by reading file \(`/etc/fluentd/sd.yaml`\) with `out_forward` and `service_discovery`:

```text
<source>
  @type forward

  <service_discovery>
    @type file
    path "/etc/fluentd/sd.yaml"
  </service_discovery>
</source>
```

## List of Built-in Service Discovery

* [`static`](static.md)
* [`file`](file.md)
* [`srv`](srv.md)

## List of Core Output Plugins with Service Discovery support

* [`out_forward`](../output/forward.md)

{% include "../.gitbook/assets/footer.txt" %}
