# FAQ

## Which version of Ruby does `fluentd` support?

Latest fluentd works on Ruby 3.2 or later.

Though the minimum required version is Ruby 3.2 or later, we recommend using `fluentd` with more
newer stable version.

## What is the difference between v1 or v0.14?

No difference. v1 is built on top of v0.14. Use v1 for a newer installation. We use v1 or v1.x on our document.

## Operations

### I have a weird timestamp value, what happened?

The timestamps of Fluentd and its logger libraries depend on your system's clock. It is highly recommended that you set up NTP on your nodes so that your clocks remain synced with the correct clocks.

### I installed `td-agent`/`fluent-package` and want to add custom plugins. How do I do it?

Use the bundled gem system. See [this section](../deployment/plugin-management.md) for more information.

### How can I match \(send\) an event to multiple outputs?

You can use the `copy` [output plugin](../output/copy.md) to send the same event to multiple output destinations.

### How can I use environment variables to configure parameters dynamically?

Use `"#{ENV['YOUR_ENV_VARIABLE']}"`. For example:

```text
some_field "#{ENV['FOO_HOME']}"
```

Note that it must be double quotes, not single quotes.

### Fluentd raises an error for `host:port`. Why?

There are several reasons:

* If you get `Address already in use` error, another process has already

  used `host:port`. Check port conflict between processes/plugins.

* If you get `Permission denied` error, you likely tried to use a well-known

  port without permission. Search `well-known ports` for how to use well-known ports.

  Use `capabilities` or something.

If you get other errors, Google it.

### fluentd raises `tzinfo` conflict error after installed plugins

Fluentd supports tzinfo v1.1 or later and recent td-agent / fluent-package / official images install tzinfo v2 by default. The problem is several plugins depend on ActiveSupport and ActiveSupport doesn't support tzinfo v2. To resolve this problem, there are 2 approaches.

* Uninstall tzinfo v2 and install tzinfo v1.1 manually
* Update plugin to remove ActiveSupport dependency. ActiveSupport is mainly for Ruby on Rails,

  so using ActiveSupport for several convenient methods is overengineering.

Former is easier approach.

### I got `no patterns matched` in the log, why?

This means that the event is emitted but there is no `<match>` directive for it. For example, if you emit the event with `foo.bar` tag, you need to define `<match>` for `foo.bar` tag like `<match foo.**>`.

See also: [Lifecycle of a Fluentd event](life-of-a-fluentd-event.md) or [Config File](../configuration/config-file.md)

### File buffer does not work properly, why?

`file` buffer has limitations. Check [`buf_file` article](../buffer/file.md#limitation).

### I got encoding error inside the plugin. How to fix it?

You may hit `"\xC3" from ASCII-8BIT to UTF-8` like `UndefinedConversionError` in the plugin. This error happens when string encoding is set to `ASCII-8BIT` but the actual content is `UTF-8`. Fluentd and all its plugins treat the logs as `ASCII-8BIT` by default but some libraries assume that the log encoding is `UTF-8`. This is why this error occurs.

There are several approaches to avoid this problem:

* Set encoding correctly:
  * The `tail` input plugin has encoding related parameters to change the

    log encoding.

  * Use `record_modifier` filter plugin to change the encoding. See

    [fluent-plugin-record-modifier README](https://github.com/repeatedly/fluent-plugin-record-modifier#char_encoding).
* Use `yajl`\(`Yajl.load`/`Yajl.dump`\) instead of `json` when error happens

  inside `JSON.parse`/`JSON.dump`/`to_json`.

### Fluentd warns `Oj is not installed, and falling back to Yajl for json parser`.

If you are using Alpine Linux, you need to install `ruby-bigdecimal` to use `Oj` as the JSON parser. Please Execute the following command to see if the warning persists:

```text
# apk add --update ruby-bigdecimal
```

## Plugin Development

### How do I develop a custom plugin?

Please refer to the [Plugin Development Guide](../plugin-development/).

## HOWTOs

### How can I parse `<my complex text log>`?

If you are willing to write Regexp, [fluentd-ui's `in_tail` editor](../deployment/fluentd-ui.md#in_tail-setting) or [Fluentular](http://fluentular.herokuapp.com) is a great tool to verify your Regexps.

If you do NOT want to write any Regexp, look at [the Grok parser](https://github.com/kiyoto/fluent-plugin-grok-parser).

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under [the Apache License 2.0.](https://www.apache.org/licenses/LICENSE-2.0)

