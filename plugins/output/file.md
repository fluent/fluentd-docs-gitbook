# file Output Plugin

![](/images/plugins/output/file.png)

The `out_file` Output plugin writes events to files. By default, it
creates files on a daily basis (around 00:10). This means that when you
first import records using the plugin, no file is created immediately.

The file will be created when the `timekey` condition has been met. To
change the output frequency, please modify the `timekey` value.


## Example Configuration

`out_file` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
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

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file. For `<buffer>` section,
please check [Buffer section cofiguration](/configuration/buffer-section.md).


## Plugin helpers

-   [formatter](/developer/api-plugin-helper-formatter.md)
-   [inject](/developer/api-plugin-helper-inject.md)
-   [compat\_parameters](/developer/api-plugin-helper-compat_parameters.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)


### @type (required)

The value must be `file`.


### path

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.0  |

The Path of the file. The actual path is path + time + ".log" by
default.\
The `path` parameter supports placeholders, so you can embed time, tag
and record fields in the path. Here is an example:

``` {.CodeRay}
path /path/to/${tag}/${key1}/file.%Y%m%d
<buffer tag,time,key1>
  # buffer parameters
</buffer>
```

See [Buffer section configurations](/configuration/buffer-section.md)
for more detail.

The `path` parameter is used as `<buffer>`'s `path` in this plugin.

Initially, you may see a file which looks like
\"/path/to/file.%Y%m%d/buffer.b5692238db04045286097f56f361028db.log\".
This is an intermediate buffer file
(\"b5692238db04045286097f56f361028db\" identifies the buffer). Once the
content of the buffer has been completely [flushed](/plugins/buffer/file.md), you will
see the output file without the trailing identifier.


### append

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.0  |

The flushed chunk is appended to existence file or not. The default is
not appended. By default, out\_file flushes each chunk to different
path.

``` {.CodeRay}
# append false
file.20140608.log_0
file.20140608.log_1
file.20140609.log_0
file.20140609.log_1
```

This makes parallel file processing easy. But if you want to disable
this behaviour, you can disable it by setting `append true`.

``` {.CodeRay}
# append true
file.20140608.log
file.20140609.log
```


### &lt;format&gt; directive

The format of the file content. The default `@type` is `out_file`.

Here is json example:

``` {.CodeRay}
<format>
  @type json
</format>
```

See [formatter article](/plugins/formatter/README.md) for more detail.


### format

Deprecated parameter. Use `<format>` instead.


### &lt;inject&gt; section

See [Inject section configurations](/configuration/inject-section) for more details.


### utc

Deprecated parameter. Use `timekey_use_utc` in `<buffer>` instead.


### add\_path\_suffix

| type | default | version |
|:-----|:--------|:--------|
| bool | true    | 0.14.9  |

Add path suffix or not. See also `path_suffix` parameter.


### path\_suffix

| type   | default | version |
|:-------|:--------|:--------|
| string | ".log"  | 0.14.9  |

The suffix of output result.


### compress

Compresses flushed files using `gzip`. No compression is performed by
default.


### recompress

Execute compression again even when buffer chunk is already compressed.
Default is `false`


### symlink\_path

Create symlink to temporary buffered file when `buffer_type` is `file`.
No symlink is created by default. This is useful for tailing file
content to check logs.

This is disabled on Windows.

#### @log\_level option

The `@log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.


## Common Output / Buffer parameters

For common output / buffer parameters, please check the following
articles.

-   [Output Plugin Overview](/plugins/output/README.md)
-   [Buffer Section Configuration](/configuration/buffer-section.md)


## FAQ


### I can see files but placeholders are not replaced, why?

You see intermediate buffer file, not output result. The placeholders
are replaced during flush buffers. For example, if you have this
setting:

``` {.CodeRay}
path /path/to/file.${tag}.%Y%m%d
```

You see following buffer files first:

``` {.CodeRay}
/path/to/file.${tag}.%Y%m%d/buffer.b5692238db04045286097f56f361028db.log
/path/to/file.${tag}.%Y%m%d/buffer.b5692238db04045286097f56f361028db.log.meta
```

After flushed, you see actual output result

``` {.CodeRay}
/path/to/file.test.20180405.log_0 # tag is 'test'
```

See also note in `path` parameter.

### Can I use a placeholder in symlink\_path?

Since Fluentd v1.4.0, you can use the placeholder syntax in
`symlink_path` parameter. For example, suppose you have the
following configuration.

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

This produces the following directory layout.

    $ tree /tmp/logs/
    /tmp/logs/
    ├── ${tag}
    │   ├── buffer.b57fb1dd96306dd0b308e094f7ec2228f.log
    │   ├── buffer.b57fb1dd96306dd0b308e094f7ec2228f.log.meta
    │   ├── buffer.b57fb1dd96339a870530991d4871cfe11.log
    │   └── buffer.b57fb1dd96339a870530991d4871cfe11.log.meta
    ├── current-dummy1 -> /tmp/logs/${tag}/buffer.b57fb1dd96339a870530991d4871cfe11.log
    └── current-dummy2 -> /tmp/logs/${tag}/buffer.b57fb1dd96306dd0b308e094f7ec2228f.log

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
