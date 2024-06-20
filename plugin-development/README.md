# Plugin Development

## Overview

With fluentd, you can install and create custom plugins.

To install or create a custom plugin, the file name need to be `<TYPE>_<NAME>.rb`. Note that `TYPE` is a prefix indicating the type of plugin, and could be:

| prefix | plugin type |
| :---: | :---: |
| `in` | input |
| `out` | output |
| `filter` | filter |
| `parser` | parser |
| `formatter` | formatter |
| `storage` | storage |
| `buf` | buffer |
| `sd` | service discovery |

## Installing Custom Plugins

To install a plugin, put the Ruby script in `/etc/fluent/plugin` directory. (The file name needs to have the `TYPE` prefix.)
Alternatively, you can create a Ruby Gem package that includes:

```text
lib/fluent/plugin/<TYPE>_<NAME>.rb
```

For example, an email output plugin would have the path:

```text
lib/fluent/plugin/out_mail.rb
```

The packaged gem can be distributed and installed using RubyGems. For further information, see the [list of Fluentd plugins](http://www.fluentd.org/plugins) for third-party plugins.

## Writing Plugins

To create a plugin as a Ruby script \(to put it in `/etc/fluent/plugin/` directory\), create a `<TYPE>_<NAME>.rb` file in any editor/IDE of your choice.

Example:

```ruby
# in_my_awesome.rb
require 'fluent/plugin/input'

module Fluent
  module Plugin
    class MyAwesomeInput < Input
      # For `@type my_awesome` in configuration file
      Fluent::Plugin.register_input('my_awesome', self)

      def configure(conf)
        super
      end

      def start
        super
        # ...
      end
    end
  end
end
```

See the respective plugin development article, "How to write XXX plugin", for API details.

A single Ruby script is easy to write but hard to test, manage, version. publish, etc.

If you want to publish a plugin under version control, you should use `bundle gem` to create the plugin source tree and then `git init` it. It requires the `bundler` gem in your Ruby environment.

Example:

```text
$ bundle gem fluent-plugin-my_awesome
```

It generates source code directory tree under `lib`, `fluent-plugin-my_awesome.gemspec` file, `README.md` and other relevant files.

Fluentd plugin projects use a bit different code tree under `lib` i.e.:

```text
lib/fluent/plugin/<TYPE>_<NAME>.rb
```

### Generating Plugin Project Skeleton

To make things easier, `fluent-plugin-generate` is provided to generate the project skeleton for writing a Fluentd plugin as a Gem package.

For example, to generate the project skeleton for an input plugin `http2`, the command would be:

```text
$ fluent-plugin-generate input http2
License: Apache-2.0
        create Gemfile
        create README.md
        create Rakefile
        create fluent-plugin-http2.gemspec
        create lib/fluent/plugin/in_http2.rb
        create test/helper.rb
        create test/plugin/test_in_http2.rb
Initialized empty Git repository in /path/to/fluent-plugin-http2/.git/
$ tree
fluent-plugin-http2/
├── Gemfile
├── LICENSE
├── README.md
├── Rakefile
├── fluent-plugin-http2.gemspec
├── lib
│   └── fluent
│       └── plugin
│           └── in_http2.rb
└── test
    ├── helper.rb
    └── plugin
        └── test_in_http2.rb

5 directories, 8 files
```

If you want to generate a project skeleton without LICENSE, use `--no-license` option. For more details, see `fluent-plugin-generate --help`.

## Debugging Plugins

Run `fluentd` with the `-vv` command-line option to show debugging messages:

```text
$ fluentd -vv
```

The `stdout` and `copy` output plugins are useful for debugging. The `stdout` output plugin dumps matched events to the standard output \(console\). It can be configured like this:

```text
# You want to debug this plugin.
<source>
  @type your_custom_input_plugin
</source>

# Dump all events to stdout.
<match **>
  @type stdout
</match>
```

The **copy** output plugin copies the matched events to the multiple output plugins. You can use it in conjunction with the stdout plugin:

```text
<source>
  @type forward
</source>

# Use the forward Input plugin and the fluent-cat command to feed events:
#  $ echo '{"event":"message"}' | fluent-cat test.tag
<match test.tag>
  @type copy

  # Dump the matched events.
  <store>
    @type stdout
  </store>

  # Feed the dumped events to your plugin.
  <store>
    @type your_custom_output_plugin
  </store>
</match>
```

You can use **stdout** filter instead of **copy** and **stdout** combination. The result is the same as above but more simpler.

```text
<source>
  @type forward
</source>

<filter>
  @type stdout
</filter>

<match test.tag>
  @type your_custom_output_plugin
</match>
```

## Writing Tests for Plugins

Fluentd provides unit test frameworks for plugins:

```ruby
Fluent::Test::Driver::Input   # Test driver for input plugins.
Fluent::Test::Driver::Output  # Test driver for output plugins.
Fluent::Test::Driver::Filter  # Test driver for filter plugins.
```

It is strongly recommended to use `test-unit` as the unit test library. Fluentd's test drivers assume that the test code uses it. Add `test-unit`as the development dependency in your `gemspec`, add `Rake` task to run tests in your `Rakefile` and write test code in `test/plugin/test_in_my_awesome.rb`.

**gemspec**

```ruby
Gem::Specification.new do |gem|
  gem.name = 'fluent-plugin-my_awesome'
  # ...
  gem.add_runtime_dependency     'fluentd'
  gem.add_development_dependency 'test-unit'
end
```

**Rakefile**

```ruby
require 'rake/testtask'
  Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
```

Run `bundle` to execute tests:

```text
$ bundle exec rake test
```

See [Writing Plugin Test Code](plugin-test-code.md) for more details on writing tests.

## Writing Documents for Plugins

Following is a snippet of `README.md` showing the project skeleton generated with `fluent-plugin-generate`.

For example:

<!--- four backquotes are used because the block contains three backquotes for markup -->
````text
# fluent-plugin-http2

[Fluentd](https://fluentd.org/) input plugin to do something.

TODO: write description for you plugin.

## Installation

### RubyGems

```
$ gem install fluent-plugin-http2
```

### Bundler

Add following line to your Gemfile:

```ruby
gem "fluent-plugin-http2"
```

And then execute:

```
$ bundle
```

## Configuration

You can generate configuration template:

```
$ fluent-plugin-config-format input http2
```

You can copy and paste generated documents here.

## Copyright

* Copyright(c) 2017- John Doe
* License
  * Apache License, Version 2.0
````

You should write the plugin description and configurations.

You can generate configuration using `fluent-plugin-config-format` command.

Example \(input dummy\):

```text
$ fluent-plugin-config-format -c input dummy
## Plugin helpers

* thread
* storage

* See also: Fluent::Plugin::Input

## Fluent::Plugin::DummyInput

* **tag** (string) (required): The value is the tag assigned to the generated events.
* **size** (integer) (optional): The number of events in event stream of each emits.
  * Default value: `1`.
* **rate** (integer) (optional): It configures how many events to generate per second.
  * Default value: `1`.
* **auto_increment_key** (string) (optional): If specified, each generated event has an auto-incremented key field.
* **suspend** (bool) (optional): The boolean to suspend-and-resume incremental value after restart
* **dummy** () (optional): The dummy data to be generated. An array of JSON hashes or a single JSON hash.
  * Default value: `[{"message"=>"dummy"}]`.
```

For more details, see `fluent-plugin-config-format --help`.

## Note

The following slides can help understand how Fluentd works before diving into writing custom plugins.

These slides are from [Naotoshi Seo's](https://github.com/sonots) [RubyKaigi 2014 talk](http://rubykaigi.org/2014/presentation/S-NaotoshiSeo/).

The slides are based on Fluentd v0.12. There are many differences between v0.12 and v1 API, but it may help build an understanding of overall Fluentd's design.

### Fluentd Version and Plugin API

Fluentd now has two active versions, v1 and v0.12. v1 is the current stable with the brand-new Plugin API. v0.12 is the old stable and it has the old Plugin API.

The important point is v1 supports v1 and v0.12 APIs. It means the plugin for v0.12 works with v1.

It is recommended to use the new v1 plugin API for writing new plugins.

### Send a patch or fork?

If you have a problem with any existing plugins or a new feature idea, sending a patch is better. If the plugin author is non-active, try to become its new plugin maintainer first. Forking a plugin and release its alternative version, e.g. `fluent-plugin-xxx-alt` is considered the last option.

### Be careful not breaking Fluentd's core functionality

Any fluentd plugin can unknowingly break fluentd completely (and possibly break other plugins) by requiring some incompatible modules.

One typical example is reloading `yajl/json_gem` from plugin. (`yajl/json_gem` compatibility layer is problematic, not for `yajl` itself)
It breaks a functionality to parse Fluentd's configuration completely.

Fluentd's plug-in mechanism has a merit to extend functionality, but plugin developer must be careful a possibility of breaking it.


## Further Reading

* [Slides: Fluentd v0.14 Plugin API Details](http://www.slideshare.net/tagomoris/fluentd-v014-plugin-api-details)
* [Slides: Dive into Fluentd Plugin](http://www.slideshare.net/repeatedly/dive-into-fluentd-plugin-v012) (outdated)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
