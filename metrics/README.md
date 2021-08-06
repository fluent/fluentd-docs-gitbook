# Metrics Plugins

Fluentd has nine \(9\) types of plugins:

* [Input](../input/)
* [Parser](../parser/)
* [Filter](../filter/)
* [Output](../output/)
* [Formatter](../formatter/)
* [Storage](../storage)
* [Service Discovery](../service_discovery/)
* [Buffer](../buffer/)
* [Metrics](./)

This article gives an overview of Metrics Plugin.

## Overview

Sometimes, the input/filter/output plugin needs to save its internal metrics in memory, influxdb or prometheus format ready in instances. Fluentd has a pluggable system called Metrics that lets a plugin store and reuse its internal state as metrics instances.

## How To Use

On Fluentd core, metrics plugin will handled on `<metrics>` on `<system>` to set up easily.

Here is an example with `metrics_local`:

```text
<system>
  <metrics>
    @type local
  </metrics>
</system>
```

`local` type plugin should provide equivalent behavior before Fluentd v1.13.
This metrics type should provide single numeric value storing functionality.

And this `local` type plugin should be used by default.

## List of Built-in Metrics Plugins

* [`local`](local.md)

## List of Base Plugin classes with Metrics support

* `Fluent::Plugin::Input` for Input plugin base class
* `Fluent::Plugin::Output` for most of output plugin base class
* `Fluent::Plugin::Filter` for Filter plugin base class
* `Fluent::Plugin::MultiOutput` for [out_copy](../output/copy.md) plugin base class
* `Fluent::Plugin::BareOutput` for fluent-plugin-forest output plugin base class

## List of 3rd party metrics plugins

NOTE: This 3rd party metrics plugin list does not fully covers all of them.

* [fluent-plugin-metrics-cmetrics](https://github.com/calyptia/fluent-plugin-metrics-cmetrics)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
