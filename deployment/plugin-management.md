# Plugin Management

This article explains how to manage Fluentd plugins, including adding third-party plugins.

## `fluent-gem`

The `fluent-gem` command is used to install Fluentd plugins. This is a wrapper around the `gem` command.

Example:

```text
fluent-gem install fluent-plugin-grep
```

Ruby does not guarantee the C extension API compatibility between its major versions. If you update Fluentd's Ruby version, you should reinstall the plugins that depend on C extension.

### Do not use unreliable plugins

Any fluentd plugin can unknowingly break fluentd completely (and possibly break other plugins) by requiring some incompatible modules.

There is no way to block this kind of situation. This is because the problem itself is derived from plug-in mechanism, and that's Lightweight Language.
One solution is "Do not use unreliable plugins".

Generally speaking, plug-in mechanism can break core functionality not only Fluentd but also in most other software.
We shouldn't use unreliable plugins in any software.

We recommend to send feedback to plugin owner if you faced such a fault in plugins.

### If Using `td-agent`, Use `/usr/sbin/td-agent-gem`

If you are using `td-agent`, make sure that you use `td-agent-gem` command to install gems for it. Otherwise, you won't be able to find the **installed** plugins.

### Gem and Native Extension

Some plugins depend on the native extension library. It means that you need to install development packages to build it e.g. `gcc`, `make`, `autoconf`, etc.

Install development packages first, if you see logs like this:

```text
Building native extensions.  This could take a while...
ERROR:  Error installing fluent-plugin-twitter:
        ERROR: Failed to build gem native extension.

    /opt/td-agent/embedded/bin/ruby extconf.rb

checking for rb_str_scrub()... yes
creating Makefile

make "DESTDIR = " clean
sh: 1: make: not found

make "DESTDIR = "
sh: 1: make: not found

make failed, exit code 127

Gem files will remain installed in /opt/td-agent/embedded/lib/ruby/gems/2.1.0/gems/string-scrub-0.0.3 for inspection.
Results logged to /opt/td-agent/embedded/lib/ruby/gems/2.1.0/extensions/x86_64-linux/2.1.0/string-scrub-0.0.3/gem_make.out
```

## `-p` option

Fluentd's `-p` option is used to add an extra plugin directory to the load path. For example, if you put `out_foo.rb` plugin into `/path/to/plugin`, you can load it by specifying the `-p` option like this:

```text
fluentd -p /path/to/plugin
```

You can specify the `-p` option more than once.

## Add a Plugin via `/etc/fluent/plugin`

By default, Fluentd adds the `/etc/fluent/plugin` directory to its load path. Thus, any additional plugins that are placed in `/etc/fluent/plugin` will be loaded automatically.

### If Using `td-agent`, Use `/etc/td-agent/plugin`

For `td-agent`, Fluentd uses the `/etc/td-agent/plugin` directory instead of `/etc/fluent/plugin` so put your plugins accordingly.

## Plugin Version Management

Fluentd and plugins are evolving so you may hit an unexpected error with the latest version e.g. regression by a new feature, remove a deprecated parameter, change library dependency, etc. To avoid these problems, we recommend fixing fluentd and plugin version on production. If you want to update fluentd or plugins, check the behavior first on your test environment. For example, td-agent fixes fluentd and plugins version in each release.

Fluentd plugins are RubyGems and RubyGems installs the latest version by default. So we don't recommend to execute following commands on production:

* `gem install fluentd`
* `gem install fluent-plugin-elasticsearch`
* `gem update # This is very dangerous. Update all existing gems`

You should specify the target version with `-v` option:

* `gem install fluentd -v 1.2.1`
* `gem install fluent-plugin-elasticsearch -v 2.10.3`

## `--gemfile` option

A Ruby application manages gem dependencies using Gemfile and [`Bundler`](http://bundler.io/). Fluentd's `--gemfile` option takes the same approach, and is useful for managing plugin versions separated from shared gems.

For example, if you have the following Gemfile at `/etc/fluent/Gemfile`:

```text
source 'https://rubygems.org'

gem 'fluentd', '1.2.1'
gem 'fluent-plugin-elasticsearch', '2.10.3'
```

You can pass this Gemfile to Fluentd via the `--gemfile` option:

```text
fluentd --gemfile /etc/fluent/Gemfile
```

When specifying the `--gemfile` option, Fluentd will try to install the listed gems using Bundler. Fluentd will only load the listed gems separated from shared gems, and will also prevent unexpected plugin updates.

If you update Fluentd's Ruby version, Bundler will reinstall the listed gems for the new Ruby version. This allows you to avoid the C extension API compatibility problem.

### For `td-agent`

We can manage Fluentd and its plugins based on Gemfile with `td-agent`.

Use the following drop-in file `/etc/systemd/system/td-agent.service.d/override.conf` for `td-agent` 3.1.1:

```text
[Service]
Environment='TD_AGENT_OPTIONS=--gemfile=/etc/td-agent/Gemfile --gem-path=/var/lib/td-agent/vendor/bundle'
ExecStart=
ExecStart=/opt/td-agent/embedded/bin/fluentd --log /var/log/td-agent/td-agent.log --daemon /var/run/td-agent/td-agent.pid $TD_AGENT_OPTIONS
```

We can also edit this file using the following command:

```text
$ sudo systemctl edit td-agent.service
```

And, then add `/etc/td-agent/Gemfile`:

```text
source "https://rubygems.org"
# You can use fixed version of Fluentd and its plugins
gem "fluentd", "1.2.1"
gem "fluent-plugin-elasticsearch", "2.4.0"
gem "fluent-plugin-kafka", "0.6.5"
gem "fluent-plugin-rewrite-tag-filter", "2.0.1"
gem "fluent-plugin-s3", "1.1.0"
gem "fluent-plugin-td", "1.0.0"
gem "fluent-plugin-td-monitoring", "0.2.3"
gem "fluent-plugin-webhdfs", "1.2.2"
# Add plugins you want to use
gem "fluent-plugin-geoip", "1.2.0"
```

Finally, restart `td-agent`:

```text
$ sudo systemctl restart td-agent.service
```

NOTE: With this approach, you will download all the gems listed in Gemfile even if `td-agent` includes them the first time.

## FAQ

### `fluent-gem list` shows multiple plugin versions. Which one is used?

The latest version is used. If command shows the following result:

```text
$ fluent-gem list
...skip...
fluent-plugin-record-modifier (2.0.1, 0.6.0, 0.5.0)
```

`2.0.1` version is used.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

