# Using Plugin Helpers

Fluentd has plugin helpers which encapsulates and makes easy to
implement commonly implemented features in plugins such as timer,
threading, formatting, parsing, ensuring configuration syntax's backward
compatibility.


## How To Use

To use plugin helpers, it needs to call `helpers(*snake_case_symbols)`
method with snake case symbols.

```
helpers :timer, :storage, :compat_parameters
```

Then, `helpers` method will include `Timer`, `Storage`. and
`CompatParameters` plugin helpers.


## Built-in Plugin Helpers

-   [child\_process](/developer/api-plugin-helper-child_process.md)
-   [compat\_parameters](/developer/api-plugin-helper-compat_parameters.md)
-   [event\_emitter](/developer/api-plugin-helper-event_emitter.md)
-   [event\_loop](/developer/api-plugin-helper-event_loop.md)
-   [extract](/developer/api-plugin-helper-extract.md)
-   [formatter](/developer/api-plugin-helper-formatter.md)
-   [inject](/developer/api-plugin-helper-inject.md)
-   [parser](/developer/api-plugin-helper-parser.md)
-   [record\_accessor](/developer/api-plugin-helper-record_accessor.md)
-   [server](/developer/api-plugin-helper-server.md)
-   [socket](/developer/api-plugin-helper-socket.md)
-   [storage](/developer/api-plugin-helper-storage.md)
-   [thread](/developer/api-plugin-helper-thread.md)
-   [timer](/developer/api-plugin-helper-timer.md)
-   [http\_server](/developer/api-plugin-helper-http_server.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
