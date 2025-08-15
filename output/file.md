# file

![](../.gitbook/assets/file.png)

The `out_file` Output plugin writes events to files. By default, it creates files on a daily basis \(around 00:10\). This means that when you first import records using the plugin, no file is created immediately.

The file will be created when the `timekey` condition has been met. To change the output frequency, please modify the `timekey` value.

It is included in Fluentd's core.

## Example Configuration

```text
<match pattern>
  @type file
  path /var/log/fluent/myapp
  compress gzip
  <buffer>
    timekey 1d
    timekey_use_utc true
    timekey_wait 10m
  </buffer>
</match>
```

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

For `<buffer>`, refer to [`<buffer>` Section](#less-than-buffer-greater-than-section).

## Plugin Helpers

* [`formatter`](../plugin-helper-overview/api-plugin-helper-formatter.md)
* [`inject`](../plugin-helper-overview/api-plugin-helper-inject.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type` \(required\)

The value must be `file`.

### `path`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.0 |

The path of the file. The actual path is path + time + ".log" by default. The `path` parameter supports placeholders, so you can embed `time`, `tag` and `record` fields in the path.

Here is an example:

```text
path /path/to/${tag}/${key1}/file.%Y%m%d
<buffer tag,time,key1>
  # buffer parameters
</buffer>
```

See [`<buffer>` Section](#less-than-buffer-greater-than-section) for more detail.

The `path` parameter is used as `<buffer>`'s `path` in this plugin.

Initially, you may see a file which looks like `/path/to/file.%Y%m%d/buffer.b5692238db04045286097f56f361028db.log`. This is an intermediate buffer file \(`b5692238db04045286097f56f361028db` identifies the buffer\). Once the content of the buffer has been completely [flushed](../buffer/file.md), you will see the output file without the trailing identifier.

### `append`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

Determines whether the flushed chunk is appended to an existing file or not. The default is not appended. By default, `out_file` flushes each chunk to a different path.

```text
# append false
file.20140608.log_0
file.20140608.log_1
file.20140609.log_0
file.20140609.log_1
```

This makes parallel file processing easy. But if you want to disable this behavior, you can disable it by setting `append true`.

```text
# append true
file.20140608.log
file.20140609.log
```

### `<format>` Directive

The format of the file content. The default `@type` is `out_file`.

JSON example:

```text
<format>
  @type json
</format>
```

See [`formatter`](../formatter/) article for more detail.

### `format`

Deprecated parameter. Use `<format>` instead.

### `<inject>` Section

Add event `time` and event `tag` to record.

See [Inject Section Configurations](../configuration/inject-section.md) for more details.

### `<buffer>` Section

See [Buffer Section Configurations](../configuration/buffer-section.md) for more details.

#### `@type`

| type | default | version |
| :--- | :--- | :--- |
| string | file | 0.14.9 |

Overwrites the default value in this plugin.

#### `chunk_keys`

| type | default | version |
| :--- | :--- | :--- |
| array | time | 0.14.9 |

Overwrites the default value in this plugin.

#### `timekey`

| type | default | version |
| :--- | :--- | :--- |
| time | 86400 | 0.14.9 |

Overwrites the default value in this plugin.

### `utc`

Deprecated parameter. Use `timekey_use_utc` in `<buffer>` instead.

### `add_path_suffix`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.9 |

Add path suffix or not. See also the `path_suffix` parameter.

### `path_suffix`

| type | default | version |
| :--- | :--- | :--- |
| string | ".log" | 0.14.9 |

The suffix for output result.

### `compress`

| type | default |
| :--- | :---    |
| enum | text    |

Compresses flushed files.

No compression is performed by default.

Supported values:

* `text`
* `gz`
* `gzip`
* `zstd` (since v1.19.0)

### `recompress`

Performs compression again even if the buffer chunk is already compressed.

Default: `false`

### `symlink_path`

Creates symlink to temporary buffered file when `buffer_type` is `file`. No symlink is created by default. This is useful for tailing file content to check logs.

This is disabled on Windows.

### `symlink_path_use_relative`

Specify whether it creates symlink using relative path in `symlink_path`. The absolute path is used by default.
This parameter is introduced since v1.19.0.

#### `@log_level`

The `@log_level` option allows the user to set different levels of logging for each plugin.

Supported log levels: `fatal`, `error`, `warn`, `info`, `debug`, `trace`

Please see the [logging](../deployment/logging.md) article for further details.

## Common Output / Buffer parameters

For common output / buffer parameters, please check the following articles:

* [Output Plugin Overview](./)
* [Buffer Section Configuration](../configuration/buffer-section.md)

## FAQ

### I can see files but placeholders are not replaced, why?

You see an intermediate buffer file, not the output result. The placeholders are replaced during flush buffers.

For example, if you have this setting:

```text
path /path/to/file.${tag}.%Y%m%d
```

You see following buffer files first:

```text
/path/to/file.${tag}.%Y%m%d/buffer.b5692238db04045286097f56f361028db.log
/path/to/file.${tag}.%Y%m%d/buffer.b5692238db04045286097f56f361028db.log.meta
```

After flushed, you see actual output result:

```text
/path/to/file.test.20180405.log_0 # tag is 'test'
```

See the `path` parameter.

### Can I use a placeholder in `symlink_path`?

Since Fluentd v1.4.0, you can use the placeholder syntax in `symlink_path` parameter.

For example, suppose you have the following configuration:

```text
<source>
  @type dummy
  tag dummy1
</source>

<source>
  @type dummy
  tag dummy2
</source>

<match dummy*>
  @type file
  path /tmp/logs/${tag}
  symlink_path /tmp/logs/current-${tag}
  <buffer tag,time>
    @type file
  </buffer>
</match>
```

This produces the following directory layout:

```text
$ tree /tmp/logs/
/tmp/logs/
├── ${tag}
│   ├── buffer.b57fb1dd96306dd0b308e094f7ec2228f.log
│   ├── buffer.b57fb1dd96306dd0b308e094f7ec2228f.log.meta
│   ├── buffer.b57fb1dd96339a870530991d4871cfe11.log
│   └── buffer.b57fb1dd96339a870530991d4871cfe11.log.meta
├── current-dummy1 -> /tmp/logs/${tag}/buffer.b57fb1dd96339a870530991d4871cfe11.log
└── current-dummy2 -> /tmp/logs/${tag}/buffer.b57fb1dd96306dd0b308e094f7ec2228f.log
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

