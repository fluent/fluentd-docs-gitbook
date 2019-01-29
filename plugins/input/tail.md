# tail Input Plugin

The `in_tail` Input plugin allows Fluentd to read events from the tail
of text files. Its behavior is similar to the `tail -F` command.


## Example Configuration

`in_tail` is included in Fluentd's core. No additional installation
process is required.

``` {.CodeRay}
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

Please see the [Config File](/configuration/config-file.md) article for the basic
structure and syntax of the configuration file. For \<parse\> section,
please check [Parse section cofiguration](/configuration/parse-section.md).


### How it Works

-   When Fluentd is first configured with `in_tail`, it will start
    reading from the **tail** of that log, not the beginning.
-   Once the log is rotated, Fluentd starts reading the new file from
    the beginning. It keeps track of the current inode number.
-   If `td-agent` restarts, it starts reading from the last position
    td-agent read before the restart. This position is recorded in the
    position file specified by the pos\_file parameter.


## Plugin helpers

-   [timer](/articles/api-plugin-helper-timer.md)
-   [event\_loop](/articles/api-plugin-helper-event_loop.md)
-   [parser](/articles/api-plugin-helper-parser.md)
-   [compat\_parameters](/articles/api-plugin-helper-compat_parameters.md)


## Parameters

[Common Parameters](/configuration/plugin-common-parameters.md)

[]{#@type-(required)}

### \@type (required)

The value must be `tail`.


### tag

    type         default         version
  -------- -------------------- ---------
   string   required parameter   0.14.0

The tag of the event.

`*` can be used as a placeholder that expands to the actual file path,
replacing '/' with '.'. For example, if you have the following
configuration

``` {.CodeRay}
path /path/to/file
tag foo.*
```

in\_tail emits the parsed events with the 'foo.path.to.file' tag.


### path

    type         default         version
  -------- -------------------- ---------
   string   required parameter   0.14.0

The paths to read. Multiple paths can be specified, separated by ','.

`*` and strftime format can be included to add/remove watch file
dynamically. At interval of `refresh_interval`, Fluentd refreshes the
list of watch file.

``` {.CodeRay}
path /path/to/%Y/%m/%d/*
```

For multiple paths:

``` {.CodeRay}
path /path/to/a/*,/path/to/b/c.log
```

If the date is 20140401, Fluentd starts to watch the files in
/path/to/2014/04/01 directory. See also `read_from_head` parameter.

You should not use \'\*\' with log rotation because it may cause the log
duplication. In such case, you should separate in\_tail plugin
configuration.


### exclude\_path

   type      default      version
  ------- -------------- ---------
   array   \[\] (empty)   0.14.0

The paths to exclude the files from watcher list. For example, if you
want to remove compressed files, you can use following pattern.

``` {.CodeRay}
path /path/to/*
exclude_path ["/path/to/*.gz", "/path/to/*.zip"]
```

\`exclude\_path\` takes its input as an array, unlike \`path\` which
takes it as a string.


### refresh\_interval

   type     default      version
  ------ -------------- ---------
   time   60 (seconds)   0.14.0

The interval of refreshing the list of watch file. This is used when
path includes `*`.


### limit\_recently\_modified

   type      default       version
  ------ ---------------- ---------
   time   nil (disabled)   0.14.13

Limit the watching files that the modification time is within the
specified time range when use `*` in `path` parameter.


### skip\_refresh\_on\_startup

   type   default   version
  ------ --------- ---------
   bool    false    0.14.13

Skip the refresh of watching list on startup. This reduces the start up
time when use `*` in `path`.


### read\_from\_head

   type   default   version
  ------ --------- ---------
   bool    false    0.14.0

Start to read the logs from the head of file, not bottom.

If you want to tail all contents with `*` or strftime dynamic path, set
this parameter to `true`. Instead, you should guarantee that log
rotation will not occur in `*` directory.

When this is true, in\_tail tries to read a file during start up phase.
If target file is large, it takes long time and starting other plugins
isn't executed until reading file is finished.


### encoding, from\_encoding

    type                   default                  version
  -------- --------------------------------------- ---------
   string   nil (string encoding is `ASCII-8BIT`)   0.14.0

Specify the encoding of reading lines.

By default, in\_tail emits string value as ASCII-8BIT encoding. These
options change it.

-   If specify only `encoding`, in\_tail changes string to `encoding`.
    This use ruby's
    [String\#force\_encoding](https://docs.ruby-lang.org/en/trunk/String.html#method-i-force_encoding)
-   If specify `encoding` and `from_encoding`, in\_tail tries to encode
    string from `from_encoding` to `encoding`. This uses ruby's
    [String\#encode](https://docs.ruby-lang.org/en/trunk/String.html#method-i-encode)

You can get supported encoding list by typing following command:

``` {.CodeRay}
$ ruby -e 'p Encoding.name_list.sort'
```


### read\_lines\_limit

    type     default   version
  --------- --------- ---------
   integer    1000     0.14.0

The number of reading lines at each IO.

If you see "Size of the emitted data exceeds buffer\_chunk\_limit." log
with in\_tail, set smaller value.


### multiline\_flush\_interval

   type      default       version
  ------ ---------------- ---------
   time   nil (disabled)   0.14.0

The interval of flushing the buffer for multiline format.

If you set `multiline_flush_interval 5s`, in\_tail flushes buffered
event after 5 seconds from last emit. This option is useful when you use
`format_firstline` option. Since v0.12.20 or later.


### pos\_file (highly recommended)

    type    default   version
  -------- --------- ---------
   string     nil     0.14.0

This parameter is highly recommended. Fluentd will record the position
it last read into this file.

``` {.CodeRay}
pos_file /var/log/td-agent/tmp/access.log.pos
```

`pos_file` handles multiple positions in one file so no need multiple
`pos_file` parameters per `source`.

Don't share pos\_file between in\_tail configurations. It causes
unexpected behavior, e.g. corrupt pos\_file content.

in\_tail removes untracked file position during startup phase. It means
the content of pos\_file is growing until restart when you tails lots of
files with dynamic path setting. I will fix this problem in the future.
Check [this issue](https://github.com/fluent/fluentd/issues/1126).

[]{#<parse>-directive-(required)}

### \<parse\> directive (required)

The format of the log. `in_tail` uses parser plugin to parse the log.
See [parser article](/plugins/parser/README.md) for more detail.

Here are several examples:

``` {.CodeRay}
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

If `@type` contains `multiline`, in\_tail works as multiline mode.


### format

Deprecated parameter. Use `<parse>` instead.


### path\_key

    type        default       version
  -------- ----------------- ---------
   string   nil (no assign)   0.14.0

Add watching file path to `path_key` field.

``` {.CodeRay}
path /path/to/access.log
path_key tailed_path
```

With this config, generated events are like
`{"tailed_path":"/path/to/access.log","k1":"v1",...,"kN":"vN"}`.


### rotate\_wait

   type     default     version
  ------ ------------- ---------
   time   5 (seconds)   0.14.0

in\_tail actually does a bit more than `tail -F` itself. When rotating a
file, some data may still need to be written to the old file as opposed
to the new one.

in\_tail takes care of this by keeping a reference to the old file (even
after it has been rotated) for some time before transitioning completely
to the new file. This helps prevent data designated for the old file
from getting lost. By default, this time interval is 5 seconds.

The rotate\_wait parameter accepts a single integer representing the
number of seconds you want this time interval to be.


### enable\_watch\_timer

   type   default   version
  ------ --------- ---------
   bool    true     0.14.0

Enable the additional watch timer. Setting this parameter to `false`
will significantly reduce CPU and I/O consumption when tailing a large
number of files on systems with inotify support. The default is `true`
which results in an additional 1 second timer being used.

`in_tail` (via Cool.io) uses inotify on systems which support it.
Earlier versions of libev on some platforms (eg Mac OS X) did not work
properly; therefore, an explicit 1 second timer was used. Even on
systems with inotify support, this results in additional I/O each
second, for every file being tailed.

Early testing demonstrates that modern Cool.io and `in_tail` work
properly without the additional watch timer. At some point in the
future, depending on feedback and testing, the additional watch timer
may be disabled by default.


### enable\_stat\_watcher

   type   default   version
  ------ --------- ---------
   bool    true      1.0.1

Enable the additional inotify based watcher. Setting this parameter to
`false` will disable inotify events and use only timer watcher for file
tailing.

This option is mainly for avoiding stuck issue with inotify.


### open\_on\_every\_update

   type   default   version
  ------ --------- ---------
   bool    false    0.14.12

Open and close the file on every update instead of leaving it open until
it gets rotated.


### emit\_unmatched\_lines

   type   default   version
  ------ --------- ---------
   bool    false    0.14.12

Emit unmatched lines when `<parse>` format is not matched for incoming
logs.

Emitted record is `{"unmatched_line" : incoming line}`, e.g.
`{"unmatched_line" : "Non JSON format!"}`.


### ignore\_repeated\_permission\_error

   type   default   version
  ------ --------- ---------
   bool    false    0.14.0

If you hard to exclude non-permision files from watching list, set this
parameter to `true`. It suppress repeated permission error logs.

#### \@log\_level option

The `@log_level` option allows the user to set different levels of
logging for each plugin. The supported log levels are: `fatal`, `error`,
`warn`, `info`, `debug`, and `trace`.

Please see the [logging article](/deployment/logging.md) for further details.


## Learn More

-   [Input Plugin Overview](/plugins/input/README.md)


## FAQ

### What happens when `<parse>` type is not matched for logs.

`in_tail` prints warning message. For example, if you specify
`@type json` in `<parse>` and your log line is `123,456,str,true`, then
you will see following message in fluentd log.

``` {.CodeRay}
2018-04-19 02:23:44 +0900 [warn]: #0 pattern not match: "123,456,str,true"
```

See also `emit_unmatched_lines` parameter.


### in\_tail doesn't start to read log file, why?

`in_tail` follows `tail -F` command behaviour by default, so `in_tail`
reads only newer logs. If you want to read existing lines for batch use
case, set `read_from_head true`.


### in\_tail shows '/path/to/file unreadable' log message. Why?

If you see "/path/to/file unreadable. It is excluded and would be
examined next time." message in the log, it means fluentd doesn't have
read permission for `/path/to/file`. Check your fluentd and target files
permission.


### logrotate setting

`logrotate` has `nocreate` parameter and it doesn't create new file
after triggered log rotation. It means `in_tail` can't find new file to
tail.

This parameter doesn't fit typical application log cases, so check your
`logrotate` setting which doesn't include `nocreate` parameter.


### What happens when in\_tail receives BufferOverflowError?

in\_tail stops reading new lines and pos file update until
BufferOverflowError is resolved. After resolved BufferOverflowError,
restart emitting new lines and pos file update.


### in\_tail is sometimes stopped when monitor lots of files. How to avoid it?

Try to set `enable_stat_watcher false` in `in_tail` setting. We got
several reports in\_tail is stopped when use `*` included `path`, and
the problem is resolved by disabling inotify events.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
