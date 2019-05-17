# stdout Output Plugin

![](/images/plugins/output/stdout.png)

The `stdout` output plugin prints events to stdout (or logs if launched
with daemon mode). This output plugin is useful for debugging purposes.


## Example Configuration

`out_stdout` is included in Fluentd's core. No additional installation
process is required.

```
<match pattern>
  @type stdout
</match>
```

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file.

A sample output is as follows:

```
2017-11-28 11:43:13.814351757 +0900 tag: {"field1":"value1","field2":"value2"}
```

where the first part shows the output time, the second part shows the
tag, and the third part shows the record.


## Supported modes

-   Non-Buffered
-   Synchronous


## Plugin helpers

-   [inject](/developer/api-plugin-helper-inject.md)
-   [formatter](/developer/api-plugin-helper-formatter.md)
-   [compat\_parameters](/developer/api-plugin-helper-compat_parameters.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

### @type

The value must be `stdout`.

### &lt;buffer&gt; section

See [Buffer section configurations](/configuration/buffer-section.md) for more details.

#### chunk\_keys

| type  | default | version |
|:------|:--------|:--------|
| array | tag     | 0.14.5  |

Overwrite default value in this plugin.

#### flush\_at\_shutdown

| type | default | version |
|:-----|:--------|:--------|
| bool | true    | 0.14.5  |

Overwrite default value in this plugin.

#### chunk\_limit\_size

| type | default | version |
|:-----|:--------|:--------|
| size | 10240   | 0.14.5  |

Overwrite default value in this plugin.


### &lt;format&gt; section

See [Format section configurations](/configuration/format-section.md) for more details.

#### @type

| type   | default | version |
|:-------|:--------|:--------|
| string | stdout  | 0.14.5  |

The format of output.

#### output\_type

| type   | default | version |
|:-------|:--------|:--------|
| string | json    | 0.14.5  |

This is the option of `stdout` format. Configure the format of record
(third part). Any formatter plugins can be specified.

### &lt;inject&gt; section

See [Inject section configurations](/configuration/inject-section) for more details.

------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
