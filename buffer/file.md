# file

The `file` buffer plugin provides a persistent buffer implementation. It uses files to store buffer chunks on disk.

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Buffer Section Configurations](../configuration/buffer-section.md)

### `path`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.9.0 |

The directory path where buffer chunks are stored. Don't share this directory path with other buffers.
Be sure to specify a unique path for each buffer.

```text
<match pattern>
  ...
  <buffer>
    @type file
    path /var/log/fluent/buf
  </buffer>
</match>
```

This config outputs the buffer chunk files as follows. The file name is `buffer.b{chunk_id}{path_suffix}`.

```text
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.log
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.log.meta
```

With [multiple workers](../deployment/multi-process-workers.md), a directory is automatically created for each worker.
So there is no need to specify a unique path for each worker.

```text
<system>
  workers 2
</system>

...

<match pattern>
  ...
  <buffer>
    @type file
    path /var/log/fluent/buf
  </buffer>
</match>
```

This config outputs the buffer chunk files as follows. The directory `worker{worker_id}` is automatically created.

```text
/var/log/fluentd/buf/worker0/buffer.b58eec11d08ca8143b40e4d303510e0bb.log
/var/log/fluentd/buf/worker0/buffer.b58eec11d08ca8143b40e4d303510e0bb.log.meta

/var/log/fluentd/buf/worker1/buffer.b5e2a5aca2bcd9818ad6718845ddc456a.log
/var/log/fluentd/buf/worker1/buffer.b5e2a5aca2bcd9818ad6718845ddc456a.log.meta
```

If you specify `root_dir` in [system configuration](../deployment/system-config.md) and [@id](../configuration/plugin-common-parameters.md#id) of the plugin,
then you can omit this parameter.

```text
<system>
  root_dir /var/log/fluentd
</system>

...

<match pattern>
  @id test_id
  ...
  <buffer>
    @type file
  </buffer>
</match>
```

This config outputs the buffer chunk files as follows. The directory `{root_dir}/worker{worker_id}/{@id}/buffer` is used for the path.
In this case, the `worker{worker_id}` directory is created even for a single worker.

```text
/var/log/fluentd/worker0/test_id/buffer/buffer.b58eec11d08ca8143b40e4d303510e0bb.log
/var/log/fluentd/worker0/test_id/buffer/buffer.b58eec11d08ca8143b40e4d303510e0bb.log.meta
```

Please make sure that you have **enough space in the path directory**. Running out of disk space is a problem frequently reported by users.

### `path_suffix`

| type | default | version |
| :--- | :--- | :--- |
| string | .log | 1.6.3 |

Changes the suffix of the buffer file.

```text
# default 
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.log
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.log.meta

# with 'path_suffix .buf'
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.buf
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.buf.meta
```

This parameter is useful when `.log` is not fit for your environment. See also [this issue's comment](https://github.com/fluent/fluentd/issues/2236#issuecomment-514733974).

## Tips

### Customize a filename of the buffer chunk

You can customize the prefix of filename (`buffer` by default) by adding `.*` to the end of the `path` parameter.

```text
<match pattern>
  ...
  <buffer>
    @type file
    path /var/log/fluent/buf/custom.*
  </buffer>
</match>
```

This config outputs the buffer chunk files as follows. The prefix `buffer` is changed to `custom`.

```text
/var/log/fluentd/buf/custom.b58eec11d08ca8143b40e4d303510e0bb.log
/var/log/fluentd/buf/custom.b58eec11d08ca8143b40e4d303510e0bb.log.meta
```

You can also customize the entire filename by adding `.*.` to the `path` parameter.

```text
<match pattern>
  ...
  <buffer>
    @type file
    path /var/log/fluent/buf/custom_prefix.*.custom_suffix
  </buffer>
</match>
```

This config outputs the buffer chunk files as follows. In this case, `path_suffix` parameter is not used.

```text
/var/log/fluentd/buf/custom_prefix.b58eec11d08ca8143b40e4d303510e0bb.custom_suffix
/var/log/fluentd/buf/custom_prefix.b58eec11d08ca8143b40e4d303510e0bb.custom_suffix.meta
```

## Limitation

Caution: `file` buffer implementation depends on the characteristics of the local file system. Don't use `file` buffer on remote file systems e.g. NFS, GlusterFS, HDFS, etc. We observed major data loss by using the remote file system.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

