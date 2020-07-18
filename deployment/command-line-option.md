# Fluentd Command Line Options

This article describes the `fluentd` command line options.


## `fluentd`

Following are the fluentd command line options (`fluentd -h`):

```
Usage: fluentd [options]
    -s, --setup [DIR=/etc/fluent]    install sample configuration file to the directory
    -c, --config PATH                config file path (default: /etc/fluent/fluent.conf)
        --dry-run                    Check fluentd setup is correct or not
        --show-plugin-config=PLUGIN  Show PLUGIN configuration and exit(ex: input:dummy)
    -p, --plugin DIR                 add plugin directory
    -I PATH                          add library path
    -r NAME                          load library
    -d, --daemon PIDFILE             daemonize fluent process
        --under-supervisor           run fluent worker under supervisor (this option is NOT for users)
        --no-supervisor              run fluent worker without supervisor
        --workers NUM                specify the number of workers under supervisor
        --user USER                  change user
        --group GROUP                change group
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
    -v, --verbose                    increase verbose level (-v: debug, -vv: trace)
    -q, --quiet                      decrease verbose level (-q: warn, -qq: error)
        --suppress-config-dump       suppress config dumping when fluentd starts
    -g, --gemfile GEMFILE            Gemfile path
    -G, --gem-path GEM_INSTALL_PATH  Gemfile install path (default: $(dirname $gemfile)/vendor/bundle)
```


### Important Options

-   `-g`, `--gemfile`: Fluentd starts with bundler-managed dependent plugins.

-   `--suppress-config-dump`: Fluentd starts without configuration dump. If you
    do not want to show the configuration in fluentd logs, e.g. it contains
    private keys, then this options is useful.

-   `--suppress-repeated-stacktrace`: If `true`, suppresses the stacktrace in
    fluentd logs. Since v0.12, this option is `true` by default.

-   `--without-source`: Fluentd starts without input plugins. This option is
    useful for flushing buffers with no new incoming events.

-   `-i`, `--inline-config`: If fluentd is used on XaaS which does not support
    persistent disks, this option is useful.

-   `--no-supervisor`: If you want to use your supervisor tools, this option
    avoids double supervisor.


### Set via Configuration File

Some options can be set via `<system>` directive via configuration file. See
[configuration file](/configuration/config-file.md) article for more on
`<system>` directive.


## `fluent-cat`

The `fluent-cat` command sends an event to fluentd `in_forward`/`in_unix`
plugin. This is particularly useful for testing.

Here is its usage (`fluent-cat --help`):

```
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

```
echo '{"message":"hello"}' | fluent-cat debug.log
```

Send JSON message to an instance of fluentd on another machine on the network:

```
echo '{"message":"hello"}' | fluent-cat debug.log --host testserver --port 24225
```


## `fluent-plugin-config-format`

It generates the formatted configuration document with the specified format for
a plugin.

Here is its usage (`fluent-plugin-config-format -h`):

```
Usage: fluent-plugin-config-format [options] <type> <name>

Output plugin config definitions

Arguments:
        type: input,output,filter,buffer,parser,formatter,storage
        name: registered plugin name

Options:
        --verbose                    Be verbose
    -c, --compact                    Compact output
    -f, --format=FORMAT              Specify format. (markdown,txt,json)
    -I PATH                          Add PATH to $LOAD_PATH
    -r NAME                          Load library
    -p, --plugin=DIR                 Add plugin directory
```


### Example

Generate a README style document from plugin's config parameters:

```
fluent-plugin-config-format output null
```

Generate an old style output from plugin's config parameters:

```
fluent-plugin-config-format -f txt output null
```


## `fluent-plugin-generate`

It generates Fluentd plugin project template. It is good for starting to
Fluentd plugin development for using new API plugin. For more details,
refer to the [Generating plugin project skeleton section](/developer/plugin-development.md/#generating-plugin-project-skeleton).

Here is its usage (`fluent-plugin-generate -h`);

```
Usage: fluent-plugin-generate [options] <type> <name>

Generate a project skeleton for creating a Fluentd plugin

Arguments:
        type: input,output,filter,parser,formatter
        name: Your plugin name

Options:
        --[no-]license=NAME          Specify license name (default: Apache-2.0)
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
