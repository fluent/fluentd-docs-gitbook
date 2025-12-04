# exec\_filter

![](../.gitbook/assets/exec_filter.png)

The `out_exec_filter` Buffered Output plugin 1\) executes an external program using an event as input; and, 2\) reads a new event from the program output.

By default, it passes tab-separated values \(TSV\) to the standard input and reads TSV from the standard output.

It is included in Fluentd's core.

## Example Configuration

```text
<match pattern>
  @type exec_filter
  command cmd arg arg
  <format>
    @type tsv
    keys k1,k2,k3
  </format>
  <parse>
    @type tsv
    keys k1,k2,k3,k4
  </parse>
  <inject>
    tag_key k1
    time_key k2
    time_format %Y-%m-%d %H:%M:%S
  </inject>
</match>
```

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

When using the JSON format in `<parse>` section, this plugin uses the `Yajl` library to parse the program output. `Yajl` buffers data internally so the output is not always instantaneous.

If the buffering by `Yajl` parser is problematic for you even though you expect instantaneous response, you can tweak [`stream_buffer_size`](../parser/json.md) parameter in `<parse>` section.

## Supported Modes

* Synchronous
* See also: [Output Plugin Overview](./)

## Plugin Helpers

* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)
* [`inject`](../plugin-helper-overview/api-plugin-helper-inject.md)
* [`formatter`](../plugin-helper-overview/api-plugin-helper-formatter.md)
* [`parser`](../plugin-helper-overview/api-plugin-helper-parser.md)
* [`extract`](../plugin-helper-overview/api-plugin-helper-extract.md)
* [`child_process`](../plugin-helper-overview/api-plugin-helper-child_process.md)
* [`event_emitter`](../plugin-helper-overview/api-plugin-helper-event_emitter.md)

## Parameters

### `@type`

The value must be `exec_filter`.

### `command`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.0 |

The command \(program\) to execute. The `out_exec_filter` plugin passes the incoming event to the program input and receives the filtered event from the program output.

### `num_children`

| type | default | version |
| :--- | :--- | :--- |
| integer | 1 | 0.14.0 |

The number of spawned processes for `command`.

If the number is larger than 2, fluentd uses spawned processes by round robin fashion.

### `child_respawn`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.0 |

Respawn command when the command exits. By default, it is disabled.

If you specify a positive number, it tries to respawn until specified times. If you specify `inf` or `-1`, it tries to respawn forever.

### `tag`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.0 |

The tag of the event.

### `read_block_size`

| type | default | version |
| :--- | :--- | :--- |
| size | 10240 | 0.14.9 |

The default block size to read if parser requires partial read.

### `suppress_error_log_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | 0 | 0.14.0 |

Suppress error logs during this interval.

By default, all the logs are emitted.

### `in_format`

**This parameter is deprecated.** Use `<format>` section.

The format used to map the incoming event to the program input.

### `out_format`

**This parameter is deprecated.** Use `<parse>` section.

The format used to process the program output.

### `<format>` Section

The format used to map the incoming events to the program input.

See [Format Section Configurations](../configuration/format-section.md) for more details.

#### `@type`

| type | default | version |
| :--- | :--- | :--- |
| string | tsv | 0.14.9 |

Overwrites the default value in this plugin.

### `<parse>` Section

The format used to process the program output.

See [Parse Section Configurations](../configuration/parse-section.md) for more details.

#### `@type`

| type | default | version |
| :--- | :--- | :--- |
| string | tsv | 0.14.9 |

Overwrites the default value in this plugin.

#### `time_key`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.9 |

Overwrites the default value in this plugin.

#### `time_format`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.9 |

Overwrites the default value in this plugin.

#### `localtime`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.9 |

Overwrites the default value in this plugin.

### `<inject>` Section

See [Inject Section Configurations](../configuration/inject-section.md) for more details.

#### `time_type`

| type | default | version |
| :--- | :--- | :--- |
| enum | float | 0.14.9 |

Overwrites the default value in this plugin.

### `<extract>` Section

See [Extract Section Configurations](../configuration/extract-section.md) for more details.

#### `time_type`

| type | default | version |
| :--- | :--- | :--- |
| enum | float | 0.14.9 |

Overwrite default value in this plugin.

### `<buffer>` Section

See [Buffer Section Configurations](../configuration/buffer-section.md) for more details.

#### `flush_mode`

| type | default | version |
| :--- | :--- | :--- |
| enum | interval | 0.14.9 |

Overwrites the default value in this plugin.

#### `flush_interval`

| type | default | version |
| :--- | :--- | :--- |
| integer | 1 | 0.14.9 |

Overwrites the default value in this plugin.

## Script Example

Here is an example written in Ruby:

```text
require 'json'
require 'msgpack'

begin
  while line = STDIN.gets # continue to read a event from stdin
    line.chomp!

    # Input format depends on exec_filter's in_format setting
    json = JSON.parse(line)

    # main processing. You can do anything, mutate record, access to database and etc.
    json['new_field'] = "Hey from exec_filter script!"

    # Write data to stdout. Output format depends on exec_filter's out_format setting
    STDOUT.print MessagePack.pack(json)

    # Call flush to avoid buffering events
    STDOUT.flush
  end
rescue Interrupt # Ignore Interrupt exception because it happens during exec_filter shutdown
end
```

Corresponding configuration:

```text
<match test.**>
  @type exec_filter
  command ruby /path/to/ruby_script.rb
  tag filtered.exec
  <format>
    @type json
  </format>
  <parse>
    @type msgpack
  </parse>
  <buffer>
    flush_interval 10s
  </buffer>
</match>
```

You may convert this script into your preferred language accordingly.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

