# `tail` Input Plugin

![tail.png](/images/plugins/input/tail.png)

The `in_tail` Input plugin allows Fluentd to read events from the tail
of text files. Its behavior is similar to the `tail -F` command.

It is included in Fluentd's core.


## Example Configuration

```
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

Refer to the [Configuration File](/configuration/config-file.md) article for the
basic structure and syntax of the configuration file.

For `<parse>`, see [Parse Section](/configuration/parse-section.md).


### How It Works

When Fluentd is first configured with `in_tail`, it will start reading from the
**tail** of that log, not the beginning. Once the log is rotated, Fluentd starts
reading the new file from the beginning. It keeps track of the current inode
number.

If `td-agent` restarts, it resumes reading from the last position before the
restart. This position is recorded in the position file specified by the
`pos_file` parameter.


## Plugin Helpers

 - [`timer`](/developer/api-plugin-helper-timer.md)
 - [`event_loop`](/developer/api-plugin-helper-event_loop.md)
 - [`parser`](/developer/api-plugin-helper-parser.md)
 - [`compat_parameters`](/developer/api-plugin-helper-compat_parameters.md)


## Parameters

See [Common Parameters](/configuration/plugin-common-parameters.md).


### `@type` (required)

The value must be `tail`.


### `tag`

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.0  |

The tag of the event.

`*` can be used as a placeholder that expands to the actual file path,
replacing `'/'` with `'.'`.

With the following configuration:

```
path /path/to/file
tag foo.*
```

`in_tail` emits the parsed events with the `foo.path.to.file` tag.


### `path`

| type   | default            | version |
|:-------|:-------------------|:--------|
| string | required parameter | 0.14.0  |

The path(s) to read. Multiple paths can be specified, separated by comma `','`.

`*` and `strftime` format can be included to add/remove watch file
dynamically. At interval of `refresh_interval`, Fluentd refreshes the
list of watch file.

```
path /path/to/%Y/%m/%d/*
```

For multiple paths:

```
path /path/to/a/*,/path/to/b/c.log
```

If the date is `20140401`, Fluentd starts to watch the files in
`/path/to/2014/04/01` directory. See also `read_from_head` parameter.

You should not use `*` with log rotation because it may cause the log
duplication. In this case, you should separate `in_tail` plugin configuration.


### `path_timezone`

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 1.8.1   |

This parameter is for `strftime` formatted path like `/path/to/%Y/%m/%d/`.

`in_tail` uses system timezone by default. This parameter overrides it:

```
path_timezone "+00"
```

For timezone format, see [Timezone Section](/configuration/format-section.md/#time-parameters).


### `exclude_path`

| type  | default      | version |
|:------|:-------------|:--------|
| array | `[]` (empty) | 0.14.0  |

The paths to exclude the files from watcher list.

For example, to remove the compressed files, you can use the following pattern:

```
path /path/to/*
exclude_path ["/path/to/*.gz", "/path/to/*.zip"]
```

`exclude_path` takes input as an array, unlike `path` which takes as string.


### `refresh_interval`

| type | default      | version |
|:-----|:-------------|:--------|
| time | 60 (seconds) | 0.14.0  |

The interval of refreshing the list of watch file. This is used when path
includes `*`.


### `limit_recently_modified`

| type | default        | version |
|:-----|:---------------|:--------|
| time | nil (disabled) | 0.14.13 |

Limits the watching files that the modification time is within the
specified time range when using `*` in `path`.


### `skip_refresh_on_startup`

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.13 |

Skips the refresh of watching list on startup. This reduces the startup
time when using `*` in `path`.


### `read_from_head`

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.0  |

Starts to read the logs from the head of file, not tail.

If you want to `tail` the contents with `*` or `strftime` dynamic path, set this
parameter to `true`. Instead, you should guarantee that log rotation will not
occur in `*` directory.

When this is `true`, `in_tail` tries to read a file during startup phase.
If target file is large, it takes long time and starting other plugins
isn't executed until reading file is finished.


### `encoding`, `from_encoding`

| type   | default                               | version |
|:-------|:--------------------------------------|:--------|
| string | nil (string encoding is `ASCII-8BIT`) | 0.14.0  |

Specifies the encoding of reading lines.

By default, `in_tail` emits string value as ASCII-8BIT encoding.

These options change it:

-   If `encoding` is specified, `in_tail` changes string to `encoding`.
    This uses Ruby's [`String#force_encoding`](https://docs.ruby-lang.org/en/trunk/String.html#method-i-force_encoding).
-   If `encoding` and `from_encoding` both are specified, `in_tail` tries to
    encode string from `from_encoding` to `encoding`. This uses Ruby's
    [`String#encode`](https://docs.ruby-lang.org/en/trunk/String.html#method-i-encode).

You can get the list of supported encodings with this command:

```
$ ruby -e 'p Encoding.name_list.sort'
```


### `read_lines_limit`

| type    | default | version |
|:--------|:--------|:--------|
| integer | 1000    | 0.14.0  |

The number of lines to read with each I/O operation.

If you see `chunk bytes limit exceeds for an emitted event stream` or similar log
with `in_tail`, set smaller value.


### `multiline_flush_interval`

| type | default        | version |
|:-----|:---------------|:--------|
| time | nil (disabled) | 0.14.0  |

The interval of flushing the buffer for multiline format.

If you set `multiline_flush_interval 5s`, `in_tail` flushes buffered
event after 5 seconds from last emit. This option is useful when you use
`format_firstline` option.


### `pos_file` (highly recommended)

| type   | default | version |
|:-------|:--------|:--------|
| string | nil     | 0.14.0  |

Fluentd will record the position it last read from this file:

```
pos_file /var/log/td-agent/tmp/access.log.pos
```

`pos_file` handles multiple positions in one file so no need to have multiple
`pos_file` parameters per `source`.

Don't share `pos_file` between `in_tail` configurations. It causes
unexpected behavior e.g. corrupt `pos_file` content.

`in_tail` removes untracked file position during startup. It means that
the content of `pos_file` keeps growing until restart when you tails lots of
files with dynamic path setting.

This [issue](https://github.com/fluent/fluentd/issues/1126) will be fixed this
problem in future.


### `pos_file_compaction_interval`

| type   | default | version |
|:-------|:--------|:--------|
| time   | nil     | 1.9.2   |

The interval of doing compaction of pos file.

The targets of compaction are unwatched, unparsable and duplicated line. You can
use this value when `pos_file` option is set:

```
pos_file /var/log/td-agent/tmp/access.log.pos
pos_file_compaction_interval 72h
```


### `<parse>` Directive (required)

The format of the log.

`in_tail` uses parser plugin to parse the log. See
[`parser`](/plugins/parser/README.md) for more detail.

Examples:

```
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

| type   | default         | version |
|:-------|:----------------|:--------|
| string | nil (no assign) | 0.14.0  |

Adds the watching file path to `path_key` field.

With this configuration:

```
path /path/to/access.log
path_key tailed_path
```

The generated events are like this:

```
{"tailed_path":"/path/to/access.log","k1":"v1",...,"kN":"vN"}
```

### `rotate_wait`

| type | default     | version |
|:-----|:------------|:--------|
| time | 5 (seconds) | 0.14.0  |

`in_tail` actually does a bit more than `tail -F` itself. When rotating a
file, some data may still need to be written to the old file as opposed
to the new one.

`in_tail` takes care of this by keeping a reference to the old file (even
after it has been rotated) for some time before transitioning completely
to the new file. This helps prevent data designated for the old file
from getting lost. By default, this time interval is 5 seconds.

The `rotate_wait` parameter accepts a single integer representing the
number of seconds you want this time interval to be.


### `enable_watch_timer`

| type | default | version |
|:-----|:--------|:--------|
| bool | true    | 0.14.0  |

Enables the additional watch timer. Setting this parameter to `false`
will significantly reduce CPU and I/O consumption when tailing a large
number of files on systems with `inotify` support. The default is `true`
which results in an additional 1 second timer being used.

`in_tail` (via `Cool.io`) uses `inotify` on systems which supports it.
Earlier versions of `libev` on some platforms (e.g. MacOS X) did not work
properly; therefore, an explicit 1 second timer was used. Even on
systems with `inotify` support, this results in additional I/O each
second, for every file being tailed.

Early testing demonstrates that modern `Cool.io` and `in_tail` work properly
without the additional watch timer. At some point in future, depending on the
feedback and testing, the additional watch timer may be disabled by default.


### `enable_stat_watcher`

| type | default | version |
|:-----|:--------|:--------|
| bool | true    | 1.0.1   |

Enables the additional `inotify`-based watcher. Setting this parameter to
`false` will disable `inotify` events and use only timer watcher for file
tailing.

This option is mainly for avoiding stuck issue with `inotify`.


### `open_on_every_update`

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.12 |

Opens and closes the file on every update instead of leaving it open until
it gets rotated.


### `emit_unmatched_lines`

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.12 |

Emits unmatched lines when `<parse>` format is not matched for incoming logs.

Emitted record is `{"unmatched_line" : incoming line}`, e.g.
`{"unmatched_line" : "Non JSON format!"}`.


### `ignore_repeated_permission_error`

| type | default | version |
|:-----|:--------|:--------|
| bool | false   | 0.14.0  |

If you have to exclude the non-permission files from watching list, set this
parameter to `true`. It suppresses the repeated permission error logs.


#### `@log_level`

The `@log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Refer to the [Logging](/deployment/logging.md) for more details.


## Learn More

-   [Input Plugin Overview](/plugins/input/README.md)


## FAQ


### What happens when `<parse>` type is not matched for logs?

`in_tail` prints warning message. For example, if you specify
`@type json` in `<parse>` and your log line is `123,456,str,true`, then
you will see following message in fluentd logs:

```
2018-04-19 02:23:44 +0900 [warn]: #0 pattern not match: "123,456,str,true"
```

See also `emit_unmatched_lines` parameter.


### `in_tail` doesn't start to read the log file, why?

`in_tail` follows `tail -F` command's behavior by default, so `in_tail`
reads only the new logs. If you want to read existing lines for batch use
case, set `read_from_head true`.


### `in_tail` shows `/path/to/file unreadable` log message. Why?

If you see this message:

> `/path/to/file` unreadable. It is excluded and would be examined next time.

It means fluentd does not have read permission for `/path/to/file`. Check your
fluentd and target files permission.


### `logrotate` Setting

`logrotate` has `nocreate` parameter and it does not create a new file if log
rotation is triggered. It means `in_tail` cannot find the new file to tail.

This parameter does not fit typical application log use cases, so check your
`logrotate` setting which doesn't include `nocreate` parameter.


### What happens when `in_tail` receives `BufferOverflowError`?

`in_tail` stops reading the new lines and pos file updates until
`BufferOverflowError` is resolved. After resolving `BufferOverflowError`,
resume emitting new lines and pos file updates.


### `in_tail` is sometimes stopped when monitor lots of files. How to avoid it?

Try to set `enable_stat_watcher false` in `in_tail` setting. We got several
reports that `in_tail` is stopped when `*` is included in `path`, and the
problem is resolved by disabling `inotify` events.


### Wildcard pattern in path does not work on Windows, why?

Backslash(`\`) with `*` doesn't work on Windows by internal limitation.
To avoid this, use slash style instead:

```
# good
path C:/path/to/*/foo.log

# bad
path C:\\path\\to\\*\\foo.log
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native
Computing Foundation (CNCF)](https://cncf.io/). All components are available
under the Apache 2 License.
