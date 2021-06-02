# Plugin Helper API

Fluentd provides plugin helpers to encapsulate and make commonly implemented features available such as timer, threading, formatting, parsing, ensuring configuration syntax's backward compatibility, etc.

## How To Use

To use plugin helpers, call `helpers(*snake_case_symbols)` method to make them available.

Example:

```ruby
helpers :timer, :storage, :compat_parameters
```

It will include `Timer`, `Storage`. and `CompatParameters` plugin helpers.

## Built-in Plugin Helpers

* [`child_process`](api-plugin-helper-child_process.md)
* [`compat_parameters`](api-plugin-helper-compat_parameters.md)
* [`event_emitter`](api-plugin-helper-event_emitter.md)
* [`event_loop`](api-plugin-helper-event_loop.md)
* [`extract`](api-plugin-helper-extract.md)
* [`formatter`](api-plugin-helper-formatter.md)
* [`inject`](api-plugin-helper-inject.md)
* [`parser`](api-plugin-helper-parser.md)
* [`record_accessor`](api-plugin-helper-record_accessor.md)
* [`server`](api-plugin-helper-server.md)
* [`socket`](api-plugin-helper-socket.md)
* [`storage`](api-plugin-helper-storage.md)
* [`thread`](api-plugin-helper-thread.md)
* [`timer`](api-plugin-helper-timer.md)
* [`http_server`](api-plugin-helper-http_server.md)

{% include "../.gitbook/assets/footer.txt" %}
