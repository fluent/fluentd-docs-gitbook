# buffer

The `buffer` output plugin buffers and re-labels events.
This plugin is similar to [out_relabel](relabel.md), but uses [buffer](../buffer/).

It is included in Fluentd's core (since v1.18.0).

## Example Configuration

```
<source>
  @type udp
  @label @buffer
  tag foo.udp
  <parse>
    @type none
  </parse>
</source>

<label @buffer>
  <match **>
    @type buffer
    @label @ROOT
    <buffer>
      path /path/to/buffer
    </buffer>
  </match>
</label>

<match foo.**>
  @type stdout
</match>
```

In the above example, events ingested by `in_udp` are once stored in the buffer of this plugin, then re-routed and output by `out_stdout`.

## Supported Modes

* Synchronous Buffered

See also: [Output Plugin Overview](./)

## Plugin Helpers

* [`event_emitter`](../plugin-helper-overview/api-plugin-helper-event_emitter.md)

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type` \(required\)

The value must be `buffer`.

### `@label` \(required\)

| type   | default | version |
| :---   | :---    | :---    |
| string | `nil`   | 1.18.0  |

Specifies the label to re-route.

Note: You can specify `@ROOT` to re-route to the root.

### `<buffer>` Section

#### `path` \(required\)

| type   | default            | version |
| :---   | :---               | :---    |
| string | required parameter | 1.18.0  |

#### `@type`

| type   | default | version |
| :---   | :---    | :---    |
| string | file    | 1.18.0  |

Overwrites the default value in this plugin.

#### `chunk_keys`

| type  | default | version |
| :---  | :---    | :---    |
| array | tag     | 1.18.0  |

Overwrites the default value in this plugin.

#### `flush_mode`

| type | default  | version |
| :--- | :---     | :---    |
| enum | interval | 1.18.0  |

Overwrites the default value in this plugin.

#### `flush_interval`

| type    | default | version |
| :---    | :---    | :---    |
| integer | 10      | 1.18.0  |

Overwrites the default value in this plugin.

#### Common Buffer / Output parameters

In addition, you can configure other common settings.
Please see the followings for details.

* [Buffer Section Configurations](../configuration/buffer-section.md)
* [Buffer Plugin Overview](../buffer/)
* [Output Plugin Overview](./)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
