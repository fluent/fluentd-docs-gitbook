# Config: Common Parameters

Some common parameters are available for all or some of the Fluentd plugins. This page describes these parameters.

## Parameters for all the Plugins

### `@type`

The `@type` parameter specifies the type of the plugin.

```text
<source>
  @type my_plugin_type
</source>

<filter>
  @type my_filter
</filter>
```

### `@id`

The `@id` parameter specifies a unique name for the configuration. It is used as paths for buffer, storage, logging and for other purposes.

```text
<match>
  @type file
  @id service_www_accesslog
  path /path/to/my/access.log
  # ...
</match>
```

This parameter should be specified for all the plugins to enable `root_dir` feature globally.

See also: [System Configuration](../deployment/system-config.md)

### `@log_level`

This parameter specifies the plugin-specific logging level. The default log level is `info`. Global log level can be specified by setting `log_level` in `<system>` section or with `-v/-q` command line arguments. The `@log_level` parameter overrides the logging level only for the specified plugin instance.

```text
<system>
  log_level info
</system>

<source>
  # ...
  @log_level debug # shows debug log only for this plugin
</source>
```

The main purposes of this parameter are:

1. to suppress too many logs for that plugin; and,
2. to show the debug logs to help in the debugging process.

Please see the [logging article](../deployment/logging.md) for further details.

## Plugin Parameters that Emit Events

### @label

The `@label` parameter is to route the input events to `<label>` sections, the set of the `<filter>` and `<match>` subsections under `<label>`.

```text
<source>
  @type ...
  @label @access_logs
  # ...
</source>

<source>
  @type ...
  @label @system_metrics
  # ...
</source>

<label @access_logs>
  <match **>
    @type file
    path ...
  </match>
</label>

<label @system_metrics>
  <match **>
    @type file
    path ...
  </match>
</label>
```

NOTE: The values for the `@label` parameter MUST start with `@` character.

Specifying `@label` is strongly recommended to route events to any plugin without modifying the tags. It helps make the complex configuration modular and simple.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

