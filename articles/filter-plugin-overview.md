# Filter Plugin Overview

Fluentd has 7 types of plugins: [Input](/articles/input-plugin-overview.md),
[Parser](/articles/parser-plugin-overview.md), [Filter](/articles/filter-plugin-overview.md),
[Output](/articles/output-plugin-overview.md),
[Formatter](/articles/formatter-plugin-overview.md),
[Storage](/articles/storage-plugin-overview.md) and [Buffer](/articles/buffer-plugin-overview.md).
This article gives an overview of Filter Plugin.


## Overview

Filter plugins enables Fluentd to modify event streams. Example use
cases are:

1.  Filtering out events by grepping the value of one or more fields.
2.  Enriching events by adding new fields.
3.  Deleting or masking certain fields for privacy and compliance.


## How to Use

It is used with the `<filter>` directive as follows:

``` {.CodeRay}
<filter foo.bar>
  @type grep
  regexp1 message cool
</filter>
```

The above directive matches events with the tag "foo.bar", and if the
"message" field's value contains "cool", the events go through the rest
of the configuration.

Like the `<match>` directive for output plugins, `<filter>` matches
against a tag. Once the event is processed by the filter, the event
proceeds through the configuration top-down. Hence, if there are
multiple filters for the same tag, they are applied in descending order.
Hence, in the following example,

``` {.CodeRay}
<filter foo.bar>
  @type grep
  regexp1 message cool
</filter>

<filter foo.bar>
  @type record_transformer
  <record>
    hostname "#{Socket.gethostname}"
  </record>
</filter>
```

Only the events whose "message" field contain "cool" get the new field
"hostname" with the machine's hostname as its value.

Users can create their own custom plugins with a bit of Ruby. See [this
section](plugin-development#filter-plugins) for more information.


## Filter chain optimization

If you have multiple filters in the pipeline, fluentd tries to optimize
filter calls to improve the performance. The condition for optimization
is all plugins in the pipeline use `filter` method. If the plugin which
uses `filter_stream` exists, chain optimization is disabled. If you see
following message in the log, the optimization is disabled.

``` {.CodeRay}
disable filter chain optimization because [Fluent::Plugin::XXXFilter] uses `#filter_stream` method
```

This is not critical log message and you can ignore it.


## List of Filter Plugins

-   [grep](/articles/filter_grep.md)
-   [record-transformer](/articles/filter_record_transformer.md)
-   [filter\_stdout](/articles/filter_stdout.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
