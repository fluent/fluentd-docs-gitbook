# Plugin Helper: Child Process

The `child_process` helper manages the child processes' lifecycle.

Here is an example:

```ruby
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput < Output
    Fluent::Plugin.register_output('example', self)

    # 1. Load child_process helper
    helpers :child_process

    # Omit configure, shutdown and other plugin API

    def start
      super
      # 2. Execute child process with unique name
      child_process_execute(:exec_external_command, 'external_command', immediate: true, mode: [:read]) do
        # ...
      end
    end
  end
end
```

The launched child process is managed by the plugin helper which automatically `shutdown`s it.

## Methods

### `child_process_execute(title, sub_process_name, arguments: nil, subprocess_name: nil, interval: nil, immediate: false, parallel: false, mode: [:read, :write], stderr: :discard, env: {}, unsetenv: false, chdir: nil, internal_encoding: 'utf-8', external_encoding: 'ascii-8bit', scrub: true, replace_string: nil, wait_timeout: nil, on_exit_callback: nil, &block)`

This method executes `child_process` with the given parameters and routine.

* `title`: unique symbol value
* `sub_process_name`: sub process name value
* `interval`: Second unit `integer`/`float` value.
* `immediate`: `true`/`false`. Default is `false`.
* `parallel`: `true`/`false`. Default is `false`.
* `mode`: \[`:read`, `:write`\]. Default is \[`:read`, `:write`\].
* `stderr`: Connect stderr or not. Default is `:discard`.
* `env`: Environment valuables. Default is {}.
* `unsetenv`: `true`/`false`. Default is `false`
* `chdir`: Working directory. Default is `nil`.
* `internal_encoding`: Internal character encoding. Default is `utf-8`.
* `external_encoding`: External character encoding. Default is `ascii-8bit`'
* `scrub`: `true`/`false`. Default is `true`.
* `replace_string`: Replace the invalid code point with the specified character.

  Default is `nil`.

* `wait_timeout`: Set timeout seconds. Default is `nil`.
* `on_exit_callback`: Set callback function. Default is `nil`

Code examples:

```ruby
# Pass block directly. block is executed with 10 second interval.
child_process_execute(:exec_awesome_command, @command, interval: 10, mode: [:read]) do |io|
  # ...
end

# Pass block with existing method. block is executed once.
child_process_execute(:exec_awesome_command, @command, immediate: true, mode: [:read], &method(:run))

def run(io)
  # ...
end
```

## Plugins using `child_process`

* [`in_exec`](../input/exec.md)
* [`out_exec`](../output/exec.md)
* [`out_exec_filter`](../output/exec_filter.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

