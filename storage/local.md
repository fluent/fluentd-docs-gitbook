# local

The `local` storage plugin stores the key-value pair into JSON file on local storage.

## Parameters

### `path`

Specifies the pathname to save the key-value pair. \(default: `nil`\)

### `mode`

Specifies the file access mode. \(default: `0644`\)

### `dir_mode`

Specifies the directory access mode. \(default: `0755`\)

### `pretty_print`

Outputs the human-readable formatted JSON. \(default: `false`\)

## Attributes

### `conf.arg`

Note that `conf.arg` provides an alternative `path` parameter.

```text
<storage awesome_path>
  @type local
</storage>

<system>
  root_dir tmp
</system>
```

The above configuration will save the internal states, which are handled by `storage_local` under `tmp` directory.

NOTE: Specifying the file path in the `path` parameter does not support the multi-workers feature. Instead, you should specify a directory there.

## Example

With this configuration:

```text
<source>
  @type sample
  auto_increment_key count
  tag storage.sample

  <storage>
    @type local
    path storage/sample.json
  </storage>
</source>
```

The above configuration will save the internal states such as `auto_increment_value` to `storage/sample.json`. As a result, you can resume from the next value of previous `count` when restarting fluentd.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

