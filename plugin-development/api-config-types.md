# Configuration Parameter Types

## Types of Configuration Parameters

### Common Options

* `default`: Specifies the default value for a parameter. If omitted, the

  parameter is required. On startup, Fluentd uses the default value instead if

  the parameter is not configured.

```ruby
# Required parameter: The configuration must have this parameter like 'param1 10'.
config_param :param1, :integer

# Optional parameter: If the configuration doesn't have 'param2', 100 is used.
config_param :param2, :integer, default: 100
```

* `secret`: If `true`, the parameter will be masked when Fluentd dumps its

  configuration on the standard output on startup.

```ruby
config_param :secret_param, :string, secret: true
```

* `deprecated`: Specifies the deprecation warning message. If users use this

  parameter in the configuration, they will see the deprecation warning on

  startup.

```ruby
config_param :old_param, :string, deprecated: "Use new_param instead"
```

* `obsoleted`: Specifies the obsolete error message. If users use this parameter

  in the configuration, Fluentd raises `Fluent::ConfigError` and stops.

```ruby
config_param :dead_param, :string, obsoleted: "This parameter doesn't work anymore"
```

* `alias`: Alias for this parameter as a symbol.
* `skip_accessor`: If `true`, skip adding accessor to the plugin. For internal

  use only!

## Data Types

### `:string`

Defines a string parameter.

Code Example:

```ruby
config_param :name, :string, default: "John Doe", alias: :full_name
config_param :password, :string, secret: true

def configure(conf)
  super

  log.info(name: @name, password: @password)
end
```

Configuration Example:

```text
name John Titor
password very-secret-password
```

### `:regexp`

Defines a regexp parameter. Since v1.2.0.

Code Example:

```ruby
config_param :pattern, :regexp, default: /^key_/

def configure(conf)
  super

  log.info(pattern: @pattern)
end

def filter(tag, time, record)
  new_record = record.select do |k, v|
    @pattern.match(k)
  end
  new_record
end
```

Configuration Example:

```text
pattern /^name_/
pattern ^name_    # Also support pattern without slashes
```

### `:integer`

Defines an integer parameter.

Code Example:

```ruby
config_param :num_children, :integer, default: 1

def start
  super
  # ...
  @num_children.times do |n|
    # do something...
  end
end
```

Configuration Example:

```text
num_children 10
```

### `:float`

Defines a float parameter.

Code Example:

```ruby
helpers :timer
config_param :interval, :float, default: 0.5

def start
  super
  # ...
  timer_execute(:in_example, @interval) do
    # do something periodically
  end
end
```

Configuration Example:

```text
interval 1.5
```

### `:size`

Defines a size parameter in bytes.

Available suffixes: { `k`, `m`, `g`, `t` } \(ignore case\)

Code Example:

```ruby
config_param :limit, :size

def do_something
  raise "overflow!" if @limit < current
  # ...
end
```

Configuration Example:

```text
limit 10  # 10 byte
limit 10k # 10240 byte
limit 10m # 10485760 byte
limit 10g # 10737418240 byte
limit 10t # 10995116277760 byte
```

Configuration Example:

```text
limit 10m
```

### `:time`

Defines the length of the time parameter.

Available suffixes: { `s`, `m`, `h`, `d` } \(lower case only\).

If omitted, `to_f` is applied to the value which converts it to seconds.

Code Example:

```ruby
config_param :interval, :time

def start
  timer_execute(:in_example, @interval) do
    # do something periodically
  end
end
```

Configuration Example:

```text
interval 0.5 # 0.5 seconds
interval 1s  # 1 second
interval 1m  # 1 minute = 60 seconds
interval 1h  # 1 hour = 3600 seconds
interval 1d  # 1 day = 86400 seconds
```

Configuration Example:

```text
interval 10m
```

### `:bool`

Defines a Boolean parameter.

Code Example:

```ruby
config_param :deep_copy, :bool, default: false

def copy(object)
  if @deep_copy
    # deep copy
  else
    # shallow copy
  end
end
```

Configuration Example:

```text
deep_copy true
```

### `:enum`

Defines an enumerated parameter.

Users can choose a value from the list. If a non-listed value is chosen, an error occurs on startup.

* Available options
  * `list`: List of available values.

Code Example:

```ruby
config_param :protocol_type, :enum, list: [:udp, :tcp], default: :udp

def send
  case @protocol_type
  when :udp
    send_udp
  when :tcp
    send_tcp
  end
end
```

Configuration Example:

```text
protocol_type tcp
```

### `:array`

Defines an array parameter.

Users can set an array value for a parameter.

* Available options
  * `value_type`: Defines the type of the value.

    Available types: { `:string`, `:integer`, `:float`, `:size`, `:bool`, `:time` }

Code Example:

```ruby
config_param :users, :array, default: [], value_type: :string

def available_user?(user)
  @users.include?(user)
end
```

Configuration Example:

```text
users user1, user2, user3
users ["user1", "user2", "user3"] # written in JSON
```

This configuration will be converted to:

```ruby
["user1", "user2", "user3"]
```

### `:hash`

Defines a hash parameter.

* Available options
  * `symbolize_keys`: If `true`, the keys are symbolized.
  * `value_type`: Defines the same type for all values.

Code Example:

```ruby
config_param :key_values, :hash, default: {}, symbolize_keys: true, value_type: :string

def do_something
  value1 = @key_values[:key1]
  value2 = @key_values[:key2]
  # ...
end
```

Configuration Example:

```text
key_values {"key1": "value1", "key2": "value2"} # written in JSON
key_values key1:value1,key2:value2
```

This configurations will be converted to:

```ruby
{ key1: "value1", key2: "value2" }
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

