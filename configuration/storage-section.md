# Config: Storage Section

Some of the Fluentd plugins support the `<storage>` section to specify how to handle the plugin's internal states.

## Storage Section Overview

The **`storage`** section can be under `<source>`, `<match>` or `<filter>` section. It is enabled for the plugins that support storage plugin features.

```text
<source>
  @type windows_eventlog
  # ...
  <storage>
    # ...
  </storage>
</source>
```

## Storage Plugin Type

The `@type` parameter of `<storage>` section specifies the type of the storage plugin. Fluentd core bundles a useful [storage plugin](../storage/).

```text
<storage>
  @type local
</storage>
```

Some `storage` plugins may have argument\(s\) in `<storage>` section:

```text
<storage awesome_path>
  @type local
</storage>
```

Third-party plugins may also be installed and configured.

For more details, see plugins documentation.

## Parameters

{% hint style='info' %}
NOTE: It depends on a plugin's capabilities whether can handle a `<storage>` section or not. See each plugin's documentation in detail.
{% endhint %}

The following parameters are common to all storage plugins. Individual storage plugins may add their own parameters. See each plugin's documentation in detail.

* **`persistent`** \(bool\) \(optional\): If `true`, the storage reloads its data from the data source before every read/write operation and saves it back after every write operation. This keeps the data source always up-to-date at the cost of an I/O per operation. If `false`, the operations are performed against the in-memory copy only, and saving is left to `autosave` and `save_at_shutdown`.
  * Default: `false`
  * Note that some plugins require additional configuration to be persistent. For example, [`local`](../storage/local.md) raises a configuration error unless the plugin `@id` or the `path` parameter is given.
* **`autosave`** \(bool\) \(optional\): If `true`, the storage periodically saves its data in the background at the `autosave_interval` interval. This is ignored when `persistent` is `true`, because every operation already saves the data.
  * Default: `true`
* **`autosave_interval`** \(time\) \(optional\): The interval of the periodic save enabled by `autosave`.
  * Default: `10`
* **`save_at_shutdown`** \(bool\) \(optional\): If `true`, the storage saves its data when the plugin shuts down. This takes effect regardless of `persistent` and `autosave`.
  * Default: `true`

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

