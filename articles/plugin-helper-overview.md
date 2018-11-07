# Using Plugin Helpers

Fluentd has plugin helpers which encapsulates and makes easy to
implement commonly implemented features in plugins such as timer,
threading, formatting, parsing, ensuring configuration syntax's backward
compatibility.


## How To Use

To use plugin helpers, it needs to call `helpers(*snake_case_symbols)`
method with snake case symbols.

``` {.CodeRay}
helpers :timer, :storage, :compat_parameters
```

Then, `helpers` method will include `Timer`, `Storage`. and
`CompatParameters` plugin helpers.


## Built-in Plugin Helpers

-   [child\_process](/articles/api-plugin-helper-child_process.md)
-   [compat\_parameters](/articles/api-plugin-helper-compat_parameters.md)
-   [event\_emitter](/articles/api-plugin-helper-event_emitter.md)
-   [event\_loop](/articles/api-plugin-helper-event_loop.md)
-   [extract](/articles/api-plugin-helper-extract.md)
-   [formatter](/articles/api-plugin-helper-formatter.md)
-   [inject](/articles/api-plugin-helper-inject.md)
-   [parser](/articles/api-plugin-helper-parser.md)
-   [record\_accessor](/articles/api-plugin-helper-record_accessor.md)
-   [server](/articles/api-plugin-helper-server.md)
-   [socket](/articles/api-plugin-helper-socket.md)
-   [storage](/articles/api-plugin-helper-storage.md)
-   [thread](/articles/api-plugin-helper-thread.md)
-   [timer](/articles/api-plugin-helper-timer.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
