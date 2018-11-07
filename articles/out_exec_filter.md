# exec\_filter Output Plugin

The `out_exec_filter` Buffered Output plugin (1) executes an external
program using an event as input and (2) reads a new event from the
program output. It passes tab-separated values (TSV) to stdin and reads
TSV from stdout by default.


## Example Configuration

`out_exec_filter` is included in Fluentd's core. No additional
installation process is required.

``` {.CodeRay}
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

Please see the [Config File](/articles/config-file.md) article for the basic
structure and syntax of the configuration file.

When using the json format in \<parse\> section, this plugin uses the
Yajl library to parse the program output. Yajl buffers data internally
so the output isn\'t always instantaneous.


## Supported modes

-   Synchronous

-   See also: [Output Plugin Overview](/articles/output-plugin-overview.md)


## Plugin helpers

-   [compat\_parameters](/articles/api-plugin-helper-compat_parameters.md)
-   [inject](/articles/api-plugin-helper-inject.md)
-   [formatter](/articles/api-plugin-helper-formatter.md)
-   [parser](/articles/api-plugin-helper-parser.md)
-   [extract](/articles/api-plugin-helper-extract.md)
-   [child\_process](/articles/api-plugin-helper-child_process.md)
-   [event\_emitter](/articles/api-plugin-helper-event_emitter.md)


## Parameters

[]{#@type}

### \@type

The value must be `exec_filter`.


### command

    type         default         version
  -------- -------------------- ---------
   string   required parameter   0.14.0

The command (program) to execute. The `out_exec_filter` plugin passes
the incoming event to the program input and receives the filtered event
from the program output.


### num\_children

    type     default   version
  --------- --------- ---------
   integer      1      0.14.0

The number of spawned process for `command`.

If the number is larger than 2, fluentd uses spawned processes by round
robin fashion.


### child\_respawn

    type    default   version
  -------- --------- ---------
   string     nil     0.14.0

Respawn command when command exit. Default is disabled.

If you specify a positive number, try to respawn until specified times.
If you specify `inf` or `-1`, try to respawn forever.


### tag

    type    default   version
  -------- --------- ---------
   string     nil     0.14.0

The tag of the event.


### read\_block\_size

   type   default   version
  ------ --------- ---------
   size    10240    0.14.9

The default block size to read if parser requires partial read.


### num\_children

    type     default   version
  --------- --------- ---------
   integer      1      0.14.0

The number of spawned process for command.


### suppress\_error\_log\_interval

   type   default   version
  ------ --------- ---------
   time      0      0.14.0

Suppress error logs during this interval.

Output logs for all of messages to emit by default.


### in\_format

**This parameter is deprecated.** Use `<format>` section.

The format used to map the incoming event to the program input.


### out\_format

**This parameter is deprecated.** Use `<format>` section.

The format used to process the program output.

[]{#<format>-section}

### \<format\> section

The format used to map the incoming events to the program input.

See [Format section configurations](/articles/format-section.md) for more details.

#### \@type

    type    default   version
  -------- --------- ---------
   string     tsv     0.14.9

Overwrite default value in this plugin.

[]{#<parse>-section}

### \<parse\> section

The format used to process the program output.

See [Parse section configurations](/articles/parse-section.md) for more details.

#### \@type

    type    default   version
  -------- --------- ---------
   string     tsv     0.14.9

Overwrite default value in this plugin.

#### time\_key

    type    default   version
  -------- --------- ---------
   string     nil     0.14.9

Overwrite default value in this plugin.

#### time\_format

    type    default   version
  -------- --------- ---------
   string     nil     0.14.9

Overwrite default value in this plugin.

#### localtime

   type   default   version
  ------ --------- ---------
   bool    false    0.14.9

Overwrite default value in this plugin.

[]{#<inject>-section}

### \<inject\> section

See [Inject section configurations](/articles/inject-section.md) for more details.

#### time\_type

   type   default   version
  ------ --------- ---------
   enum    float    0.14.9

Overwrite default value in this plugin.

[]{#<extract>-section}

### \<extract\> section

See [Extract section configurations](/articles/extract-section.md) for more details.

#### time\_type

   type   default   version
  ------ --------- ---------
   enum    float    0.14.9

Overwrite default value in this plugin.

[]{#<buffer>-section}

### \<buffer\> section

See [Buffer section configurations](/articles/buffer-section.md) for more details.

#### flush\_mode

   type   default    version
  ------ ---------- ---------
   enum   interval   0.14.9

Overwrite default value in this plugin.

#### flush\_interval

    type     default   version
  --------- --------- ---------
   integer      1      0.14.9

Overwrite default value in this plugin.


## Script example

Here is an example writtein in ruby.

``` {.CodeRay}
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

Corresponding configuration is below:

``` {.CodeRay}
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

If you want to use other language, translate above script example into
your language.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
