# tail

![](../.gitbook/assets/tail.png)

The `in_tail` Input plugin allows Fluentd to read events from the tail of text files. Its behavior is similar to the `tail -F` command.

It is included in Fluentd's core.

## Example Configuration

```text
<source>
  @type tail
  path /var/log/httpd-access.log
  pos_file /var/log/td-agent/httpd-access.log.pos
  tag apache.access
  <parse>
    @type apache2
  </parse>
</source>
```

Refer to the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

For `<parse>`, see [Parse Section](../configuration/parse-section.md).

### How It Works

When Fluentd is first configured with `in_tail`, it will start reading from the **tail** of that log, not the beginning. Once the log is rotated, Fluentd starts reading the new file from the beginning. It keeps track of the current inode number.

If `td-agent` restarts, it resumes reading from the last position before the restart. This position is recorded in the position file specified by the `pos_file` parameter.

### Linux Capability

Since v1.12.0, `in_tail` handles the following Linux capabilities if Fluentd's Linux capability handling module is enabled:

* `CAP_DAC_READ_SEARCH` \(`:dac_read_search` on `in_tail` code.\)
* `CAP_DAC_OVERRIDE` \(`:dac_override` on `in_tail` code.\)

## Plugin Helpers

* [`timer`](../plugin-helper-overview/api-plugin-helper-timer.md)
* [`event_loop`](../plugin-helper-overview/api-plugin-helper-event_loop.md)
* [`parser`](../plugin-helper-overview/api-plugin-helper-parser.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)

See also: [Linux capability](../deployment/linux-capability.md)

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

### `@type` \(required\)

The value must be `tail`.

### `tag`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.0 |

The tag of the event.

`*` can be used as a placeholder that expands to the actual file path, replacing `'/'` with `'.'`.

With the following configuration:

```text
path /path/to/file
tag foo.*
```

`in_tail` emits the parsed events with the `foo.path.to.file` tag.

### `path`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 0.14.0 |

The path\(s\) to read. Multiple paths can be specified, separated by comma `','`.

`*` and `strftime` format can be included to add/remove the watch file dynamically. At the interval of `refresh_interval`, Fluentd refreshes the list of watch files.

```text
path /path/to/%Y/%m/%d/*
```

For multiple paths:

```text
path /path/to/a/*,/path/to/b/c.log
```

If the date is `20140401`, Fluentd starts to watch the files in `/path/to/2014/04/01` directory. See also `read_from_head` parameter.

By default, You should not use `*` with log rotation because it may cause the log duplication. To avoid log duplication, you need to set `follow_inodes true` in the configuration.

If you want to use other glob patterns such as `[]` and `?`, you need to set up `glob_policy extended` as described in the `glob_policy` section.

### `path_timezone`

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 1.8.1 |

This parameter is for `strftime` formatted path like `/path/to/%Y/%m/%d/`.

`in_tail` uses system timezone by default. This parameter overrides it:

```text
path_timezone "+00"
```

For timezone format, see [Timezone Section](../configuration/format-section.md#time-parameters).

### `glob_policy`

| type | default | available values | version |
| :--- | :--- | :--- |:--- |
| enum | backward\_compatible | backward\_compatible/extended/always | 1.17.0 |

This parameter permits to extend glob patterns on `path` and `exclude_path` parameters.
When specifying `extended`, users can use `[]` and `?` in glob patterns.
When specifying `always`, users can use `[]`, `?`, and additionally `{}` in glob patterns.

However, `always` option is not able to use with the default value of `path_delimiter`.
When using the default value of `path_delimiter`, it will be marked as `Fluent::ConfigError`.

### `exclude_path`

| type | default | version |
| :--- | :--- | :--- |
| array | `[]` \(empty\) | 0.14.0 |

The paths excluded from the watcher list.

For example, to remove the compressed files, you can use the following pattern:

```text
path /path/to/*
exclude_path ["/path/to/*.gz", "/path/to/*.zip"]
```

`exclude_path` takes input as an array, unlike `path` which takes as a string.

### `follow_inodes`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 1.12.0 |

Avoid to read rotated files duplicately. You should set `true` when you use `*` or  `strftime` format in `path`.

```text
path /path/to/*
read_from_head true
follow_inodes true  # Without this parameter, file rotation causes log duplication.
```

### `refresh_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | 60 \(seconds\) | 0.14.0 |

The interval to refresh the list of watch files. This is used when the path includes `*`.

### `limit_recently_modified`

| type | default | version |
| :--- | :--- | :--- |
| time | nil \(disabled\) | 0.14.13 |

Limits the watching files that the modification time is within the specified time range when using `*` in `path`.

### `skip_refresh_on_startup`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.13 |

Skips the refresh of the watch list on startup. This reduces the startup time when `*` is used in `path`.

### `read_from_head`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

Starts to read the logs from the head of the file or the last read position recorded in `pos_file`, not tail.

Notes:

* `in_tail` tries to read a file during the startup phase when this is `true`. So that if the target file is too large and takes a long time to read it, other plugins are blocked to start until the reading is finished. You can avoid it by `skip_refresh_on_startup`.
* **For Fluentd <= v1.14.2**: If you use `*` or `strftime` format as `path` and new files may be added into such paths while tailing, you should set this parameter to `true`. Otherwise some logs in newly added files may be lost. On the other hand you should guarantee that the log rotation will not occur in `*` directory in that case to avoid log duplication. Or you can use `follow_inodes true` to avoid such log duplication, which is available as of v1.12.0.
  * From Fluentd v1.14.3, `in_tail` reads newly added files from head automatically even if `read_from_head` is `false`. `read_from_head false` is affected only on start up.

### `encoding`, `from_encoding`

| type | default | version |
| :--- | :--- | :--- |
| string | nil \(string encoding is `ASCII-8BIT`\) | 0.14.0 |

Specifies the encoding of reading lines.

By default, `in_tail` emits string value as ASCII-8BIT encoding.

These options change it:

* If `encoding` is specified, `in_tail` changes string to `encoding`.

  This uses Ruby's [`String#force_encoding`](https://docs.ruby-lang.org/en/trunk/String.html#method-i-force_encoding).

* If `encoding` and `from_encoding` both are specified, `in_tail` tries to

  encode string from `from_encoding` to `encoding`. This uses Ruby's

  [`String#encode`](https://docs.ruby-lang.org/en/trunk/String.html#method-i-encode).

You can get the list of supported encodings with this command:

```text
$ ruby -e 'p Encoding.name_list.sort'
```

### `read_lines_limit`

| type | default | version |
| :--- | :--- | :--- |
| integer | 1000 | 0.14.0 |

The number of lines to read with each I/O operation.

If you see `chunk bytes limit exceeds for an emitted event stream` or similar log with `in_tail`, set a smaller value.

### `read_bytes_limit_per_second`

| type | default | version |
| :--- | :--- | :--- |
| size | -1 \(unlimited\) | 1.13.0 |

The number of reading bytes per second to read with I/O operation.

This value should be equal or greater than 8192.

If you work with a big cluster with high volume of log, you can use this parameter to avoid network saturation and make it easier to calculate the max throughput per node. To restrict shipping log volumes per second, set a positive number.

### `max_line_size`

| type | default | version |
| :--- | :--- | :--- |
| size | nil | 1.14.4 |

The maximum length of a line. Longer lines than it will be just skipped.

If you see `BufferChunkOverflowError` exception frequently, it means that incoming data is too long.
If such a long line is unexpected incoming data and want to ignore it, then set a smaller value than `chunk_limit_size` in `<buffer>` section.

### `multiline_flush_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | nil \(disabled\) | 0.14.0 |

The interval of flushing the buffer for multiline format.

If you set `multiline_flush_interval 5s`, `in_tail` flushes buffered event after 5 seconds from last emit. This option is useful when you use `format_firstline` option.

### `pos_file` \(highly recommended\)

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.14.0 |

Fluentd will record the position it last read from this file:

```text
pos_file /var/log/td-agent/tmp/access.log.pos
```

`pos_file` handles multiple positions in one file so no need to have multiple `pos_file` parameters per `source`.

Don't share `pos_file` between `in_tail` configurations. It causes unexpected behavior e.g. corrupt `pos_file` content.

`in_tail` removes the untracked file position at startup.
It means that the content of `pos_file` keeps growing until a restart when you tail
lots of files with the dynamic path setting.
This issue can be solved by using `pos_file_compaction_interval`.

### `pos_file_compaction_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | nil | 1.9.2 |

The interval of doing compaction of pos file.

The targets of compaction are unwatched, unparsable, and the duplicated line. You can use this value when `pos_file` option is set:

```text
pos_file /var/log/td-agent/tmp/access.log.pos
pos_file_compaction_interval 72h
```

### `<parse>` Directive \(required\)

The format of the log.

`in_tail` uses the parser plugin to parse the log. See [`parser`](../parser/) for more detail.

Examples:

```text
# json
<parse>
  @type json
</parse>

# regexp
<parse>
  @type regexp
  expression ^(?<name>[^ ]*) (?<user>[^ ]*) (?<age>\d*)$
</parse>
```

If `@type` contains `multiline`, `in_tail` works in multiline mode.

### `format`

Deprecated parameter. Use `<parse>` instead.

### `path_key`

| type | default | version |
| :--- | :--- | :--- |
| string | nil \(no assign\) | 0.14.0 |

Adds the watching file path to the `path_key` field.

With this configuration:

```text
path /path/to/access.log
path_key tailed_path
```

The generated events are like this:

```text
{"tailed_path":"/path/to/access.log","k1":"v1",...,"kN":"vN"}
```

### `rotate_wait`

| type | default | version |
| :--- | :--- | :--- |
| time | 5 \(seconds\) | 0.14.0 |

`in_tail` actually does a bit more than `tail -F` itself. When rotating a file, some data may still need to be written to the old file as opposed to the new one.

`in_tail` takes care of this by keeping a reference to the old file \(even after it has been rotated\) for some time before transitioning completely to the new file. This helps prevent data designated for the old file from getting lost. By default, this time interval is 5 seconds.

The `rotate_wait` parameter accepts a single integer representing the number of seconds you want this time interval to be.

### `enable_watch_timer`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 0.14.0 |

Enables the additional watch timer. Setting this parameter to `false` will significantly reduce CPU and I/O consumption when tailing a large number of files on systems with `inotify` support. The default is `true` which results in an additional 1 second timer being used.

`in_tail` \(via `Cool.io`\) uses `inotify` on systems which support it. Earlier versions of `libev` on some platforms \(e.g. macOS\) did not work properly; therefore, an explicit 1 second timer was used. Even on systems with `inotify` support, this results in additional I/O each second, for every file being tailed.

Early testing demonstrates that modern `Cool.io` and `in_tail` work properly without the additional watch timer. In the future, depending on the feedback and testing, the additional watch timer may be disabled by default.

### `enable_stat_watcher`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 1.0.1 |

Enables the additional `inotify`-based watcher. Setting this parameter to `false` will disable the `inotify` events and use only timer watcher for file tailing.

This option is mainly for avoiding the stuck issue with `inotify`.

### `open_on_every_update`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.12 |

Opens and closes the file on every update instead of leaving it open until it gets rotated.

### `emit_unmatched_lines`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.12 |

Emits unmatched lines when `<parse>` format is not matched for incoming logs.

Emitted record is `{"unmatched_line" : incoming line}`, e.g. `{"unmatched_line" : "Non JSON format!"}`.

### `ignore_repeated_permission_error`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.0 |

If you have to exclude the non-permission files from the watch list, set this parameter to `true`. It suppresses the repeated permission error logs.

#### `@log_level`

The `@log_level` option allows the user to set different levels of logging for each plugin. The supported log levels are: `fatal`, `error`, `warn`, `info`, `debug`, and `trace`.

Refer to the [Logging](../deployment/logging.md) for more details.


### `<group>` Section

The `in_tail` plugin can assign each log file to a group, based on user defined rules. The `limit` parameter controls the total number of lines collected for a group within a `rate_period` time interval.

Example: 

```text
# group rules -- 1
<group>
  rate_period 5s

  <rule>
    match {
        "namespace": "/shopping/",
        "podname": "/frontend/",
    }
    limit 1000
  </rule>
</group>

# group rules -- 2
<group>
  <rule>
    match {
        directoy: /payment/
    }
    limit 2000
  </rule>
</group>
```

#### `pattern`

| type | default | version |
| :--- | :--- | :--- |
| regexp | `/^\/var\/log\/containers\/(?<podname>[a-z0-9]([-a-z0-9]*[a-z0-9])?(\/[a-z0-9]([-a-z0-9]*[a-z0-9])?)*)_(?<namespace>[^_]+)_(?<container>.+)-(?<docker_id>[a-z0-9]{64})\.log$/`| 1.15 |

Specifies the regular expression for extracting metadata (namespace, podname) from log file path. Default value of the pattern regexp extracts information about `namespace`, `podname`, `docker_id`, `container` of the log (K8s specific). 

You can also add custom named captures in `pattern` for custom grouping of log files. For example, 
```text
    pattern /^\/home\/logs\/(?<file>.+)\.log$/
```
In this example, filename will be extracted and used to form groups.

#### `rate_period`

| type | default | version |
| :--- | :--- | :--- |
| time | 60 \(seconds\) | 1.15 |

Time period in which the group line limit is applied. `in_tail` resets the counter after every `rate_period` interval.

#### `<rule>` Section \(required\)

Grouping rules for log files.

##### match

| type | default | version |
| :--- | :--- | :--- |
| hash | {"namespace": "/./", "podname": "/./"} | 1.15 |

`match` parameter is used to check if a file belongs to a particular group based on hash keys (named captures from `pattern`) and hash values (regexp in string)

##### limit

| type | default | version |
| :--- | :--- | :--- |
| integer | -1 | 1.15 |

Maximum number of lines allowed from a group in `rate_period` time interval. The default value of `-1` doesn't throttle log files of that group.

## Learn More

* [Input Plugin Overview](./)

## FAQ

### What happens when `<parse>` type is not matched for logs?

`in_tail` prints warning message. For example, if you specify `@type json` in `<parse>` and your log line is `123,456,str,true`, then you will see following message in fluentd logs:

```text
2018-04-19 02:23:44 +0900 [warn]: #0 pattern not match: "123,456,str,true"
```

See also `emit_unmatched_lines` parameter.

### `in_tail` doesn't start to read the log file, why?

`in_tail` follows `tail -F` command's behavior by default, so `in_tail` reads only the new logs. If you want to read the existing lines for the batch use case, set `read_from_head true`.

### `in_tail` shows `/path/to/file unreadable` log message. Why?

If you see this message:

> `/path/to/file` unreadable. It is excluded and would be examined next time.

It means that `fluentd` does not have read permission for `/path/to/file`. Check your fluentd and target files permission.

**Note**: When `td-agent` is launched by systemd, the default user of the `td-agent` process is the `td-agent` user.
You must ensure that this user has read permission to the tailed `/path/to/file`. For instance, on Ubuntu,
the default Nginx access file `/var/log/nginx/access.log` is mode `0640` and owned by `www-data:adm`. In
this case, several options are available to allow read access:

1. Add the `td-agent` user to the `adm` group, e.g. through `usermod -aG`, or
2. Use the [`cap_dac_read_search` capability](../deployment/linux-capability#capability-handling-on-in_tail)
   to allow the invoking user to read the file without otherwise changing its permission bits or ownership.

A bug exists in Fluentd 1.13.x where it may suppress warning logs about unreadable files. (See Fluentd PR [#3478](https://github.com/fluent/fluentd/pull/3478).)

### `logrotate` Setting

`logrotate` has the `nocreate` parameter and it does not create a new file if log rotation is triggered. It means `in_tail` cannot find the new file to tail.

This parameter does not fit the typical application log use cases, so check your `logrotate` setting which does not include the `nocreate` parameter.

### What happens when `in_tail` receives `BufferOverflowError`?

`in_tail` stops reading the new lines and pos file updates until `BufferOverflowError` is resolved. After resolving `BufferOverflowError`, resume emitting new lines and pos file updates.

### `in_tail` is sometimes stopped when monitor lots of files. How to avoid it?

Try to set `enable_stat_watcher false` in `in_tail` setting. We got several reports that `in_tail` is stopped when `*` is included in `path`, and the problem is resolved by disabling the `inotify` events.

### Wildcard pattern in `path` does not work on Windows, why?

The backslash \(`\`\) with `*` does not work on Windows by internal limitations. To avoid this, use slash style instead:

```text
# good
path C:/path/to/*/foo.log

# bad
path C:\\path\\to\\*\\foo.log
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

### What happens when a file can be assigned to more than one group? 

Example,

```text
  <rule> ## Rule1
    match {
      namespace: /monitoring/
    } 
    limit 100
  </rule>

  <rule> ## Rule2
    match {
      namespace: /monitoring/,
      podname: /logger/,
    }
    limit 2000
  </rule>
```

In this case, rules with more constraints, i.e., greater number of `match` hash keys will be given a higher priority. So a file will be assigned to `Rule2` if it can be assigned to both `Rule1` and `Rule2`.
