# Plugin Common Parameters

Some common parameters are available for all (or a part of) Fluentd
plugins. This page describes the list of these parameters.


## Parameters for all plugins

[]{#@type}

### \@type

The parameter `@type` is to specify the type of plugin for the section.

``` {.CodeRay}
<source>
  @type my_plugin_type
</source>

<filter>
  @type my_filter
</filter>
```

[]{#@id}

### \@id

The `@id` parameter is used to add the unique name of plugin
configuration, which is used for paths of buffer/storage, logging and
other purposes.

``` {.CodeRay}
<match>
  @type file
  @id   service_www_accesslog
  path  /path/to/my/access.log
  # ...
</match>
```

This parameter should be specified for all plugins to enable `root_dir`
and `workers` feature globally.

See also: [System Configuration](/articles/system-config.md).

[]{#@log_level}

### \@log\_level

This parameter is to specify plugin-specific logging level. The default
log level is `info`. Global log level can be specified by `log_level` in
`<system>`, or `-v/-q` command line options. The `@log_level` parameter
overwrites logging level only for specified plugin instance.

``` {.CodeRay}
<system>
  log_level info
</system>

<source>
  # ...
  @log_level debug  # show debug log only for this plugin
</source>
```

The main purposes of this parameter are:

-   Suppress too many logs only for that plugin
-   Show debug logs while debugging that plugin

Please see the [logging article](/articles/logging.md) for further details.


Parameters for plugins which emit events
----------------------------------------

[]{#@label}

### \@label

The `@label` parameter is to route input events to `<label>` sections,
the set of `<filter>` and `<match>` sections.

``` {.CodeRay}
<source>
  @type  ...
  @label @access_logs
  # ...
</source>

<source>
  @type  ...
  @label @system_metrics
  # ...
</source>

<label @access_log>
  <match **>
    @type file
    path  ...
  </match>
</label>

<label @system_metrics>
  <match **>
    @type file
    path  ...
  </match>
</label>
```

The values of `@label` parameter MUST start with `@` character.

Specifying `@label` is strongly recommended to route events to any
plugins, without modifying tags. It can make the whole configurations
simple.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
