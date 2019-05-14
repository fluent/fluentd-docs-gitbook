# FAQ


## What version of Ruby does fluentd support?

Fluentd v1.0 works on Ruby 2.1 or later. See [v0.12 document](https://fluentd.gitbook.io/manual/v/0.12/)
for earlier versions.


### When will td-agent be released with Fluentd v1.0?

Use td-agent 3. It includes v1.0.


## What is the differences between v1.0 or v0.14?

No differences. v1.0 is built on top of v0.14. Use v1.0 for newer
installation. We use v1.0/v1.x on our document.


## Known Issue


### Zlib::DataError happens when Output plugin uses gzip compression

This is caused by thread handling mismatch between output thread and
gzip library. Output's retry mechanizm automatically recovers this
error.

We will fix this problem in fluentd v1.3


## Operations


### I have a weird timestamp value, what happened?

The timestamps of Fluentd and its logger libraries depend on your
system's clock. It's highly recommended that you set up NTP on your
nodes so that your clocks remain synced with the correct clocks.


### I installed td-agent and want to add custom plugins. How do I do it?

Use td-agent bundled gem. See [this section](/deployment/plugin-management.md)
for more information.


### How can I match (send) an event to multiple outputs?

You can use the `copy` [output plugin](/plugins/output/copy.md) to send the
same event to multiple output destinations.


### How can I use environment variables to configure parameters dynamically?

Use `"#{ENV['YOUR_ENV_VARIABLE']}"`. For example,

``` {.CodeRay}
some_field "#{ENV['FOO_HOME']}"
```

(Note that it must be double quotes and not single quotes)


### Fluentd raises an error for host:port. Why?

There are several reasons:

-   If you get `Address already in use` error, other process has already
    used `host:port`. Check port conflict between processes / plugins.
-   If you get `Permission denied` error, you try to use well-known
    port. Search `well-known port` for how to use well-known port. Use
    `capabilities` or something

If you get other errors, google it.


### I got "no patterns matched" in the log, why?

This means you emit the event but no `<match>` directive for emitted
event. For example, if you emit the event with `foo.bar` tag, you need
to define `<match>` for `foo.bar` tag like `<match foo.**>`.

See also: [Life of a Fluentd event](/overview/life-of-a-fluentd-event.md) or [Config File](/configuration/config-file.md)


### File buffer doesn't work properly, why?

`file` buffer has limitations. Check [`buf_file`
article](buf_file#limitation).


### I got enconding error inside plugin. How to fix it?

You may hit `"\xC3" from ASCII-8BIT to UTF-8"` like
`UndefinedConversionError` in the plugin. This error happens when string
encoding is set to `ASCII-8BIT` but actual content is `UTF-8`. Fluentd
and almost plugins treat the logs as a `ASCII-8BIT` by default but some
libraries assume the log encoding is `UTF-8`. This is why this error
happens.

There are several approaches to avoid this problem.

-   Set encoding correctly.
    -   `tail` input has encoding related parameters to change the log
        encoding
    -   Use `record_modifier` filter to change the encoding. See
        [fluent-plugin-record-modifier README](https://github.com/repeatedly/fluent-plugin-record-modifier#char_encoding)
-   Use `yajl` instead of `json` when error happens inside
    `JSON.parse/JSON.dump`


### Fluentd warns "Oj is not installed, and failing back to Yajl for json parser"

If you are using Alpine Linux, you need to install `ruby-bigdecimal` to
use Oj as the JSON parser. Please Execute the following command and see
if the warning still shows up.

``` {.CodeRay}
# apk add --update ruby-bigdecimal
```


## Plugin Development


### How do I develop a custom plugin?

Please refer to the [Plugin Development Guide](/developer/plugin-development.md).


## HOWTOs

### How can I parse `<my complex text log>`?

If you are willing to write Regexp, [fluentd-ui's in\_tail
editor](/deployment/fluentd-ui.md#intail-setting) or
[Fluentular](http://fluentular.herokuapp.com) is a great tool to verify
your Regexps.

If you do NOT want to write any Regexp, look at [the Grok parser](https://github.com/kiyoto/fluent-plugin-grok-parser).


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
