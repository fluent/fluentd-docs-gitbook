# UDP Input Plugin

![](/images/plugins/input/udp.png)

The `in_udp` Input plugin enables Fluentd to accept UDP payload.


## Example Configuration

`in_udp` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<source>
  @type udp
  tag mytag # required
  <parse>
    @type regexp
    expression /^(?<field1>\d+):(?<field2>\w+)$/
  </parse>
  port 20001               # optional. 5160 by default
  bind 0.0.0.0             # optional. 0.0.0.0 by default
  message_length_limit 1MB # optional. 4096 bytes by default
</source>
```

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file. For \<parse\> section,
please check [Parse section cofiguration](/configuration/parse-section.md).

We\'ve observed the drastic performance improvements on Linux, with
proper kernel parameter settings (e.g. \`net.core.rmem\_max\`
parameter). If you have high-volume UDP traffic, please make sure to
follow the instruction described at [Before Installing Fluentd](/articles/before-install.md).


## Plugin helpers

-   [server](/articles/api-plugin-helper-server.md)
-   [parser](/articles/api-plugin-helper-parser.md)
-   [extract](/articles/api-plugin-helper-extract.md)
-   [compat\_parameters](/articles/api-plugin-helper-compat_parameters.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

### @type

The value must be `udp`.


### tag

|	    type |        default |        version	|
|--------|--------------------|---------|
|	   string | required parameter | 0.14.0	|

tag of output events.


### port

|	    type |    default |  version	|
|---------|---------|---------|
|	   integer | 5160 | 0.14.0	|

The port to listen to. Default Value = 5160


### bind

|	    type |           default |          version	|
|--------|-------------------------|---------|
|	   string | 0.0.0.0 (all addresses) | 0.14.0	|

The bind address to listen to.


### source\_hostname\_key

|	    type |           default |           version	|
|--------|--------------------------|---------|
|	   string | nil (no adding hostname) | 0.14.10	|

The field name of the client's hostname. If set the value, the client's
hostname will be set to its key.

If you set following configuration:

``` {.CodeRay}
source_hostname_key client_host
```

then the client's hostname is set to `client_host` field.

``` {.CodeRay}
{
    ...
    "foo": "bar",
    "client_host": "client.hostname.org"
}
```


### message\_length\_limit

|	   type |  default |  version	|
|------|---------|---------|
|	   size | 4096 | 0.14.14	|

The max bytes of message


### remove\_newline

|	   type |  default |  version	|
|------|---------|---------|
|	   bool | true | 0.14.23	|

Remove newline from the end of incoming payload


### &lt;parse&gt; section

|	   required |  multi |  version	|
|----------|-------|---------|
|	     true | false | 0.14.10	|

`in_tcp` uses parser plugin to parse the payload.

For more details about parser plugin, see followings:

-   [Parser Plugin Overview](/plugins/parser/README.md)
-   [Parse section configurations](/configuration/parse-section.md)


## FAQ


### How to prevent request drop?

If in\_udp gots lots of packets within 1 sec, some packets are dropped.
For example, you can see bigger RcvbufErrors number via `netstat -su`.

This means in\_udp with one process can't handle such traffic. Try
[multi workers](/deployment/performance-tuning.md/#multi-workers).


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
