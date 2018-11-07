# stdout Filter Plugin

The `filter_stdout` filter plugin prints events to stdout (or logs if
launched with daemon mode). This filter plugin is useful for debugging
purposes.


## Example Configurations

`filter_stdout` is included in Fluentd's core. No installation required.

``` {.CodeRay}
<filter pattern>
  @type stdout
</filter>
```

A sample output is as follows:

``` {.CodeRay}
2017-11-28 11:43:13.814351757 +0900 tag: {"field1":"value1","field2":"value2"}
```

where the first part shows the output time, the second part shows the
tag, and the third part shows the record.


## Plugin helpers

-   [formatter](/articles/api-plugin-helper-formatter.md)
-   [compat\_parameters](/articles/api-plugin-helper-compat_parameters.md)
-   [inject](/articles/api-plugin-helper-inject.md)


## Parameters

[Common Parameters](/articles/plugin-common-parameters.md)

[]{#@type-(required)}

### \@type (required)

The value must be `stdout`.

[]{#<format>-section}

### \<format\> section

See [Format section configurations](/articles/format-section.md) for more details.

#### \@type

    type    default   version
  -------- --------- ---------
   string   stdout    0.14.5

The format of output.

#### output\_type

    type    default   version
  -------- --------- ---------
   string    json     0.14.5

This is the option of `stdout` format. Configure the format of record
(third part). Any formatter plugins can be specified.


## Learn More

-   [Filter Plugin Overview](/articles/filter-plugin-overview.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
