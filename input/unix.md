# unix

The `in_unix` Input plugin enables Fluentd to retrieve records from the Unix Domain Socket. The wire protocol is the same as [`in_forward`](forward.md), but the transport layer is different.

It is included in Fluentd's core.

## Example Configuration

```text
<source>
  @type unix
  path /path/to/socket.sock
</source>
```

Refer to the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

## Parameters

### `@type` \(required\)

The value must be `unix`.

### `path`

| type | default | version |
| :---: | :---: | :---: |
| string | `/var/run/fluent/fluent.sock` \(see below\) | 0.14.0 |

The path to your Unix Domain Socket.

Fluentd will use the environment variable `FLUENT_SOCKET` if defined.

### `backlog`

| type | default | version |
| :---: | :---: | :---: |
| integer | 1024 | 0.14.0 |

The backlog of Unix Domain Socket.

### `tag`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.11.0 |

`in_unix` uses incoming event's tag by default. If the `tag` parameter is set, its value is used instead.

{% include "../.gitbook/assets/footer.txt" %}
