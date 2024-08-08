# copy

![](../.gitbook/assets/copy.png)

The `copy` output plugin copies events to multiple outputs.

It is included in Fluentd's core.

## Example Configuration

```text
<match pattern>
  @type copy
  <store>
    @type file
    path /var/log/fluent/myapp1
    ...
  </store>
  <store>
    ...
  </store>
  <store>
    ...
  </store>
</match>
```

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

Here is an example set up to send events to both a local file under `/var/log/fluent/myapp` and the collection `fluentd.test` to an Elasticsearch instance \(See [`out_file`](file.md) and [`out_elasticsearch`](elasticsearch.md)\):

```text
<match myevent.file_and_elasticsearch>
  @type copy
  <store>
    @type file
    path /var/log/fluent/myapp
    compress gzip
    <format>
      localtime false
    </format>
    <buffer time>
      timekey_wait 10m
      timekey 86400
      timekey_use_utc true
      path /var/log/fluent/myapp
    </buffer>
    <inject>
      time_format %Y%m%dT%H%M%S%z
      localtime false
    </inject>
  </store>
  <store>
    @type elasticsearch
    host fluentd
    port 9200
    index_name fluentd
    type_name fluentd
  </store>
</match>
```

## Plugin Helpers

* [`formatter`](../plugin-helper-overview/api-plugin-helper-formatter.md)
* [`inject`](../plugin-helper-overview/api-plugin-helper-inject.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)
* See also: [Output Plugin Overview](./)

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type`

The value must be `copy`.

### `copy_mode`

| type | default | available | version |
| :--- | :--- | :--- | :--- |
| enum | no\_copy | no\_copy, shallow, deep, marshal | 1.8.1 |

Chooses how to pass the events to `<store>` plugins.

Supported modes:

* `no_copy` \(default\)

  Share events between `store` plugins.

* `shallow`

  Pass shallow copied events to each `store` plugin. This mode uses Ruby's `dup` method. This mode is useful when you do not modify the nested fields after `out_copy`, e.g. remove top-level fields.

* `deep`

  Pass deep copied events to each `store` plugin. This mode uses `msgpack-ruby` internally. This mode is useful when you modify the nested field after `out_copy`, e.g. Kubernetes related fields.

* `marshal`

  Pass deep copied events to each `store` plugin. This mode uses Ruby's `marshal` internally. This mode is useful when `msgpack-ruby` cannot process your events. This mode is very slow.

### `deep_copy`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

This parameter is deprecated since v1.8.1. Use `copy_mode` instead.

`out_copy` shares a record between `store` plugins by default.

If `true`, `out_copy` passes dupped record to each `store` plugin. This behavior is similar to `copy_mode shallow`.

### `<store>` Section

Specifies the storage destinations. The format is the same as the `<match>` directive.

This section is required at least once.

#### `ignore_error` argument

If one `store` raises an error, it affects other `<store>`. For example:

```text
<match app.**>
  @type copy
  <store>
    @type plugin1
  </store>
  <store>
    @type plugin2
  </store>
</match>
```

If plugin1's emit/format raises an error, plugin2 is not executed. If you want to ignore an error from a less important `<store>`, you can specify `ignore_error` in `<store>`:

```text
<match app.**>
  @type copy
  <store ignore_error>
    @type plugin1
  </store>
  <store>
    @type plugin2
  </store>
</match>
```

### `ignore_if_prev_success` argument

Since Fluentd v1.12.2, you can use `ignore_if_prev_success` to define fallback outputs. For example:

```text
<match app.**>
  @type copy
  <store ignore_error>
    @type plugin1
    name c0
  </store>
  <store ignore_if_prev_success ignore_error>
    @type plugin2
    name c1
  </store>
</match>
```

Fluentd will make use of plugin2 only if the preceding destinations \(plugin1 in this case\) fail.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

