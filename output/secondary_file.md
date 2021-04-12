# secondary\_file

![](../.gitbook/assets/file.png)

The `out_secondary_file` Output plugin writes chunks to files. This plugin is similar to `out_file` but this is for `<secondary>` use-case.

NOTE: Do not use this plugin for the primary plugin.

`out_secondary_file` is included in Fluentd's core.

## Example Configuration

```text
<match pattern>
  @type forward
  # ...
  <secondary>
    @type secondary_file
    directory /var/log/fluentd/error
  </secondary>
</match>
```

With this configuration, failed buffer chunks are saved into `/var/log/fluentd/error/dump.bin.N`, `N` is 0-origin incremental number.

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

## Plugin Helpers

No helpers.

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type` \(required\)

The value must be `secondary_file`.

### `directory`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 1.0.0 |

The directory path of the output file. Received buffer chunks are saved in this directory.

```text
<secondary>
  @type secondary_file
  directory /var/log/fluentd/error
</secondary>
```

### `basename`

| type | default | version |
| :--- | :--- | :--- |
| string | dump.bin | 1.0.0 |

The basename of the output file. You can use `${chunk_id}` placeholder to identify the original chunk.

```text
<secondary>
  @type secondary_file
  directory /var/log/fluentd/error
  basename dump.${chunk_id}
</secondary>
```

The output path would be:

```text
# 59c278456e74a22dc594b06a7d4247c4 is chunk id
/var/log/fluentd/error/dump.59c278456e74a22dc594b06a7d4247c4.0
```

### `append`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.0.0 |

Determines that the received chunk is appended to an existing file or not. By default, it is not appended and each chunk is flushed to a different path:

```text
# append false
dump.bin.0
dump.bin.1
dump.bin.2
...
dump.bin.N
```

This makes parallel file processing easy. But if you want to disable this behavior, you can disable it by setting `append true`:

```text
# append true
dump.bin
```

## How to resend secondary file

The secondary file can be resend by `fluent-cat` command.

Here is the example to resend `dump.bin.0` to `127.0.0.1:24224` using `fluent-cat`.

```text
$ cat /path/to/dump.bin.0 | fluent-cat --format msgpack  --host 127.0.0.1 --port 24224 TAG
```

See [fluent-cat](../deployment/command-line-option.md#fluent-cat) command line option about details.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

