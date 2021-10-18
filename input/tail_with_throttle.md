# tail_with_throttle

![](../.gitbook/assets/tail.png)

The `in_tail_with_throttle` Input plugin allows Fluentd to read events from the tail of text files. Its behavior is similar to that of `in_tail` Input Plugin with the only difference being that this plugin rate limits the number of events read on the basis of groups.

## Example Configuration

```text
<source>
  @type tail_with_throttle
  path /var/log/*.log
  pos_file /var/log/temp.log.pos
  tag applogs
  <parse>
    @type apache2
  </parse>
  <group>
    pattern /(?<appname>[a-z0-9]([-a-z0-9]*[a-z0-9])?(\/[a-z0-9]([-a-z0-9]*[a-z0-9])?)*)_(?<namespace>[^_]+)_(?<container>.+)-(?<docker_id>[a-z0-9]{64})\.log$
    rate_period 30s
    <rule>
      namespace logging
      appname frontend
      limit 500
    </rule>
    <rule>
      namespace logging
      appname backend
      limit 1000
    </rule>
    <rule>
      limit 20
    </rule>
  </group>
</source>
```

Refer to the [Configuration File](../configuration/config-file.md) article for the basic structure and syntax of the configuration file.

For `<parse>`, see [Parse Section](../configuration/parse-section.md).

### How It Works

When Fluentd is configured with `in_tail_with_throttle`, it will form groups based on the rules provided in the configuration file. Based on group formation, log files will be assigned to a group and reading will start from the **tail** of that log, not the beginning. Group limits are equally distributed among the log files in a group. If the group line limit of the log is reached within rate_period time interval, Fluentd will stop reading logs. Once, **rate_period** (time) is over, Fluentd will reset its group counters and restart the reading process. 


## Plugin Helpers

* [`timer`](../plugin-helper-overview/api-plugin-helper-timer.md)
* [`event_loop`](../plugin-helper-overview/api-plugin-helper-event_loop.md)
* [`parser`](../plugin-helper-overview/api-plugin-helper-parser.md)
* [`compat_parameters`](../plugin-helper-overview/api-plugin-helper-compat_parameters.md)

See also: [Linux capability](../deployment/linux-capability.md)

## Parameters

See [Common Parameters](../configuration/plugin-common-parameters.md).

`in_tail_with_throttle` Input Plugin utilizes `in_tail` plugin's configuration. Refer to `in_tail` plugin's parameters [in_tail Parameters](./tail.md)

The additional parameter which `in_tail_with_throttle` uses is the `<group>` Directive.

### `<group>` Directive \(required\) 

Grouping rules for the log.

`in_tail_with_throttle` assigns each log file to a group based on the rules provided in **`<group>`** directive. The `limit` parameter controls the total number of lines collected for a group by `tail_with_throttle` Input Plugin.

Example: 

```text
# group rules
<group>
  rate_period 5s

  <rule>
    namespace shopping
    appname frontend
    limit 1000
  </rule>

  <rule>
    namespace payment
    appname backend
    limit 2000
  </rule>
</group>
```

#### `pattern`

| type | default | version |
| :--- | :--- | :--- |
| regexp | `/(?<appname>[a-z0-9]([-a-z0-9]*[a-z0-9])?(\/[a-z0-9]([-a-z0-9]*[a-z0-9])?)*)_(?<namespace>[^_]+)_(?<container>.+)-(?<docker_id>[a-z0-9]{64})\.log$`| 0.14.1 |

Specifies the regular expression for extracting metadata (namespace, appname) from log file path. Default value of the pattern regexp follows CRIO path format which gives information about `namespace`, `pod` (appname), `docker_id`, `container` of the log. 

Please add `namespace` and `appname` regex-groups in your custom regex pattern to extract metadata from filenames. If the pattern specified in the configuration fails to identify `namespace` and `appname` information, it will assign the log to the default group. 


#### `rate_period`

| type | default | version |
| :--- | :--- | :--- |
| time | 60 \(seconds\) | 0.14.1 |

Time period in which the group line limit is applied. `in_tail_with_throttle` resets the line collected counter after every `rate_period` interval.


### `<rule>` Directive \(required\)

Specifies the rules and limits for a group.


#### `namespace` 

| type | default | version |
| :--- | :--- | :--- |
| array | allow all files [\/.\/] | 0.14.1 |

Namespace criteria to form rules. This parameter internally converts each string element in the array to a regexp so it can be used to generalize a list of namespaces.

Examples:
- This rule will apply to all files which have **monitoring** as a substring in their namespace.

```text
<rule>
  namespace monitoring
</rule>
```

- You can also specify multiple namespaces in your configuration file.

```text
<rule>
  namespace monitoring, logging
</rule>
```
#### `appname`

| type | default | version |
| :--- | :--- | :--- |
| array | allow all files [\/.\/] | 0.14.1 |

Appname criteria to form rules. This parameter, like `namespace`, internally converts each string element in the array to a regexp so it can be used to generalize a list of appnames.

Examples:
- This rule will apply to all files which have **heavy-stress** as a substring in their appname.
```text
<rule>
  appname heavy-stress
</rule>
```

- You can also specify multiple appnames in your configuration files.

```text
<rule>
  appname heavy-stress, backend-payment
</rule>
```


#### `limit`

| type | default | version |
| :--- | :--- | :--- |
| integer | -1 | 0.14.1 |

Maximum number of lines allowed from a group in `rate_period` time interval. The default value of `-1` doesn't throttle log files of that group.


## Group Rules Example

### Generic Rules
This rule will assign files (that do not satisfy any rule) to a group limit of 100 lines.

Example - 

```text
  <rule>
    limit 100
  </rule>
```

### Context-Specifc Rules

#### Namespace based grouping

This configuration will limit all files that have substring as **monitoring** present in their namespace, and will not check for appname in the filename. 

```text
<rule>
  namespace monitoring
  limit 100
</rule>
```

#### Appname based grouping

Similarly, this configuration will limit all files containing 'frontend` substring present in their appname, and will not check for the namespace in the filename.

```text
<rule>
  appname frontend
  limit 200
</rule>
```

#### Namespace and Appname based grouping

Examples:

- This rule will limit all files which have `monitoring` substring and `frontend` substring in namespace and appname fields, respectively.

```text
  <rule>
    namespace monitoring
    appname frontend
    limit 50
  </rule>
```
- If we omit the `limit` parameter in a rule, then there will be no rate limiting applied to the files falling in that group. 

```text
  <rule>
    namespace monitoring
    appname frontend
  </rule>
```

- When using multiple namespaces and appnames in a single rule, the group line limits are distributed uniformly.


```text
<rule>
  namespace monitoring, logging
  appname frontend, backend
  limit 4000
</rule>
```

The list of groups formed from this rule are: 

|   Namespace  	|   Appname  	| Group Limit 	|
|:------------:	|:----------:	|:-----------:	|
| /monitoring/ 	| /frontend/ 	|     1000    	|
| /monitoring/ 	|  /backend/ 	|     1000    	|
|   /logging/  	| /frontend/ 	|     1000    	|
|   /logging/  	|  /backend/ 	|     1000    	|

## FAQ

### What happens when a file can be assigned to both, context-specific and generic rules? 

By default, context-specific rules always precede generic rule applied to default group. Hence the file will be assigned to context-specific rule.

### What happens when we have the same rule repeated in the configuration file? 

Example,

```text
  <rule>
    namespace monitoring 
    appname logger
    limit 100
  </rule>

  <rule>
    namespace monitoring
    appname logger
    limit 2000
  </rule>
```

In this case, limits are overridden by `in_tail_with_throttle` Input Plugin. So, the final limit of the group for namespace `monitoring` and appname `logger` will be 2000.

### Can we run `tail` and `tail_with_throttle` simultaneously ? 

Yes, we can run both input plugins simultaneously.