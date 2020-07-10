# Storage Section Configurations

Some of the Fluentd plugins support the `<storage>` section to specify how to handle the plugin's internal states.


## Storage Section Overview

The **`storage`** section can be under `<source>`, `<match>` or `<filter>` section. It is enabled for the plugins that support storage plugin features.

```
<source>
  @type         windows_eventlog
  # ...
  <storage>
    # ...
  </storage>
</source>
```


## Storage Plugin Type

The `@type` parameter of `<storage>` section specifies the type of the storage plugin. Fluentd core bundles [a useful storage plugin](/plugins/storage/README.md). 

```
<storage>
  @type         local
</storage>
```

Some `storage` plugins may have argument(s) in `<storage>` section:

```
<storage awesome_path>
  @type         local
</storage>
```

Third-party plugins may also be installed and configured.

For more details, see plugins documentation.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
