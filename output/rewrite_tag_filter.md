# rewrite\_tag\_filter

The `out_rewrite_tag_filter` Output plugin provides a rule-based mechanism for rewriting tags.

## How It Works

The plugin is configured by defining a list of rules containing conditional statements and information on how to rewrite the matching tags.

When a message is handled by the plugin, the rules are tested one by one in order. If a matching rule is found, the message tag will be rewritten according to the definition in the rule and the message will be emitted again with the new tag.

### Example

#### Basic Example

This in an example of how to use this plugin to rewrite tags. In the example, records tagged with `app.component` will have their tag prefixed with the value of the key `message`:

```text
<match app.component>
  @type rewrite_tag_filter
  <rule>
    key message
    pattern /^\[(\w+)\]/
    tag $1.${tag}
  </rule>
</match>
```

Sample data:

```text
+------------------------------------------+        +------------------------------------------------+
| original record                          |        | rewritten tag record                           |
|------------------------------------------|        |------------------------------------------------|
| app.component {"message":"[info]: ..."}  | +----> | info.app.component {"message":"[info]: ..."}   |
| app.component {"message":"[warn]: ..."}  | +----> | warn.app.component {"message":"[warn]: ..."}   |
| app.component {"message":"[crit]: ..."}  | +----> | crit.app.component {"message":"[crit]: ..."}   |
| app.component {"message":"[alert]: ..."} | +----> | alert.app.component {"message":"[alert]: ..."} |
+------------------------------------------+        +------------------------------------------------+
```

#### Nested kubernetes namespace attributes based rules

This is an example of how to use this plugin to rewrite tags with nested attributes which are kubernetes metadata. In the example, records tagged with `kubernetes.information` will have their tag prefixed with the value of the nested key `kubernetes.namespace_name`.

**Dot notation**

```text
<match kubernetes.**>
  @type rewrite_tag_filter
  <rule>
    key $.kubernetes.namespace_name
    pattern ^(.+)$
    tag $1.${tag}
  </rule>
</match>
```

**Bracket notation**

```text
<match kubernetes.**>
  @type rewrite_tag_filter
  <rule>
    key $['kubernetes']['namespace_name']
    pattern ^(.+)$
    tag $1.${tag}
  </rule>
</match>
```

Sample data:

```text
+----------------------------------------------------------------------------------------+        +-------------------------------------------------------------------------------------------------------+
| original record                                                                        |        | rewritten tag record                                                                                  |
|----------------------------------------------------------------------------------------|        |-------------------------------------------------------------------------------------------------------|
| kubernetes.information {"kubernetes" : { "namespace_name": "kube-system" }, ... }      | +----> | kube-system.kubernetes.information {"kubernetes" : { "namespace_name": "kube-system" }, ... }         |
| kubernetes.information {"kubernetes" : { "namespace_name": "default" }, ... }          | +----> | default.kubernetes.information {"kubernetes" : { "namespace_name": "default" }, ... }                 |
| kubernetes.information {"kubernetes" : { "namespace_name": "kube-public" }, ... }      | +----> | kube-public.kubernetes.information {"kubernetes" : { "namespace_name": "kube-public" }, ... }         |
| kubernetes.information {"kubernetes" : { "namespace_name": "kube-node-lease" }, ... }  | +----> | kube-node-lease.kubernetes.information {"kubernetes" : { "namespace_name": "kube-node-lease" }, ... } |
+----------------------------------------------------------------------------------------+        +-------------------------------------------------------------------------------------------------------+
```

## Installation

`out_rewrite_tag_filter` is included in `td-agent` by default \(v3.0.1 or later\). Fluentd gem users will have to install the `fluent-plugin-rewrite-tag-filter` gem using the following command:

```text
$ fluent-gem install fluent-plugin-rewrite-tag-filter
```

For more details, see [Plugin Management](../deployment/plugin-management.md).

## Configuration Example

By design, the configuration drops some pattern records first and then it re-emits the next matched record as the new tag name. The example configuration shown below gives an example on how the plugin can be used to define a number of rules that examine values from different keys and sets the tag depending on the regular expression configured in each rule.

The tag value is later used to decide whether the log event shall be dropped or not.

```text
<match apache.access>
  @type rewrite_tag_filter
  capitalize_regex_backreference yes
  <rule>
    key     path
    pattern /\.(gif|jpe?g|png|pdf|zip)$/
    tag     clear
  </rule>
  <rule>
    key     status
    pattern /^200$/
    tag     clear
    invert  true
  </rule>
  <rule>
    key     domain
    pattern /^.+\.com$/
    tag     clear
    invert  true
  </rule>
  <rule>
    key     domain
    pattern /^maps\.example\.com$/
    tag     site.ExampleMaps
  </rule>
  <rule>
    key     domain
    pattern /^news\.example\.com$/
    tag     site.ExampleNews
  </rule>
  # it is also supported regexp back reference.
  <rule>
    key     domain
    pattern /^(mail)\.(example)\.com$/
    tag     site.$2$1
  </rule>
  <rule>
    key     domain
    pattern /.+/
    tag     site.unmatched
  </rule>
</match>

<match clear>
  @type null
</match>
```

Please see [`fluent-plugin-rewrite-tag-filter`](https://github.com/fluent/fluent-plugin-rewrite-tag-filter) for further details.

## Parameters

### `rewriteruleN`

This is obsoleted since 2.0.0. Use `<rule>` section.

### `capitalize_regex_backreference`

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 2.0.0 |

Capitalizes letter for every matched regex backreference. \(e.g. `maps -> Maps`\)

### `hostname_command`

| type | default | version |
| :--- | :--- | :--- |
| string | hostname | 2.0.0 |

Overrides hostname command for placeholder. \(The default is the long hostname.\)

### `<rule>` Section

It works in the order of appearance, regexp matching `rule/pattern` for the values of `rule/key` from each record, re-emits with `rule/tag`.

#### `key`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 2.0.0 |

The field name to which the regular expression is applied.

#### `pattern`

| type | default | version |
| :--- | :--- | :--- |
| regexp | required parameter | 2.1.0 |

The regular expression which is applied on the field value.

The type of pattern is string before 2.1.0.

#### `tag`

| type | default | version |
| :--- | :--- | :--- |
| string | required parameter | 2.0.0 |

New tag.

#### `invert**` \(bool\) \(optional\):

| type | default | version |
| :--- | :--- | :--- |
| bool | false | 2.0.0 |

If `true`, rewrite tag when unmatch pattern.

## Placeholders

The following variable can be used when specifying the name of the rewritten tag:

* `${tag}`
* `__TAG__`
* `${tag_parts[n]}`
* `__TAG_PARTS[n]__`
* `${hostname}`
* `__HOSTNAME__`

See more details at [`tag-placeholder`](https://github.com/fluent/fluent-plugin-rewrite-tag-filter#tag-placeholder).

## Use Cases

* Aggregate + display 404 status pages by URL and referrer to find and

  fix dead links.

* Send an IRC alert for 5xx status codes on exceeding thresholds.

#### Aggregate + display 404 status pages by URL and referrer to find and fix dead links.

* Collect access log from multiple application servers \(`config1`\)
* Sum up the 404 error and output to mongoDB \(`config2`\)

**IMPORTANT**

The plugins are required to be installed:

* `fluent-plugin-rewrite-tag-filter`
* `fluent-plugin-mongo`

**\[Config1\] Application Servers**

```text
# Input access log to fluentd with embedded in_tail plugin
<source>
  @type tail
  path /var/log/httpd/access_log
  <parse>
    @type apache2
    time_format %d/%b/%Y:%H:%M:%S %z
  </parse>
  tag apache.access
  pos_file /var/log/td-agent/apache_access.pos
</source>

# Forward to monitoring server
<match apache.access>
  @type forward
  flush_interval 5s
  <server>
    name server_name
    host 10.100.1.20
  </server>
</match>
```

**\[Config2\] Monitoring Server**

```text
# built-in TCP input
<source>
  @type forward
</source>

# Filter record like mod_rewrite with fluent-plugin-rewrite-tag-filter
<match apache.access>
  @type rewrite_tag_filter
  <rule>
    key     status
    pattern /^(?!404)$/
    tag     clear
  </rule>
  <rule>
    key     path
    pattern /.+/
    tag     mongo.apache.access.error404
  </rule>
</match>

# Store deadlinks log into mongoDB
<match mongo.apache.access.error404>
  @type        mongo
  host        10.100.1.30
  database    apache
  collection  deadlinks
  capped
  capped_size 50m
</match>

# Clear tag
<match clear>
  @type null
</match>
```

#### Send an IRC alert for 5xx status codes on exceeding thresholds.

* Collect access log from multiple application servers \(`config1`\)
* Sum up the 500 error and notify IRC and logging details to mongoDB

  \(`config2`\)

**IMPORTANT**

The plugins are required to be installed:

* `fluent-plugin-rewrite-tag-filter`
* `fluent-plugin-mongo`
* `fluent-plugin-datacounter`
* `fluent-plugin-notifier`
* `fluent-plugin-parser`
* `fluent-plugin-irc`

**\[Config1\] Application Servers**

```text
# Input access log to fluentd with embedded in_tail plugin
# sample results: {"host":"127.0.0.1","user":null,"method":"GET","path":"/","code":500,"size":5039,"referer":null,"agent":"Mozilla"}
<source>
  @type tail
  path /var/log/httpd/access_log
  <parse>
    @type apache2
    time_format %d/%b/%Y:%H:%M:%S %z
  </parse>
  tag apache.access
  pos_file /var/log/td-agent/apache_access.pos
</source>

# Forward to monitoring server
<match apache.access>
  @type forward
  flush_interval 5s
  <server>
    name server_name
    host 10.100.1.20
  </server>
</match>
```

**\[Config2\] Monitoring Server**

```text
# built-in TCP input
<source>
  @type forward
</source>

# Filter record like mod_rewrite with fluent-plugin-rewrite-tag-filter
<match apache.access>
  @type copy
  <store>
    @type rewrite_tag_filter
    # drop static image record and redirect as 'count.apache.access'
    <rule>
      key     path
      pattern /^\/(img|css|js|static|assets)\//
      tag     clear
    </rule>
    <rule>
      key     path
      pattern /.+/
      tag     count.apache.access
    </rule>
  </store>
  <store>
    @type rewrite_tag_filter
    <rule>
      key     code
      pattern /^5\d\d$/
      tag     mongo.apache.access.error5xx
    </rule>
  </store>
</match>

# Store 5xx error log into mongoDB
<match mongo.apache.access.error5xx>
  @type        mongo
  host        10.100.1.30
  database    apache
  collection  error_5xx
  capped
  capped_size 50m
</match>

# Count by status code
# sample results: {"unmatched_count":0,"unmatched_rate":0.0,"unmatched_percentage":0.0,"200_count":0,"200_rate":0.0,"200_percentage":0.0,"2xx_count":0,"2xx_rate":0.0,"2xx_percentage":0.0,"301_count":0,"301_rate":0.0,"301_percentage":0.0,"302_count":0,"302_rate":0.0,"302_percentage":0.0,"3xx_count":0,"3xx_rate":0.0,"3xx_percentage":0.0,"403_count":0,"403_rate":0.0,"403_percentage":0.0,"404_count":0,"404_rate":0.0,"404_percentage":0.0,"410_count":0,"410_rate":0.0,"410_percentage":0.0,"4xx_count":0,"4xx_rate":0.0,"4xx_percentage":0.0,"5xx_count":1,"5xx_rate":0.01,"5xx_percentage":100.0}

<match count.apache.access>
  @type datacounter
  unit minute
  outcast_unmatched false
  aggregate all
  tag threshold.apache.access
  count_key code
  pattern1 200 ^200$
  pattern2 2xx ^2\d\d$
  pattern3 301 ^301$
  pattern4 302 ^302$
  pattern5 3xx ^3\d\d$
  pattern6 403 ^403$
  pattern7 404 ^404$
  pattern8 410 ^410$
  pattern9 4xx ^4\d\d$
  pattern10 5xx ^5\d\d$
</match>

# Determine threshold
# sample results: {"pattern":"code_500","target_tag":"apache.access","target_key":"5xx_count","check_type":"numeric_upward","level":"warn","threshold":1.0,"value":1.0,"message_time":"2014-01-28 16:47:39 +0900"}

<match threshold.apache.access>
  @type notifier
  input_tag_remove_prefix threshold
  <def>
    pattern code_500
    check numeric_upward
    warn_threshold  10
    crit_threshold  40
    tag alert.http_5xx_error
    target_key_pattern ^5xx_count$
  </def>
</match>

# Generate message
# sample results: {"message":"HTTP Status warn [5xx_count] apache.access: 1.0 (threshold 1.0)"}
<match alert.http_5xx_error>
  @type deparser
  tag irc.http_5xx_error>
  format_key_names level,target_key,target_tag,value,threshold
  format HTTP Status %s [%s] %s: %s (threshold %s)
  key_name message
  reserve_data no
</match>

# Send IRC message
<match irc.http_5xx_error>
  @type irc
  host localhost
  port 6667
  channel fluentd
  nick fluentd
  user fluentd
  real fluentd
  message %s
  out_keys message
</match>

# Clear tag
<match clear>
  @type null
</match>
```

## FAQ

### With `rewrite-tag-filter`, logs are not forwarded. Why?

If you have the following configuration, it doesn't work:

```text
<match app.**>
  @type rewrite_tag_filter
  <rule>
    key     level
    pattern /(.+)/
    tag     app.$1
  </rule>
</match>

<match app.**>
  @type forward
  # ...
</match>
```

In this case, `rewrite_tag_filter` causes an infinite loop because the fluentd's routing is executed from top-to-bottom. So, you need to change the tag like this:

```text
<match app.**>
  @type rewrite_tag_filter
  <rule>
    key     level
    pattern /(.+)/
    tag     level.app.$1
  </rule>
</match>

<match level.app.**>
  @type forward
  # ...
</match>
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

