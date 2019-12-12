# Service Discovery section configurations

Some of Fluentd's plugins support the `<service_discovery>` section to set target nodes dynamiclly

## Service Discovery section overview

Service discovery section can be used in `<match>`.

```
<match tag.*>
  @type forward
  # parameters for output plugin
  <service_discovery>
    # service_discovery section parameters
  </service_discovery>
</match>
```

## Service Discovery plugin type

`<service_discovery>` section requires `@type` parameter to specify the type of
service_discovery plugin. Fluentd core bundles [some useful service discovery plugins](/plugins/service_discovery/README.md).

```
<service_discovery>
  @type file
</service_discovery>
```

These are the list of built-in service discovery plugins.

-   [static](/plugins/service_discovery/static.md)
-   [file](/plugins/service_discovery/file.md)

For more details, see plugins documentation.

### @type

`@type` key is to specify the type of service discovery plugin.

```
<service_discovery>
  @type static
  # ...
</service_discovery>
```

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
