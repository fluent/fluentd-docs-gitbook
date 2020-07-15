# `file` Buffer Plugin

The `file` buffer plugin provides a persistent buffer implementation. It
uses files to store buffer chunks on disk.


## Parameters

-   [Common Parameters](/configuration/plugin-common-parameters.md)
-   [Buffer Section Configurations](/configuration/buffer-section.md)


### `path`

| type   | required | default | version |
|:-------|:--------:|:--------|:--------|
| string |     ✔    |         |   0.9.0 |

The path where buffer chunks are stored. The '\*' is replaced with
random characters. This parameter is required.

This parameter must be unique to avoid the race condition problem. For
example, you cannot use fixed path parameter in `fluent-plugin-forest`.
`${tag}` or similar placeholder is needed. Of course, this parameter
must also be unique between fluentd instances.

In addition, `path` should not be another `path` prefix. For example,
the following configuration does not work well. `/var/log/fluent/foo` resumes
`/var/log/fluent/foo.bar`'s buffer files during start phase and it
causes `No such file or directory` in `/var/log/fluent/foo.bar` side.

```
<match pattern1>
  <buffer>
    @type file
    path /var/log/fluent/foo
  </buffer>
</match>

<match pattern2>
  <buffer>
    @type file
    path /var/log/fluent/foo.bar
  </buffer>
</match>
```

Here is the correct version to avoid the prefix problem:

```
<match pattern1>
  <buffer>
    @type file
    path /var/log/fluent/foo.baz
  </buffer>
</match>

<match pattern2>
  <buffer>
    @type file
    path /var/log/fluent/foo.bar
  </buffer>
</match>
```

Please make sure that you have **enough space in the path directory**.
Running out of disk space is a problem frequently reported by users.


### `path_suffix`

| type   | default | version |
|:-------|:--------|:--------|
| string | .log    | 1.6.3   |

Changes the suffix of buffer file.

```
# default 
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.log
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.log.meta

# with 'path_suffix .buf'
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.buf
/var/log/fluentd/buf/buffer.b58eec11d08ca8143b40e4d303510e0bb.buf.meta
```

This parameter is useful when `.log` is not fit for your environment. See also [this issue comment](https://github.com/fluent/fluentd/issues/2236#issuecomment-514733974).


## Example

```
<match pattern>
  <buffer>
    @type file
    path /var/log/fluent/myapp.*.buffer
  </buffer>
</match>
```


## Limitation

Caution: `file` buffer implementation depends on the characteristics of
the local file system. Don't use `file` buffer on remote file systems e.g.
NFS, GlusterFS, HDFS and etc. We observed major data loss by using
remote file system.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
