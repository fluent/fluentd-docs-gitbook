copy Output Plugin
==================

The `copy` output plugin copies events to multiple outputs.


Example Configuration
---------------------

`out_copy` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<match pattern>
  @type copy
  <store>
    @type file
    path /var/log/fluent/myapp1
    ...
  </store>
  <store>
    ...
  </store>
  <store>
    ...
  </store>
</match>
```
Please see the [Config File](config-file.md) article for the basic
structure and syntax of the configuration file.

Here is an example set up to send events to both a local file under
`/var/log/fluent/myapp` and the collection `fluentd.test` in a local
MongoDB instance (Please see the [out\_file](/articles/out_file) and
[out\_mongo](/articles/out_mongo) articles for more details about the
respective plugins.)

``` {.CodeRay}
<match myevent.file_and_mongo>
  @type copy
  <store>
    @type file
    path /var/log/fluent/myapp
    time_slice_format %Y%m%d
    time_slice_wait 10m
    time_format %Y%m%dT%H%M%S%z
    compress gzip
    utc
  </store>
  <store>
    @type mongo
    host fluentd
    port 27017
    database fluentd
    collection test
  </store>
</match>
```

Parameters
----------

### \@type (required)

The value must be `copy`.

### deep\_copy

`out_copy` shares a record between `store` plugins by default.

When `deep_copy` is true, `out_copy` passes different record to each
`store` plugin.

### \<store\> (at least one required)

Specifies the storage destinations. The format is the same as the
\<match\> directive.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](logging.md) for further details.

FAQ
---

### How to ignore each error in \\\<store\>?

If one `store` raises an error, it affects other `<store>`. If you want
to ignore an exception from less important `<store>`, you can use 3rd
party [out\_copy\_ex](https://github.com/sonots/fluent-plugin-copy_ex)
instead.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
