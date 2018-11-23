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

Please see the [Config File](/articles/config-file.md) article for the basic
structure and syntax of the configuration file.


## Plugin helpers

-   [thread](/articles/api-plugin-helper-thread.md)
-   [storage](/articles/api-plugin-helper-storage.md)

-   See also: [Input Plugin Overview](/articles/input-plugin-overview.md)


## Parameters

[Common Parameters](/articles/plugin-common-parameters.md)

[]{#@type}

### \@type

The value must be `dummy`.


### tag

    type    default   version
  -------- --------- ---------
   string   Nothing   0.14.0

The value is the tag assigned to the generated events.


### size

    type     default   version
  --------- --------- ---------
   integer      1      0.14.4

The number of events in event stream of each emits.


### rate

    type     default   version
  --------- --------- ---------
   integer      1      0.14.0

It configures how many events to generate per second.


### auto\_increment\_key

    type    default   version
  -------- --------- ---------
   string     nil     0.14.0

If specified, each generated event has an auto-incremented key field.

For example, with `auto_increment_key foo_key`, the first couple of
events look like:

``` {.CodeRay}
2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":0}
2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":1}
2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":2}
```


### suspend

   type   default   version
  ------ --------- ---------
   bool    false    0.14.2

The boolean to suspend-and-resume incremental value after restart.


### dummy

    type            default            version
  -------- -------------------------- ---------
   string   `[{"message": "dummy"}]`   0.14.0

The dummy data to be generated. It should be either an array of JSON
hashes or a single JSON hash. If it is an array of JSON hashes, the
hashes in the array are cycled through in order.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
