# Storage section configurations

Some of Fluentd's plugins support the `<storage>` section to specify how
to handle plugin internal states.


## Storage section overview

Storage section can be in `<source>`, `<match>` or `<filter>` sections.
It's enabled for plugins which support storage plugin features.

```
<source>
  @type windows_eventlog
  # parameters for input plugin
  <storage>
    # storage section parameters
  </storage>
</source>
```


## storage plugin type

`<storage>` section requires `@type` parameter to specify the type of
storage plugin. Fluentd core bundles [a useful storage plugin](/plugins/storage/README.md). 3rd party plugins are also available
when installed.

```
<storage>
  @type local
</storage>
```

And some storage plugin can handle attributes in `<storage>` section as
below:

```
<storage awesome_path>
  @type local
</storage>
```

For more details, see plugins documentation.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
