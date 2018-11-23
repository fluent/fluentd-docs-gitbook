# null Output Plugin

The `null` output plugin just throws away events.


## Example Configuration

`out_null` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
<match pattern>
  @type null
</match>
```

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.


## Supported modes

-   Non-Buffered
-   Synchronous
-   Asynchronous

See [Output Plugin Overview](/plugins/output/output-plugin-overview.md) for more details.


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

[]{#@type}

### \@type

The value must be `null`.


### never\_flush

   type   default   version
  ------ --------- ---------
   bool    false    0.14.12

The parameter for testing to simulate output plugin which never succeed
to flush.

[]{#<buffer>-section}

### \<buffer\> section

See [Buffer section configurations](/configuration/buffer-section.md) for more details.

#### chunk\_keys

   type    default   version
  ------- --------- ---------
   array     tag     0.14.5

Overwrite default value in this plugin.

#### flush\_at\_shutdown

   type   default   version
  ------ --------- ---------
   bool    true     0.14.5

Overwrite default value in this plugin.

#### chunk\_limit\_size

   type   default   version
  ------ --------- ---------
   size    10240    0.14.5

Overwrite default value in this plugin.


## Common Buffer / Output parameters

See [Buffer Plugin Overview](/plugins/buffer/buffer-plugin-overview.md) and [Output Plugin Overview](/plugins/output/output-plugin-overview.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
