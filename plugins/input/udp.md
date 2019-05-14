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
follow the instruction described at [Before Installing Fluentd](/install/before-install.md).


## Plugin helpers

-   [server](/developer/api-plugin-helper-server.md)
-   [parser](/developer/api-plugin-helper-parser.md)
-   [extract](/developer/api-plugin-helper-extract.md)
-   [compat\_parameters](/developer/api-plugin-helper-compat_parameters.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

### @type

The value must be `udp`.


### tag

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.0  |

tag of output events.


### port

| type    | default | version |
|:--------|:--------|:--------|
| integer | 5160    | 0.14.0  |

The port to listen to. Default Value = 5160


### bind

| type   | default                 | version |
|:-------|:------------------------|:--------|
| string | 0.0.0.0 (all addresses) | 0.14.0  |

The bind address to listen to.


### source\_hostname\_key

| type   | default                  | version |
|:-------|:-------------------------|:--------|
| string | nil (no adding hostname) | 0.14.10 |

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

### source\_address\_key

| type   | default                        | version |
|:------:|:------------------------------:|:-------:|
| string | nil (no adding source address) | 1.4.2   |

The field name for the client's IP address. If you set this option,
Fluentd automatically adds the remote address to each data record.

For example, if you have the following configuration:

    <source>
      @type udp
      source_address_key client_addr
      ...
    </source>

you will get something like below:

    :::text
    {
        ...
        "client_addr": "192.168.10.10"
        ...
    }


### message\_length\_limit

| type | default | version |
|:-----|:--------|:--------|
| size | 4096    | 0.14.14 |

The max bytes of message


### remove\_newline

| type | default | version |
|:-----|:--------|:--------|
| bool | true    | 0.14.23 |

Remove newline from the end of incoming payload


### &lt;parse&gt; section

| required | multi | version |
|:---------|:------|:--------|
| true     | false | 0.14.10 |

`in_tcp` uses parser plugin to parse the payload.

For more details about parser plugin, see followings:

-   [Parser Plugin Overview](/plugins/parser/README.md)
-   [Parse section configurations](/configuration/parse-section.md)


## Code example

Here is ruby example to send event to `in_udp`.

```
require 'socket'

us = UDPSocket.open
sa = Socket.pack_sockaddr_in(5160, '127.0.0.1')

# This example uses json payload.
# In in_udp configuration, need to configure "@type json" in "<parse>"
us.send('{"k":"v1"}', 0, sa)
us.send('{"k":"v2"}', 0, sa)
us.close
```


## FAQ


### How to prevent request drop?

If in\_udp gots lots of packets within 1 sec, some packets are dropped.
For example, you can see bigger RcvbufErrors number via `netstat -su`.

This means in\_udp with one process can't handle such traffic. Try
[multi workers](/deployment/multi-process-workers.md).


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
