# gc\_stat

The `in_gc_stat` Input plugin periodically emits the statistics of the Ruby garbage collector of the running Fluentd process. Each record is the value returned by [`GC.stat`](https://docs.ruby-lang.org/en/master/GC.html#method-c-stat).

It is included in Fluentd's core.

{% hint style='danger' %}
This plugin is a diagnostic tool to investigate a problem of Fluentd itself, such as a memory leak or an unexpected slowdown. Do not configure it in a production environment. Enable it only while you are collecting the data for a specific investigation, and remove it once the investigation is done.
{% endhint %}

## Example Configuration

```text
<source>
  @type gc_stat
  tag gc_stat
  emit_interval 10
</source>

<match gc_stat>
  @type stdout
</match>
```

Refer to the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

## Plugin Helpers

* [`timer`](../plugin-helper-overview/api-plugin-helper-timer.md)

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

### `@type` \(required\)

The value must be `gc_stat`.

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

### `use_symbol_keys`

| type | default | version |
| :--- | :--- | :--- |
| bool | true | 1.11.0 |

If `true`, the keys of the record are the symbols returned by `GC.stat`. If `false`, they are converted to strings.

The default value assumes that the events are sent to [`out_stdout`](../output/stdout.md), which serializes the symbols as strings anyway. Set this parameter to `false` when you send the events to another plugin, because a plugin which looks up a field by its name expects string keys. For example, the [`csv`](../formatter/csv.md) formatter emits empty values for `fields count` unless `use_symbol_keys false` is set.

## Output Example

With the example configuration above, the events look like this:

```text
2026-08-24 10:38:04.387923158 +0900 gc_stat: {"count":20,"time":38,"marking_time":28,"sweeping_time":9,"heap_allocated_pages":184,"heap_empty_pages":0,"heap_allocatable_slots":0,"heap_available_slots":170033,"heap_live_slots":128266,"heap_free_slots":41767,"heap_final_slots":0,"heap_marked_slots":118143,"heap_eden_pages":184,"total_allocated_pages":184,"total_freed_pages":0,"total_allocated_objects":414773,"total_freed_objects":286507,"malloc_increase_bytes":1117672,"malloc_increase_bytes_limit":16777216,"minor_gc_count":15,"major_gc_count":5,"compact_count":0,"read_barrier_faults":0,"total_moved_objects":0,"remembered_wb_unprotected_objects":0,"remembered_wb_unprotected_objects_limit":676,"old_objects":116402,"old_objects_limit":135202,"oldmalloc_increase_bytes":3586192,"oldmalloc_increase_bytes_limit":16777216}
```

The set of the keys depends on the Ruby version which runs Fluentd. See [`GC.stat`](https://docs.ruby-lang.org/en/master/GC.html#method-c-stat) for the meaning of each key.

## Multi-Process Environment

If you use this plugin under the multi-process environment, each worker emits the statistics of its own process. Since the record itself has no field to tell the workers apart, embed `worker_id` in the tag:

```text
<source>
  @type gc_stat
  tag "gc_stat.#{worker_id}"
</source>
```

See [config article](../configuration/config-file.md#embedded-ruby-code) for the embedded Ruby code.

## Learn More

* [Input Plugin Overview](./)
