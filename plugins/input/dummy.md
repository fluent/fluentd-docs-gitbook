# `dummy` Input Plugin

![dummy.png](/images/plugins/input/dummy.png)

The `in_dummy` input plugin generates dummy events. It is useful for
testing, debugging, benchmarking and getting started with Fluentd.

It is included in Fluentd's core.


## Example Configuration

```
<source>
  @type dummy
  dummy {"hello":"world"}
</source>
```

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.


## Plugin Helpers

-   [`thread`](/developer/api-plugin-helper-thread.md)
-   [`storage`](/developer/api-plugin-helper-storage.md)
-   See also: [Input Plugin Overview](/plugins/input/README.md)


## Parameters

See [Common Parameters](/configuration/plugin-common-parameters.md).

### `@type`

The value must be `dummy`.


### `tag`

| type   | default | version |
|:-------|:--------|:--------|
| string | Nothing | 0.14.0  |

The value is the tag assigned to the generated events.


### `size`

| type    | default | version |
|:--------|:--------|:--------|
| integer | 1       | 0.14.4  |

The number of events in event stream of each emits.


### `rate`

| type    | default | version |
|:--------|:--------|:--------|
| integer | 1       | 0.14.0  |

It configures how many events to generate per second.


### `auto_increment_key`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

If specified, each generated event has an auto-incremented key field.

For example, with `auto_increment_key foo_key`, the first couple of
events look like:

```
2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":0}
2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":1}
2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":2}
```


### `suspend`

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.2  |

This parameter is removed since v1.10.0. This feature is automatically handled in the core.


### `dummy`

| type   | default                  | version |
|:-------|:-------------------------|:--------|
| string | `[{"message": "dummy"}]` | 0.14.0  |

The dummy data to be generated. It should be either an array of JSON
hashes or a single JSON hash. If it is an array of JSON hashes, the
hashes in the array are cycled through in order.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
