# FAQ


## Which version of Ruby does fluentd support?

Latest fluentd works on Ruby 2.4 or later.

If you want to run fluentd on ruby 2.3 or earlier, use fluentd 1.8 or earlier versions.


## When will td-agent be released with Fluentd v1?

Use td-agent 3. It includes v1.


## What is the difference between v1 or v0.14?

No difference. v1 is built on top of v0.14. Use v1 for newer
installation. We use v1 or v1.x on our document.


## Known Issue


### `Zlib::DataError` happens when Output plugin uses gzip compression

This is caused by thread handling mismatch between output thread and
gzip library. Output plugin's retry mechanism automatically recovers this
error.

Fluentd v1.3 has already fixed this problem.


## Operations


### I have a weird timestamp value, what happened?

The timestamps of Fluentd and its logger libraries depend on your
system's clock. It is highly recommended that you set up NTP on your
nodes so that your clocks remain synced with the correct clocks.


### I installed td-agent and want to add custom plugins. How do I do it?

Use td-agent bundled gem. See [this section](/deployment/plugin-management.md)
for more information.


### How can I match (send) an event to multiple outputs?

You can use the `copy` [output plugin](/plugins/output/copy.md) to send the
same event to multiple output destinations.


### How can I use environment variables to configure parameters dynamically?

Use `"#{ENV['YOUR_ENV_VARIABLE']}"`. For example:

```
some_field "#{ENV['FOO_HOME']}"
```

Note that it must be double quotes, not single quotes.


### Fluentd raises an error for `host:port`. Why?

There are several reasons:

-   If you get `Address already in use` error, other process has already
    used `host:port`. Check port conflict between processes/plugins.
-   If you get `Permission denied` error, you try to use a well-known
    port. Search `well-known ports` for how to use well-known ports. Use
    `capabilities` or something.

If you get other errors, google it!


### I got "`no patterns matched`" in the log, why?

This means you emit the event but there is no `<match>` directive for the
emitted event. For example, if you emit the event with `foo.bar` tag, you need
to define `<match>` for `foo.bar` tag like `<match foo.**>`.

See also: [Lifecycle of a Fluentd event](/overview/life-of-a-fluentd-event.md) or [Config File](/configuration/config-file.md)


### File buffer does not work properly, why?

`file` buffer has limitations. Check [buf_file article](/plugins/buffer/file.md#limitation).


### I got encoding error inside plugin. How to fix it?

You may hit `"\xC3" from ASCII-8BIT to UTF-8` like `UndefinedConversionError` in
the plugin. This error happens when the character encoding is set to
`ASCII-8BIT` but actual content is `UTF-8`. Fluentd and almost plugins treat the
logs as a `ASCII-8BIT` by default but some libraries assume the log encoding is
`UTF-8`. This is why this error happens.

There are several approaches to avoid this problem:

-   Set encoding correctly:
    -   The `tail` input plugin provides encoding related parameters to change
        the log encoding.
    -   Use `record_modifier` filter plugin to change the encoding. See
        [`fluent-plugin-record-modifier`](https://github.com/repeatedly/fluent-plugin-record-modifier#char_encoding)
-   Use `yajl`(`Yajl.load`/`Yajl.dump`) instead of `json` when error happens
    inside `JSON.parse`/`JSON.dump`/`to_json`.


### Fluentd warns "`Oj is not installed, and falling back to Yajl for json parser`".

If you are using Alpine Linux, you need to install `ruby-bigdecimal` to use `Oj`
as the JSON parser. Execute the following command to see if the warning still
shows up:

```
# apk add --update ruby-bigdecimal
```


## Plugin Development


### How do I develop a custom plugin?

Please refer to the [Plugin Development Guide](/developer/plugin-development.md).


## How-Tos


### How can I parse `<my complex text log>`?

If you are willing to write Regexp, [fluentd-ui's `in_tail`
editor](/deployment/fluentd-ui.md#in_tail-setting) or
[Fluentular](http://fluentular.herokuapp.com) is a great tool to verify your
Regexps.

If you do NOT want to write any Regexp, look at [the Grok parser](https://github.com/kiyoto/fluent-plugin-grok-parser).


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
