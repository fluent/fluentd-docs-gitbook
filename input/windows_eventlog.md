# windows\_eventlog

The `in_windows_eventlog` Input plugin allows Fluentd to read events from the Windows Event Log.

## Installation

`in_windows_eventlog` is included in `td-agent` 3 MSI by default. Fluentd gem users will need to install the `fluent-plugin-windows-eventlog` gem using the following command:

```text
$ fluent-gem install fluent-plugin-windows-eventlog
```

## Example Configuration

```text
<source>
  @type windows_eventlog
  @id windows_eventlog
  channels application,system,security
  tag winevt.raw
  <storage>
    @type local
    persistent true
    path C:\opt\td-agent\winevt.pos
  </storage>
</source>
```

Refer to the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

### Event Example

`in_windows_eventlog` sets the corresponding channel to the `channel` field.

Here are some generated events:

```text
# system
{"channel":"system","record_number":"40432","time_generated":"2017-03-07 09:15:39 +0000","time_written":"2017-03-07 09:15:39 +0000","event_id":"7036","event_type":"information","event_category":"0","source_name":"Service Control Manager","computer_name":"WIN-7IMHK7EQ5T3","user":"","description":"The Windows Installer service entered the stopped state.\r\n"}
# security
{"channel":"security","record_number":"26735","time_generated":"2017-03-07 09:14:43 +0000","time_written":"2017-03-07 09:14:43 +0000","event_id":"4726","event_type":"audit_success","event_category":"13824","source_name":"Microsoft-Windows-Security-Auditing","computer_name":"WIN-7IMHK7EQ5T3","user":"","description":"A user account was deleted.\r\n\r\nSubject:\r\n\tSecurity ID:\t\tS-1-5-21-1367273608-854253166-2945741587-500\r\n\tAccount Name:\t\tAdministrator\r\n\tAccount Domain:\t\tWIN-7IMHK7EQ5T3\r\n\tLogon ID:\t\t0x39e29\r\n\r\nTarget Account:\r\n\tSecurity ID:\t\tS-1-5-21-1367273608-854253166-2945741587-1004\r\n\tAccount Name:\t\tabc\r\n\tAccount Domain:\t\tWIN-7IMHK7EQ5T3\r\n\r\nAdditional Information:\r\n\tPrivileges\t-\r\n"}
```

## Plugin Helpers

* [`timer`](../plugin-helper-overview/api-plugin-helper-timer.md)
* [`storage`](../plugin-helper-overview/api-plugin-helper-storage.md)

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

### `@type` \(required\)

The value must be `windows_eventlog`.

### `tag` \(required\)

The tag of the event.

### `channels`

The event log channels to read.

Multiple channels can be specified, separated by comma `,` or array type:

```text
# , separated
channels application,system,security

# array
channels ["application", "system", "security"]
```

Default: `["application"]`

### `read_interval`

The interval of reading the Windows Event log.

Default: `2` seconds

### `<storage>`

`<storage>` section is the configuration for storage plugin. `in_windows_eventlog` plugin uses storage plugin for recording the position it last read from.

By default, the local file is used. If you want to use on memory storage, set `persistent false`.

```text
<storage>
  persistent false
</storage>
```

If you set `root_dir` in `<section>` and set `@id` in the plugin configuration, the `path` parameter is automatically generated. If not, you need to set `path` in `<storage>` section.

```text
<storage>
  persistent true
  path C:\opt\td-agent\winevt.pos # This is required when persistent is true.
                                  # Or, use <system> section's root_dir parameter.      
</storage>
```

## Learn More

* [Input Plugin Overview](./)

## FAQ

### `in_windows_eventlog` can't read `setup` or `security` events, why?

You need administrator privileges to read these channels. Launch `fluentd`/`td-agent` as an administrator.

## Further Reading

This page does not describe all the possible configurations. If you want to know about other configurations, please check the link below:

* [`fluent-plugin-windows-eventlog`](https://github.com/fluent/fluent-plugin-windows-eventlog)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

