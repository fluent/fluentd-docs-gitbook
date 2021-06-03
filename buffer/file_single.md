# file\_single

The `file_single` buffer plugin provides a persistent buffer implementation. It uses files to store buffer chunks on disk.

`file_single` is similar to `file_file` but it does not have the metadata file.

## Example Configuration

```text
<match pattern>
  @type forward
  # forward parameters
  <buffer>
    @type file_single
    path /var/log/fluent/out_fwd
  </buffer>
</match>
```

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Buffer Section Configurations](../configuration/buffer-section.md)

### `path`

| type | required | default | version |
| :--- | :---: | :--- | :--- |
| string | ✔ |  | 1.7.0 |

The directory path where buffer chunks are stored. This parameter is required.

This parameter must be unique to avoid race condition problem between output plugins. Of course, this parameter must also be unique between fluentd instances.

The actual path consists of five \(5\) parts:

* `path` parameter
* `fsb` prefix
* tag or field value
* chunk id
* `buf` extension

```text
# Example with <buffer tag> and tag is test.log
/path/to/buffer/fsb.test.log.b513b61c9791029c2513b61c9791029c2.buf

# Example with <buffer key> and record is {"key":"hello"}
/path/to/buffer/fsb.hello.b513b61c9791029c2513b61c9791029c2.buf
```

Under multi-worker environment, `worker_id` and plugin `id` are added:

```text
/path/to/buffer/worker1/out_fwd/fsb.test.log.b513b61c9791029c2513b61c9791029c2.buf
```

Please make sure that you have **enough space in the path directory**. Running out of disk space is a problem frequently reported by users.

### `calc_num_records`

| type | required | default | version |
| :--- | :---: | :--- | :--- |
| bool |  | true | 1.7.0 |

Calculate the number of records, chunk size, during chunk resume.

The `buf_file_single` plugin does not have the metadata file, so this plugin cannot keep the chunk size across fluentd restarts. If `true`, it calculates the chunk size by reading the file at startup.

If your plugin does not need the chunk size, you can set `false` to speedup the fluentd startup time.

This option is mainly for `out_forward`.

### `chunk_format`

| type | default | available values | version |
| :--- | :--- | :--- | :--- |
| enum | auto | msgpack/text/auto | 1.7.0 |

Specifies the chunk format for `calc_num_records`.

With `auto`, the plugin decides the chunk format by `formatted_to_msgpack_binary?`. This option is useful when the output plugin does not implement `formatted_to_msgpack_binary?` correctly.

## Limitation

### chunk keys

`buf_file_single` does not have the metadata file, so `buf_file_single` cannot use rich metadata. The chunk keys must be the only tag or one field key for now.

```text
<buffer>           # OK. Same as <buffer tag>
<buffer tag>       # OK
<buffer key>       # OK
<buffer time>      # NG. time is not supported
<buffer key1,key2> # NG. multiple field keys are not supported
```

This limitation will be removed by adding the metadata header in the file.

### Remote File System is Not Supported

Caution: `file_single` buffer implementation depends on the characteristics of the local file system. Don't use `file_single` buffer on remote file systems e.g. NFS, GlusterFS, HDFS and etc. We observed major data loss by using remote file system.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

