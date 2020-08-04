# Using Plugin Helpers

Fluentd provides plugin helpers to encapsulate and make commonly implemented
features available such as timer, threading, formatting, parsing, ensuring
configuration syntax's backward compatibility, etc.


## How To Use

To use plugin helpers, call `helpers(*snake_case_symbols)` method to make them
available.

Example:

```rb
helpers :timer, :storage, :compat_parameters
```

It will include `Timer`, `Storage`. and `CompatParameters` plugin helpers.


## Built-in Plugin Helpers

-   [`child_process`](/developer/api-plugin-helper-child_process.md)
-   [`compat_parameters`](/developer/api-plugin-helper-compat_parameters.md)
-   [`event_emitter`](/developer/api-plugin-helper-event_emitter.md)
-   [`event_loop`](/developer/api-plugin-helper-event_loop.md)
-   [`extract`](/developer/api-plugin-helper-extract.md)
-   [`formatter`](/developer/api-plugin-helper-formatter.md)
-   [`inject`](/developer/api-plugin-helper-inject.md)
-   [`parser`](/developer/api-plugin-helper-parser.md)
-   [`record_accessor`](/developer/api-plugin-helper-record_accessor.md)
-   [`server`](/developer/api-plugin-helper-server.md)
-   [`socket`](/developer/api-plugin-helper-socket.md)
-   [`storage`](/developer/api-plugin-helper-storage.md)
-   [`thread`](/developer/api-plugin-helper-thread.md)
-   [`timer`](/developer/api-plugin-helper-timer.md)
-   [`http_server`](/developer/api-plugin-helper-http_server.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please
[let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is an open-source project under
[Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are
available under the Apache 2 License.