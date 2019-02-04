# file Buffer Plugin

The `file` buffer plugin provides a persistent buffer implementation. It
uses files to store buffer chunks on disk.


## Parameters

-   [Common Parameters](/configuration/plugin-common-parameters.md)
-   [Buffer section configurations](/configuration/buffer-section.md)


### path

    type    required   default   version	|
|--------|----------|---------|---------|
|	string      ✔                  0.9.0

The path where buffer chunks are stored. The '\*' is replaced with
random characters. This parameter is require

This parameter must be unique to avoid race condition problem. For
example, you can't use fixed path parameter in fluent-plugin-forest.
`${tag}` or similar placeholder is needed. Of course, this parameter
must also be unique between fluentd instances.

In addition, `path` should not be an other `path` prefix. For example,
the following conf doesn't work well. `/var/log/fluent/foo` resumes
`/var/log/fluent/foo.bar`'s buffer files during start phase and it
causes `No such file or directory` in `/var/log/fluent/foo.bar` side.

``` {.CodeRay}
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

Here is the correct version to avoid prefix problem.

``` {.CodeRay}
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


## Example

``` {.CodeRay}
<match pattern>
  <buffer>
    @type file
    path /var/log/fluent/myapp.*.buffer
  </buffer>
</match>
```


## Limitation

Caution, `file` buffer implementation depends on the characteristics of
local file system. Don't use `file` buffer on remote file system, e.g.
NFS, GlusterFS, HDFS and etc. We observed major data loss by using
remote file system.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
