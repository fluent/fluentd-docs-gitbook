# Types of Configuration Parameters


## Common options

-   default: Specify default value for this parameter. If omit this
    option, this parameter is required. Fluentd will check this value on
    boot when this option is omitted.
-   secret: If true, mask this parameter when Fluentd dumps
    configuration.
-   alias: Alias of this parameter as symbol
-   deprecated: Specify deprecation warning message. If users use this
    parameter in their config, they will see deprecation warning on
    boot.
-   obsoleted: Specify obsolete error message. If users use this
    parameter in their config, Fluentd raises `Fluent::ConfigError` and
    stop.
-   skip\_accessor: If true, skip adding accessor to the plugin. Only
    for internal use.

[]{#:string}

## :string

Define a string parameter.

Code Example:

``` {.CodeRay}
config_param :name, :string, default: "John Doe", alias: :full_name
config_param :password, :string, secret: true

def configure(conf)
  super

  log.info(name: @name, password: @password)
end
```

Configuration Example:

``` {.CodeRay}
name John Titor
passowrd very-secret-password
```

[]{#:regexp}

## :regexp

Define a regexp parameter. Since v1.2.0.

Code Example:

``` {.CodeRay}
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

``` {.CodeRay}
pattern /^name_/
pattern ^name_    # Also support pattern without slashes
```

[]{#:integer}

## :integer

Define an integer parameter.

Code Example:

``` {.CodeRay}
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

``` {.CodeRay}
::text
num_children 10
```

[]{#:float}

## :float

Define a float parameter.

Code Example:

``` {.CodeRay}
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

``` {.CodeRay}
interval 1.5
```

[]{#:size}

## :size

Define a size parameter in bytes. Available suffixes are `k`, `m`, `g`,
`t` (ignore case).

Code Example:

``` {.CodeRay}
config_param :limit, :size

def do_something
  raise "overflow!" if @limit < current
  # ...
end
```

Configuration Example:

``` {.CodeRay}
limit 10  # 10 byte
limit 10k # 10240 byte
limit 10m # 10485760 byte
limit 10g # 10737418240 byte
limit 10t # 10995116277760 byte
```

Configuration Example:

``` {.CodeRay}
limit 10m
```

[]{#:time}

## :time

Define a length of time paramater. Available suffixes are `s`, `m`, `h`,
`d` (lower case only). If omit suffix, apply `to_f` to the value and
convert it to seconds.

Code Example:

``` {.CodeRay}
config_param :interval, :time

def start
  timer_execute(:in_example, @interval) do
    # do something periodically
  end
end
```

Configuration Example:

``` {.CodeRay}
::text
interval 0.5 # 0.5 seconds
interval 1s  # 1 second
interval 1m  # 1 minute = 60 seconds
interval 1h  # 1 hour = 3600 seconds
interval 1d  # 1 day = 86400 seconds
```

Configuration Example:

``` {.CodeRay}
interval 10m
```

[]{#:bool}

## :bool

Define a bool parameter.

Code Example:

``` {.CodeRay}
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

``` {.CodeRay}
deep_copy true
```

[]{#:enum}

## :enum

Define an enumeration type parameter.

Users can choose a value from the list. If user choose the value that
does not exist in the list, error will occur on boot.

-   Available options
    -   list: Available value list

Code Example:

``` {.CodeRay}
config_param :protocol_type, :enum, list: [:udp, :tcp], default: udp

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

``` {.CodeRay}
protocol_type tcp
```

[]{#:array}

## :array

Define an array type parameter.

Users can set array value to the parameter.

-   Available options
    -   value\_type: Define type of the value. Available type are
        `:string`, `:integer`, `:float`, `:size`, `:bool`, `:time`.

Code Example:

``` {.CodeRay}
config_param :users, :array, default: [], value_type: :string

def available_user?(user)
  @users.include?(user)
end
```

Configuration Example:

``` {.CodeRay}
users user1, user2, user3
users ["user1", "user2", "user3"] # written in JSON
```

These configuration will convert to:

``` {.CodeRay}
["user1", "user2", "user3"]
```

[]{#:hash}

## :hash

Define a hash type parameter.

-   Available options
    -   symbolize\_keys: If true, symbolize keys.
    -   value\_type: Define type of the value. Use same type with all
        values.

Code Example:

``` {.CodeRay}
config_param :key_values, :hash, default: {}, symbolize_keys: true, value_type: :string

def do_something
  value1 = @key_values[:key1]
  value2 = @key_values[:key2]
  # ...
end
```

Configuration Example:

``` {.CodeRay}
key_values {"key1": "value1", "key2": "value2"} # written in JSON
key_values key1:value1,key2:value2
```

These configurations will be converted to:

``` {.CodeRay}
{ key1: "value1", key2: "value2" }
```


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information,
please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud
Native Computing Foundation (CNCF)](https://cncf.io/). All components
are available under the Apache 2 License.
