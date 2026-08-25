# object\_space

The `in_object_space` Input plugin periodically emits the number of the live objects of the running Fluentd process, counted by class with [`ObjectSpace.each_object`](https://docs.ruby-lang.org/en/master/ObjectSpace.html#method-c-each_object).

It is included in Fluentd's core.

{% hint style='danger' %}
This plugin is a diagnostic tool to investigate a problem of Fluentd itself, such as a memory leak. Do not configure it in a production environment. Every emit walks all the objects in the heap, and the cost of the walk grows with the number of the objects. Enable it only while you are collecting the data for a specific investigation, and remove it once the investigation is done.
{% endhint %}

## Example Configuration

```text
<source>
  @type object_space
  tag object_space
  emit_interval 10
</source>

<match object_space>
  @type stdout
</match>
```

Refer to the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

## Plugin Helpers

* [`timer`](../plugin-helper-overview/api-plugin-helper-timer.md)

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

### `@type` \(required\)

The value must be `object_space`.

### `tag` \(required\)

| type | default | version |
| :--- | :--- | :--- |
| string | nil | 0.10.16 |

The tag assigned to the emitted events.

### `emit_interval`

| type | default | version |
| :--- | :--- | :--- |
| time | 60 | 0.10.16 |

The interval between the emits.

### `top`

| type | default | version |
| :--- | :--- | :--- |
| integer | 15 | 0.10.16 |

The number of the classes in a record. The classes are sorted by the number of their objects in descending order, and the first `top` classes are emitted.

## Output Example

With the example configuration above, the events look like this:

```text
2026-08-25 11:55:18.343433810 +0900 object_space: {"String":47477,"Array":16943,"Class":2246,"Hash":1612,"Gem::Requirement":1261,"Regexp":674,"Gem::Dependency":591,"Gem::Version":393,"Module":392,"Proc":347,"Time":302,"Gem::Specification":297,"Gem::StubSpecification::StubLine":297,"Gem::StubSpecification":297,"Fluent::Config::ConfigureProxy":128}
```

The key is the name of the class and the value is the number of its live objects.

Since a record has only the top classes, its keys are not stable. A class disappears from the record once another class has more objects than it.

## Multi-Process Environment

If you use this plugin under the multi-process environment, each worker emits the numbers of its own process. Since the record itself has no field to tell the workers apart, embed `worker_id` in the tag:

```text
<source>
  @type object_space
  tag "object_space.#{worker_id}"
</source>
```

See [config article](../configuration/config-file.md#embedded-ruby-code) for the embedded Ruby code.

## Learn More

* [Input Plugin Overview](./)
