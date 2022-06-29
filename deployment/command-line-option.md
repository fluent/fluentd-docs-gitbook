# Command Line Option

This article describes the command-line tools and its options in `fluentd` project.

## `fluentd`

Following are the fluentd command-line options \(`fluentd -h`\):

```text
Usage: fluentd [options]
    -s, --setup [DIR=/etc/fluent]    install sample configuration file to the directory
    -c, --config PATH                config file path (default: /etc/fluent/fluent.conf)
        --dry-run                    Check fluentd setup is correct or not
        --show-plugin-config=PLUGIN  [DEPRECATED] Show PLUGIN configuration and exit(ex: input:dummy)
    -p, --plugin DIR                 add plugin directory
    -I PATH                          add library path
    -r NAME                          load library
    -d, --daemon PIDFILE             daemonize fluent process
        --under-supervisor           run fluent worker under supervisor (this option is NOT for users)
        --no-supervisor              run fluent worker without supervisor
        --workers NUM                specify the number of workers under supervisor
        --user USER                  change user
        --group GROUP                change group
        --umask UMASK                change umask
    -o, --log PATH                   log file path
        --log-rotate-age AGE         generations to keep rotated log files
        --log-rotate-size BYTES      sets the byte size to rotate log files
        --log-event-verbose          enable log events during process startup/shutdown
    -i CONFIG_STRING,                inline config which is appended to the config file on-the-fly
        --inline-config
        --emit-error-log-interval SECONDS
                                     suppress interval seconds of emit error logs
        --suppress-repeated-stacktrace [VALUE]
                                     suppress repeated stacktrace
        --without-source             invoke a fluentd without input plugins
        --use-v1-config              Use v1 configuration format (default)
        --use-v0-config              Use v0 configuration format
        --strict-config-value        Parse config values strictly
        --enable-input-metrics       Enable input plugin metrics on fluentd
        --enable-size-metrics        Enable plugin record size metrics on fluentd
    -v, --verbose                    increase verbose level (-v: debug, -vv: trace)
    -q, --quiet                      decrease verbose level (-q: warn, -qq: error)
        --suppress-config-dump       suppress config dumping when fluentd starts
    -g, --gemfile GEMFILE            Gemfile path
    -G, --gem-path GEM_INSTALL_PATH  Gemfile install path (default: $(dirname $gemfile)/vendor/bundle)
        --conf-encoding ENCODING     specify configuration file encoding
        --disable-shared-socket      Don't open shared socket for multiple workers
```

### Important Options

* `-g`, `--gemfile`: Fluentd starts with bundler-managed dependent plugins.
* `--suppress-config-dump`: Fluentd starts without configuration dump. If you do not want to show the configuration in fluentd logs, e.g. it contains private keys, then this option is useful.
* `--suppress-repeated-stacktrace`: If `true`, suppresses the stacktrace in fluentd logs. Since v0.12, this option is `true` by default.
* `--without-source`: Fluentd starts without input plugins. This option is useful for flushing buffers with no new incoming events.
* `-i`, `--inline-config`: If fluentd is used on XaaS which does not support persistent disks, this option is useful.
* `--no-supervisor`: If you want to use your supervisor tools, this option avoids double supervisor.

### Set via Configuration File

Some options can be set via `<system>` directive via configuration file. See [configuration file](../configuration/config-file.md) article for more on `<system>` directive.

## `fluent-cat`

The `fluent-cat` command sends an event to fluentd `in_forward`/`in_unix` plugin. This is particularly useful for testing.

Here is its usage \(`fluent-cat --help`\):

```text
Usage: fluent-cat [options] <tag>
    -p, --port PORT                  fluent tcp port (default: 24224)
    -h, --host HOST                  fluent host (default: 127.0.0.1)
    -u, --unix                       use unix socket instead of tcp
    -s, --socket PATH                unix socket path (default: /var/run/fluent/fluent.sock)
    -f, --format FORMAT              input format (default: json)
        --json                       same as: -f json
        --msgpack                    same as: -f msgpack
        --none                       same as: -f none
        --message-key KEY            key field for none format (default: message)
```

### Example

Send JSON message with `debug.log` tag to the local fluentd instance:

```text
echo '{"message":"hello"}' | fluent-cat debug.log
```

Send JSON message to an instance of fluentd on another machine on the network:

```text
echo '{"message":"hello"}' | fluent-cat debug.log --host testserver --port 24225
```

## `fluent-plugin-config-format`

It generates the formatted configuration document with the specified format for a plugin.

Here is its usage \(`fluent-plugin-config-format -h`\):

```text
Usage: fluent-plugin-config-format [options] <type> <name>

Output plugin config definitions

Arguments:
        type: input,output,filter,buffer,parser,formatter,storage,service_discovery
        name: registered plugin name

Options:
        --verbose                    Be verbose
    -c, --compact                    Compact output
    -f, --format=FORMAT              Specify format. (markdown,txt,json)
    -I PATH                          Add PATH to $LOAD_PATH
    -r NAME                          Load library
    -p, --plugin=DIR                 Add plugin directory
    -t, --table                      Use table syntax to dump parameters
```

### Example

Generate a README style document from the plugin's config parameters:

```text
fluent-plugin-config-format output null
```

Generate an old-style output from the plugin's config parameters:

```text
fluent-plugin-config-format -f txt output null
```

Generate a markdown table style output from the plugin's config parameters:

```text
fluent-plugin-config-format -f markdown --table output null
```

## `fluent-plugin-generate`

It generates the Fluentd plugin project template. It is good for starting to Fluentd plugin development for using the new API plugin. For more details, refer to the [Generating plugin project skeleton section](../plugin-development/#generating-plugin-project-skeleton).

Here is its usage \(`fluent-plugin-generate -h`\);

```text
Usage: fluent-plugin-generate [options] <type> <name>

Generate a project skeleton for creating a Fluentd plugin

Arguments:
        type: input,output,filter,parser,formatter,storage
        name: Your plugin name (fluent-plugin- prefix will be added to <name>)

Options:
        --[no-]license=NAME          Specify license name (default: Apache-2.0)
```

## `fluent-ctl`

Control `fluentd` process using [Signals](signals.md) or Windows Event.

```text
Usage: fluent-ctl COMMAND [PID_OR_SVCNAME]

Commands:
  shutdown
  restart
  flush
  reload
  dump
```

### Example

You can specify the process id of the supervisor process.

```text
fluent-ctl shutdown 11111
```

If you run Fluentd as a Windows service, then you can omit `PID_OR_SVCNAME` when the service name is the default value `fluentdwinsvc`.

```text
fluent-ctl dump
```

### About `dump`

This function is mainly for Windows.

On Windows, this makes all Fluentd processes (including all worker processes) dump their internal status to the system temp directory (`C:\\Windows\\Temp`). This is the same behavior as sending SIGCONT to all processes on non-Windows. 

Since this uses [SIGDUMP](https://github.com/frsyuki/sigdump), you can change the output path by specifying `SIGDUMP_PATH` environment variable. Note that the path has to be a file path.

```Powershell
$ $env:SIGDUMP_PATH="/sigdump/sigdump.log" # The directory `sidgump` has to exist.
$ fuentd -c ...
$ fluent-ctl dump # At another shell.
```

Then Fluentd dumps files as following. Each process id is automatically added to the path.

```text
... [info]: fluent/log.rb:330:info: dump to /sigdump/sigdump-41544.log.
... [info]: #0 fluent/log.rb:330:info: dump to /sigdump/sigdump-21152.log.
... [info]: #1 fluent/log.rb:330:info: dump to /sigdump/sigdump-15656.log.
...
```

As for non-Windows, you don't have to use this function because you can manually send SIGCONT to each process. Although you can use this function on non-Windows, this just sends SIGCONT to the supervisor process, so you can get only the status of the supervisor process.

## `fluent-cap-ctl`

Control Linux Capability for Fluentd. See [Linux Capability](linux-capability.md) article.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

