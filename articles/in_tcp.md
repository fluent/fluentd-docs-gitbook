# TCP Input Plugin

The `in_tcp` Input plugin enables Fluentd to accept TCP payload.

Don't use this plugin for receiving logs from client libraries. Use
`in_forward` for such cases.


## Example Configuration

`in_tcp` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<source>
  @type tcp
  tag tcp.events # required
  <parse>
    @type regexp
    expression /^(?<field1>\d+):(?<field2>\w+)$/
  </parse>
  port 20001   # optional. 5170 by default
  bind 0.0.0.0 # optional. 0.0.0.0 by default
  delimiter \n # optional. \n (newline) by default
</source>
```

Example input:

``` {.CodeRay}
$ echo '123456:awesome' | netcat 0.0.0.0 5170
```

Parsed result like below:

``` {.CodeRay}
{"field1":"123456","field2":"awesome}
```

Please see the [Config File](/articles/config-file.md) article for the basic
structure and syntax of the configuration file. For \<parse\> section,
please check [Parse section cofiguration](/articles/parse-section.md).

We\'ve observed the drastic performance improvements on Linux, with
proper kernel parameter settings. If you have high-volume TCP traffic,
please make sure to follow the instruction described at [Before Installing Fluentd](/articles/before-install.md).


## Plugin helpers

-   [server](/articles/api-plugin-helper-server.md)
-   [parser](/articles/api-plugin-helper-parser.md)
-   [extract](/articles/api-plugin-helper-extract.md)
-   [compat\_parameters](/articles/api-plugin-helper-compat_parameters.md)


## Parameters

[Common Parameters](/articles/plugin-common-parameters.md)

[]{#@type}

### \@type

The value must be `tcp`.


### tag

    type         default         version
  -------- -------------------- ---------
   string   required parameter   0.14.0

tag of output events.


### port

    type     default   version
  --------- --------- ---------
   integer    5170     0.14.0

The port to listen to.


### bind

    type            default           version
  -------- ------------------------- ---------
   string   0.0.0.0 (all addresses)   0.14.0

The bind address to listen to.


### source\_hostname\_key

    type            default            version
  -------- -------------------------- ---------
   string   nil (no adding hostname)   0.14.10

The field name of the client's hostname. If set the value, the client's
hostname will be set to its key. The default is nil (no adding
hostname).

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

[]{#<parse>-section}

### \<parse\> section

   required   multi   version
  ---------- ------- ---------
     true     false   0.14.10

`in_tcp` uses parser plugin to parse the payload.

For more details about parser plugin, see followings:

-   [Parser Plugin Overview](/articles/parser-plugin-overview.md)
-   [Parse section configurations](/articles/parse-section.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
