# dummy Input Plugin

The `in_dummy` input plugin generates dummy events. It is useful for
testing, debugging, benchmarking and getting started with Fluentd.


## Example Configuration

`in_dummy` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<source>
  @type dummy
  dummy {"hello":"world"}
</source>
```
Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

## Parameters

### \@type (required)

The value must be `dummy`.

### tag (required)

The value is the tag assigned to the generated events.

### dummy (optional)

The dummy data to be generated. It should be either an array of JSON
hashes or a single JSON hash. If it is an array of JSON hashes, the
hashes in the array are cycled through in order. By default, the value
is `[{"message":"dummy"}]` (i.e., it continues to generate events with
the record {"message":"dummy"}).

### auto\_increment\_key (optional, string type)

If specified, each generated event has an auto-incremented key field.
For example, with `auto_increment_key foo_key`, the first couple of
events look like

``` {.CodeRay}
2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":0}
2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":1}
2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":2}
```

### rate (optional, integer type)

It configures how many events to generate per second. The default value
is 1.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
