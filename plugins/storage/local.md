# `local` Storage Plugin

The `local` storage plugin stores the key-value pair into JSON file on local
storage.


## Parameters


### `path`

Specifies the path name to save key-value pair. (default: `nil`)


### `mode`

Specifies the file access mode. (default: `0644`)


### `dir_mode`

Specifies the directory access mode. (default: `0755`)


### `pretty_print`

Output human readable formatted JSON. (default: `false`)


## Attributes


### `conf.arg`

Note that `conf.arg` provides an alternative `path` parameter.

```
<storage awesome_path>
  @type local
</storage>

<system>
  root_dir tmp
</system>
```

The above configuration will save the internal states, which are handled by
`storage_local` under `tmp` directory.

NOTE: Specifying filepath in `path` parameter does not support multi workers
feature. Instead, you should specify directory there.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
