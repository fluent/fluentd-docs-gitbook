# local Storage Plugin

The `local` storage plugin stores the key-value into json file in local
storage.


## Parameters


### path

Specify path name to save key-value pair. Default is `nil`.


### mode

Specify file access mode. Default is `0644`.

[]{#dir_mode}

### dir\_mode

Specify directory access mode. Default is `0755`.

[]{#pretty_print}

### pretty\_print

Output human readable formatted json. Default is `false`.


Attributes
----------


### conf.arg

Note that `conf.arg` is also to be able to use alternative `path`
parameter.

``` {.CodeRay}
<storage awesome_path>
  @type local
</storage>
<system>
  root_dir tmp
</system>
```

will save internal states, which are handled by storage\_local, under
`tmp` directory.

Note: Specifying filepath in path parameter does not support
multiworkers feature. Instead, you should specify directory there.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
