# copy Output Plugin

![](/images/plugins/output/copy.png)

The `copy` output plugin copies events to multiple outputs.


## Example Configuration

`out_copy` is included in Fluentd's core. No additional installation
process is required.

```
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

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

Here is an example set up to send events to both a local file under
`/var/log/fluent/myapp` and the collection `fluentd.test` in a
Elasticsearch instance (Please see the [out\_file](/plugins/output/file.md)
and [out\_elasticsearch](/plugins/output/elasticsearch.md) articles for more
details about the respective plugins.)

```
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


## Plugin helpers

-   [formatter](/developer/api-plugin-helper-formatter.md)
-   [inject](/developer/api-plugin-helper-inject.md)
-   [compat\_parameters](/developer/api-plugin-helper-compat_parameters.md)

-   See also: [Output Plugin Overview](/plugins/output/README.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

### @type

The value must be `copy`.


### copy_mode

| type | default | available                       | version |
|:-----|:--------|:--------------------------------|:--------|
| enum | no_copy | no_copy, shallow, deep, marshal | 1.8.1   |

Choose "How to pass the events to `<store>` plugins".

- `no_copy`

Share events between `store` plugins. This is default mode.

- `shallow`

Pass shallow copied events to each `store` plugin. This mode uses ruby's `dup` method.
This mode is useful when you don't modify nested fields after `out_copy`, e.g. remove top-level fields.

- `deep`

Pass deep copied events to each `store` plugin. This mode uses `msgpack-ruby` internally.
This mode is useful when you modify nested field after `out_copy`, e.g. kubernetes related fields.

- `marshal`

Pass deep copied events to each `store` plugin. This mode uses ruby's `marshal` internally.
This mode is useful when `msgpack-ruby` can't process your events. This mode is very slow.


### deep\_copy

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.0  |

This parameter is deprecated since v1.8.1. Use `copy_mode` instead.

`out_copy` shares a record between `store` plugins by default.

When `deep_copy` is true, `out_copy` passes dupped record to each `store` plugin.
This is same behaviour with `copy_mode shallow`.


### &lt;store&gt; section

Specifies the storage destinations. The format is the same as the
`<match>` directive.

This section is required at least once.

#### ignore\_error argument

If one `store` raises an error, it affects other `<store>`. For example,

```
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

if plugin1's emit/format raises an error, plugin2 is not executed. If
you want to ignore an error from less important `<store>`, you can
specify `ignore_error` in `<store>`.

```
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


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
