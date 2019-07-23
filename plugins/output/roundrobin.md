# roundrobin Output Plugin

The `roundrobin` Output plugin distributes events to multiple outputs
using a round-robin algorithm.


## Example Configuration

`out_roundrobin` is included in Fluentd's core. No additional
installation process is required.

``` {.CodeRay}
<match pattern>
  @type roundrobin

  <store>
    @type tcp
    host 192.168.1.21
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
Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

## Parameters

### type (required)

The value must be `roundrobin`.

### &lt;store&gt; (required at least one)

Specifies the storage destinations. The format is the same as the
\<match\> directive.

#### log\_level option

The `log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
