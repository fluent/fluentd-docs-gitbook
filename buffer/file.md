# file

The `file` buffer plugin provides a persistent buffer implementation. It uses files to store buffer chunks on disk.

## Parameters

* [Common Parameters](../configuration/plugin-common-parameters.md)
* [Buffer Section Configurations](../configuration/buffer-section.md)

### `path`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | TBD |

The path where buffer chunks are stored.

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

## Example

```text
<match pattern>
  <buffer>
    @type file
    path /var/log/fluent/myapp.*.buffer
  </buffer>
</match>
```

## Tips

## Limitation

Caution: `file` buffer implementation depends on the characteristics of the local file system. Don't use `file` buffer on remote file systems e.g. NFS, GlusterFS, HDFS, etc. We observed major data loss by using the remote file system.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

