# Config File Syntax (YAML)

This article describes the basic concepts of Fluentd configuration file syntax for yaml format.


## Introduction: The Lifecycle of a Fluentd Event

Here is a brief overview of the lifecycle of a Fluentd event to help you understand the rest of this page:

The configuration file allows the user to control the input and output behavior of Fluentd by 1\) selecting input and output plugins; and, 2\) specifying the plugin parameters. The file is required for Fluentd to operate properly.

See also: [Lifecycle of a Fluentd Event](../quickstart/life-of-a-fluentd-event.md)

## YAML adoption

Fluentd starts to support YAML configuration format but this is not 1-by-1 correspondence for Fluentd config file syntax.

Normal Fluentd configuration syntax has the following the list of directives:

1. **`source`** directives determine the input sources
2. **`match`** directives determine the output destinations
3. **`filter`** directives determine the event processing pipelines
4. **`system`** directives set system-wide configuration
5. **`label`** directives group the output and filter for internal routing
6. **`worker`** directives limit to the specific workers
7. **`@include`** directives include other files

In YAML configuration world, we reconstructed them for YAML format.

In YAML syntax, Fluentd will handle the two top level objects:

1. **`system`** The top level object that specifies system settings
2. **`config`** Another top level object that defines data pipeline

Under `config` object, Fluentd will handle the following elements:

1. **`source`** elements determine the input sources
2. **`match`** elements determine the output destinations
3. **`filter`** elements determine the event processing pipelines
4. **`label`** elements group the output and filter for internal routing

### Special YAML elements

1. **`!include`** defines including rules for other files
2. **`!fluent/s`** defines Fluentd string format that is equivalent for double quoted string
3. **`!fluent/json`** defines Fluentd JSON format that is used for Hash type object
4. **`$tag`** defines tag for output plugin
5. **`$label`** defines label routes for input plugin
6. **`$arg`** defines directive **arg**'s equivalent objects (e.g. \<DIRECTIVE **arg**\>)
7. **`$name`** defines label directive **name** equivalent objects (e.g. \<label **name**\>)
8. **`$type`** specifies `@type` or `type` for instantiating plugin type
9. **`$log_level`** specifies `@log_level` per plugin

NOTE: `$log_level` is supported since Fluentd v1.17.1 or v1.16.6. If you want to change log_level per plugin on 1.17.0/v1.16.5 or older versions, you can use `log_level` (without `$`) although it is deprecated.

Let's actually create a configuration file step by step.

## 1. `source`: where all the data come from

Fluentd input sources are enabled by selecting and configuring the desired input plugins using **source** elements. Fluentd standard input plugins include `http` and `forward`. The `http` provides an HTTP endpoint to accept incoming HTTP messages whereas `forward` provides a TCP endpoint to accept TCP packets. Of course, it can be both at the same time. You may add multiple `source` configurations as required.

```yaml
config:
  # Receive events from 24224/tcp
  # This is used by log forwarding and the fluent-cat command
  - source:
      $type: forward
      port: 24224

  # http://<ip>:9880/myapp.access?json={"event":"data"}
  - source:
      $type: http
      port: 9880
```

Each **source** element must include a `$type` object to specify the input plugin to use.

#### Didn't find your input source? You can write your own plugin!

You can add new input sources by writing your own plugins. For further information regarding Fluentd input sources, please refer to the [Input Plugin Overview](../input/) article.

## 2. "match": Tell fluentd what to do!

The **match** element looks for events with **match**ing tags and processes them. The most common use of the `match` element is to output events to other systems. For this reason, the plugins that correspond to the `match` element are called **output plugins**. Fluentd standard output plugins include `file` and `forward`. Let's add those to our configuration file.

```yaml
config:
  # Receive events from 24224/tcp
  # This is used by log forwarding and the fluent-cat command
  - source:
      $type: forward
      port: 24224

  # http://<ip>:9880/myapp.access?json={"event":"data"}
  - source:
      $type: http
      port: 9880

  # Match events tagged with "myapp.access" and
  # store them to /var/log/fluent/access.%Y-%m-%d
  # Of course, you can control how you partition your data
  # with the time_slice_format option.
  - match:
      $tag: myapp.access
      $type: file
      path: /var/log/fluent/access
```

Each `match` element must include a `$tag` and a `$type` parameter. Only events with a `$tag` matching the pattern will be sent to the output destination \(in the above example, only the events with the tag `myapp.access` are matched. See [the section below for more advanced usage](config-file.md#how-do-the-match-patterns-work)\). The `$type` parameter specifies the output plugin to use.

Just like input sources, you can add new output destinations by writing custom plugins. For further information regarding Fluentd output destinations, please refer to the [Output Plugin Overview](../output/) article.

## 3. "filter": Event processing pipeline

The **filter** element has the same syntax as `match` but `filter` could be chained for processing pipeline. Using filters, event flow is like this:

```text
Input -> filter 1 -> ... -> filter N -> Output
```

Let's add standard `record_transformer` filter to `match` example.

```yaml
config:
  # http://this.host:9880/myapp.access?json={"event":"data"}
  - source:
      $type: http
      port: 9880

  - filter:
      $tag: myapp.access
      $type: record_transformer
      record:
        host_param: !fluent/s "#{Socket.gethostname}"

  - match:
      $tag: myapp.access
      $type: file
      path: /var/log/fluent/access
```

The received event `{"event":"data"}` goes to `record_transformer` filter first. The `record_transformer` filter adds `host_param` field to the event; and, then the filtered event `{"event":"data","host_param":"webserver1"}` goes to the `file` output plugin.

You can also add new filters by writing your own plugins. For further information regarding Fluentd filter destinations, please refer to the [Filter Plugin Overview](../filter/) article.

## 4. Set system-wide configuration: the `system` element

System-wide configurations are set by `system` element. Most of them are also available via command line options. For example, the following configurations are available:

* `log_level`
* `suppress_repeated_stacktrace`
* `emit_error_log_interval`
* `suppress_config_dump`
* `without_source`
* `process_name` \(Only available in `system` element. No fluentd option\)

Example:

```yaml
system:
  # equal to -qq option
  log_level: error
  # equal to --without-source option
  without_source:
  # ...
```

See also [System Configuration](../deployment/system-config.md) article for more detail.

### `process_name`

If this parameter is set, fluentd supervisor and worker process names are changed.

```yaml
system:
  process_name: fluentd1
```

With this configuration, `ps` command shows the following result:

```text
% ps aux | grep fluentd1
foo      45673   0.4  0.2  2523252  38620 s001  S+    7:04AM   0:00.44 worker:fluentd1
foo      45647   0.0  0.1  2481260  23700 s001  S+    7:04AM   0:00.40 supervisor:fluentd1
```

This feature requires Ruby 2.1 or later.

## 5. Group filter and output: the "label" element

The **label** element groups filter and output for internal routing. The `label` reduces the complexity of `tag` handling.

The `label` element's parameter is a builtin plugin parameter so `$name` parameter is needed.

Here is a configuration example:

```yaml
config:
  - source:
      $type: forward

  - source:
      $type: tail
      $label: '@SYSTEM'

  - filter:
      $tag: access.**
      $type: record_transformer
      record:
        # ...
  - match:
      $tag: '**'
      $type: elasticsearch
      # ...

  - label:
      $name: '@SYSTEM'
      config:
        - filter:
           $tag: var.log.middleware.**
           $type: grep
           # ...
        - match:
            $tag: '**'
            $type: s3
            # ...
```

Note that `$label` parameter value should be quoted and `label` element should contain `config` element within its elements.

In this configuration, `forward` events are routed to `record_transformer` filter / `elasticsearch` output and `in_tail` events are routed to `grep` filter / `s3` output inside `@SYSTEM` label.

The `$label` parameter is useful for event flow separation without the `$tag` route rules.

### `@ERROR` label

The `@ERROR` label is a builtin label used for error record emitted by plugin's `emit_error_event` API.

If `$label` with  `$name: '@ERROR'` is set, the events are routed to this label when the related errors are emitted e.g. the buffer is full or the record is invalid.

### `@ROOT` label

The `@ROOT` label is a builtin label used for getting root router by plugin's `event_emitter_router` API.

This label is introduced since v1.14.0 to assign a label back to the default route. For example, timed-out event records are handled by the concat filter can be sent to the default route.

## 6. Limit to specific workers: the `worker` element

When setting up multiple workers, you can use the **worker** element to limit plugins to run on specific workers.

This is useful for input and output plugins that do not support multiple workers.

You can use the `$arg N` or `$arg N-M` to specify workers. The number is a zero-based worker index.

See [Multi Process Workers](../deployment/multi-process-workers.md) article for details about multiple workers.

Here is a configuration example:

```yaml
system:
  workers: 4

config:
  - source:
      $type: sample
      tag: test.allworkers
      sample: "{\"message\": \"Run with all workers.\"}"

  - worker:
      $arg: 0
      config:
        - source:
            $type: sample
            tag: test.oneworker
            sample: "{\"message\": \"Run with only worker-0.\"}"

  - worker:
      $arg: 0-1
      config:
        - source:
            $type: sample
            tag: test.someworkers
            sample: "{\"message\": \"Run with worker-0 and worker-1.\"}"

  - filter:
      $type: record_transformer
      $tag: test.**
      record:
        worker_id: !fluent/s "#{worker_id}"

  - match:
      $type: stdout
      $tag: test.**
```

The outputs of this config are as follows:

```text
... test.allworkers: {"message":"Run with all workers.","worker_id":"0"}
... test.allworkers: {"message":"Run with all workers.","worker_id":"1"}
... test.allworkers: {"message":"Run with all workers.","worker_id":"2"}
... test.allworkers: {"message":"Run with all workers.","worker_id":"3"}
... test.oneworker: {"message":"Run with only worker-0.","worker_id":"0"}
... test.someworkers: {"message":"Run with worker-0 and worker-1.","worker_id":"0"}
... test.someworkers: {"message":"Run with worker-0 and worker-1.","worker_id":"1"}
```

## 7. Reuse your config: the `!include` YAML tag

The element in separate configuration files can be imported using the **!include** element:

```yaml
config:
  # Include config files in the ./config.d directory
  - !include config.d/*.conf
```

The `!include` YAML tag supports regular file path, glob pattern, and http URL conventions:

```yaml
config:
  # absolute path
  - !include /path/to/config.conf

  # if using a relative path, the YAML tag will use
  # the dirname of this config file to expand the path
  - !include extra.conf

  # glob match pattern
  - !include config.d/*.conf

  # http
  - !include http://example.com/fluent.conf
```


Note that for the glob pattern, files are expanded in alphabetical order. If there are `a.conf` and `b.conf` then fluentd parses `a.conf` first. But, you should not write the configuration that depends on this order. It is so error-prone, therefore, use multiple separate `!include` YAML tags for safety.

```yaml
config:
  # If you have a.conf, b.conf, ..., z.conf and a.conf / z.conf are important

  # This is bad
  - !include *.conf

  # This is good
  - !include a.conf
  - !include config.d/*.conf
  - !include z.conf
```

### Share the Same Parameters

The `!include` YAML tag can be used under sections to share the same parameters:

```yaml
# config file
config:
  - match:
      $type: forward
      # ...
      buffer:
        $type: file
        path: /path/to/buffer/forward
        <<: !include /path/to/out_buf_params.yaml

  - match:
      $type: elasticsearch
      # ...
      buffer:
        $type: file
        path: /path/to/buffer/es
        <<: !include /path/to/out_buf_params.yaml

# /path/to/out_buf_params.yaml
flush_interval:    5s
total_limit_size:  100m
chunk_limit_size:  1m
```

Note that, in the middle of element case of `!include` YAML tag usage, users must use `<<:` syntax to include other YAML objects successfully.

### Note on Match Order

Fluentd tries to match tags in the order that they appear in the config file. So, if you have the following configuration:

```yaml
config:
  # '**' matches all tags. Bad :(
  - match:
     $tag: '**'
     $type: blackhole_plugin

  - match:
      $tag: myapp.access
      $type: file
      path: /var/log/fluent/access
```

then `myapp.access` is never matched. Wider match patterns should be defined after tight match patterns.

```yaml
config:
  - match:
      $tag: myapp.access
      $type: file
      path: /var/log/fluent/access

  # Capture all unmatched tags. Good :)
  - match:
      $tag: '**'
      $type: blackhole_plugin
```

Of course, if you use two same patterns, the second `match` is never matched. If you want to send events to multiple outputs, consider [`out_copy`](../output/copy.md) plugin.

The common pitfall is when you put a `filter` element after `match` element. It will never work since events never go through the filter for the reason explained above.

```yaml
config:
  # You should NOT put this <filter> block after the <match> block below.
  # If you do, Fluentd will just emit events without applying the filter.

  - filter:
      $tag: myapp.access
      $type: record_transformer
      ...

  - match:
      $tag: myapp.access
      $type: file
      path: /var/log/fluent/access
```

### Embedding Ruby Expressions

When using YAML format syntax in Fluentd configuration, you can use `!fluent/s "#{...}"` to embed arbitrary Ruby code into match patterns. Here is an example:

```yaml
config:
  - match:
      $tag: fluent/s "app.#{ENV['FLUENTD_TAG']}"
      $type: stdout
```

If you set the environment variable `FLUENTD_TAG` to `dev`, this evaluates to `app.dev`.

## Supported Data Types for Values

Please refer to: [Supported Data Types for Values | Fluentd official document](./config-file#supported-data-types-for-values)

## Common Plugin Parameters

Please refer to: [Common Plugin Parameters | Fluentd official document](./config-file#common-plugin-parameters)

## Check Configuration File

The configuration file can be validated without starting the plugins using the `--dry-run` option:

```text
$ fluentd --dry-run -c fluent.yaml
```

## Format Tips

This section describes some useful features for the configuration file.

### Multiline support for " quoted string, array and hash values

You can write multiline values for `"` quoted string, array and hash values.

```yaml
str_param: "foo  # Converts to "foo bar". As NL interpretation will be required for continuous newlines.
bar"

str_param: "foo  # Converts to "foo\nbar".

bar"

array_param:
  - "a"
  - "b"

hash_param: !fluent/json {
  "k": "v",
  "k1": 10
}
```

Fluentd assumes `[` or `{` is a start of array / hash. So, if you want to set `[` or `{` started but non-JSON parameter, please use `'` or `"`.

Example \# 1: mail plugin

```yaml
config:
  - match:
      $tag: '**'
      $type: mail
      subject: "[CRITICAL] foo's alert system"
```

Example \# 2: map plugin

```yaml
config:
  - match:
      $tag:tag
      $type: map
      map: '[["code." + tag, time, { "code" => record["code"].to_i}], ["time." + tag, time, { "time" => record["time"].to_i}]]'
      multi: true
```

This restriction will be removed with the configuration parser improvement.


### Embedded Ruby Code

You can evaluate the Ruby code with `!fluent/s #{}` in `"` quoted string. This is useful for setting machine information e.g. hostname.

```yaml
host_param:  !fluent/s "#{Socket.gethostname}" # host_param is actual hostname like `webserver1`.
env_param:  !fluent/s  "foo-#{ENV['FOO_BAR']}" # NOTE that foo-"#{ENV["FOO_BAR"]}" doesn't work.
```

In YAML config format, `hostname` and `worker_id` shortcuts are also available:

```yaml
host_param: !fluent/s "#{hostname}"  # This is same with Socket.gethostname
$id:        !fluent/s "out_foo#{worker_id}" # This is same with ENV["SERVERENGINE_WORKER_ID"]
```

The `worker_id` shortcut is useful under multiple workers. For example, for a separate plugin id, add `worker_id` to store the path in s3 to avoid file conflict.

Helper methods `use_nil` and `use_default` are available:

```yaml
some_param:  !fluent/s "#{ENV['FOOBAR'] || use_nil}"     # Replace with nil if ENV["FOOBAR"] isn't set
some_param:  !fluent/s "#{ENV['FOOBAR'] || use_default}" # Replace with the default value if ENV["FOOBAR"] isn't set
```

Note that these methods not only replace the embedded Ruby code but the entire string with `nil` or a default value.

```yaml
some_path: !fluent/s "#{use_nil}/some/path" # some_path is nil, not "/some/path"
```

### In double-quoted string literal, `\` is the escape character

The backslash `\` is interpreted as an escape character. You need `\` for setting `"`, `\r`, `\n`, `\t`, `\` or several characters in double-quoted string literal.

```yaml
str_param:   "foo\nbar" # \n is interpreted as actual LF character
```

### Parse setting

You can use `parse:` to set up the parser for the input plugin.

Example: in_tail plugin

```yaml
config:
  - source:
      $type: tail
      tag: sample
      path: /tmp/test.log
      pos_file: /tmp/tail-test.pos
      parse: 
        $type: none
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
