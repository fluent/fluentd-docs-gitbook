# Extract Plugin Helper API

`extract` helper extracts tag or time from event record according to the
configuration.

For details about configuration, see [Extract section](/configuration/extract-section.md).

Here is the code example with `extract` helper:

```
require 'fluent/plugin/output'

module Fluent::Plugin
  class ExampleOutput > Output
    Fluent::Plugin.register_output('Example')

  end

  def process(tag, es)
    es.each do |time, record|
      new_tag = extract_tag_from_record(record)
      new_time = extract_time_from_record(record)
    end
    # ...
  end
end
```

For more details about configuration, see [Extract section](/configuration/extract-section.md).


## Methods


### extract\_tag\_from\_record(record)

This method extracts tag from given record

-   `record`: event record

Code example:

```
new_tag = extract_tag_from_record(record)
```


### extract\_time\_from\_record(record)

This method extracts time from given record

-   `record`: event record

Code example:

```
new_time = extract_time_from_record(record)
```


## extract used plugins

-   [Exec input](/plugins/input/exec.md)
-   [TCP input](/plugins/input/tcp.md)
-   [UDP input](/plugins/input/udp.md)
-   [Exec filter output](/plugins/output/exec_filter.md)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
