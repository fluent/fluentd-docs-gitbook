# exec

The `out_exec` TimeSliced Output plugin passes events to an external program. The program receives the path to a file containing the incoming events as its last argument. The file format is tab-separated values \(TSV\) by default.

It is included in Fluentd's core.

## Example Configuration

```text
<match pattern>
  @type exec
  command cmd arg arg
  <format>
    @type tsv
    keys k1,k2,k3
  </format>
  <inject>
    tag_key k1
    time_key k2
    time_format %Y-%m-%d %H:%M:%S
  </inject>
</match>
```

Please see the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

## Example: Running FizzBuzz Against Data Stream

This example illustrates how to run FizzBuzz with `out_exec`.

We assume that the input file is specified by the last argument in the command line \(`ARGV[-1]`\). The following script `fizzbuzz.py` runs [FizzBuzz](http://en.wikipedia.org/wiki/Fizz_buzz) against the new-line delimited sequence of natural numbers \(1, 2, 3...\) and writes the output to `foobar.out`:

```text
#!/usr/bin/env python
import sys
input = file(sys.argv[-1])
output = file("foobar.out", "a")
for line in input:
    fizzbuzz = int(line.split("\t")[0])
    s = ''
    if fizzbuzz%3 == 0:
        s += 'fizz'
    if fizzbuzz%5 == 0:
        s += 'buzz'
    if len(s) > 0:
        output.write(s+"\n")
    else:
        output.write(str(fizzbuzz)+"\n")
output.close
```

Note that this program is written in Python. For `out_exec` \(as well as `out_exec_filter` and `in_exec`\), **the program can be written in any language, not just Ruby.**

Then, configure Fluentd as follows:

```text
<source>
  @type forward
</source>
<match fizzbuzz>
  @type exec
  command python /path/to/fizzbuzz.py
  <buffer>
    @type file
    path /path/to/buffer_path
    flush_interval 5s # for debugging/checking
  </buffer>
  <format>
    @type tsv
    keys fizzbuzz
  </format>
</match>
```

The `@type tsv` and `keys fizzbuzz` in `<format>` tells Fluentd to extract the `fizzbuzz` field and output it as TSV. This simple example has a single key, but you can of course extract multiple fields and use `format json` to output newline-delimited JSON.

The intermediate TSV is at `/path/to/buffer_path`, and the command `python /path/to/fizzbuzz.py /path/to/buffer_path` is run. This is why in `fizzbuzz.py`, it is reading the file at `sys.argv[-1]`.

If you start Fluentd and run this command:

```text
$ for i in `seq 15`; do echo "{\"fizzbuzz\":$i}" | fluent-cat fizzbuzz; done
```

Then, after 5 seconds, you get a file named `foobar.out`:

```text
$ cat foobar.out
1
2
fizz
4
buzz
fizz
7
8
fizz
buzz
11
fizz
13
14
fizzbuzz
```

## Supported Modes

* Asynchronous

See [Output Plugin Overview](./) for more details.

## Plugin Helpers

* [`inject`](../plugin-helper-overview/api-plugin-helper-inject.md)
* [`formatter`](../plugin-helper-overview/api-plugin-helper-formatter.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)
* [`child_process`](../plugin-helper-overview/api-plugin-helper-child_process.md)

## Parameters

[Common Parameters](../configuration/plugin-common-parameters.md)

### `@type`

The value must be `exec`.

### `command`

| type | default | version |
| :--- | :--- | :--- |
| string | Nothing | 0.14.0 |

The command \(program\) to execute. The `exec` plugin passes the path of flushed buffer chunk as the last argument.

If you set `command` parameter like this:

```text
command cmd arg arg
```

The actual command execution is:

```text
cmd arg arg /path/to/file
```

If `cmd` does not exist in PATH, you need to specify the absolute path, e.g. `/path/to/cmd`.

### `command_timeout`

| type | default | version |
| :--- | :--- | :--- |
| time | 270 | 0.14.9 |

Command \(program\) execution timeout.

### `<format>` Section

See [Format Section](../configuration/format-section.md) for more details.

#### `@type`

| type | default | version |
| :--- | :--- | :--- |
| string | tsv | 0.14.9 |

The format used to map the incoming events to the program input.

Overwrites the default value in this plugin.

### `<inject>` Section

See [Inject Section](../configuration/inject-section.md) for more details.

#### `time_type`

| type | default | version |
| :--- | :--- | :--- |
| string | string | 0.14.9 |

Overwrites the default value in this plugin.

#### `localtime`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 0.14.9 |

Overwrites the default value in this plugin.

### `<buffer>` Section

See [Buffer Section](../configuration/buffer-section.md) for more details.

#### `delayed_commit_timeout`

| type | default | version |
| :--- | :--- | :--- |
| time | 300 | 0.14.9 |

Overwrites the default value in this plugin.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

