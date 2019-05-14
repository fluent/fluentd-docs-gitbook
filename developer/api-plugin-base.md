# Plugin Base API

All plugin types are subclass of `Fluent::Plugin::Base` in Fluentd v0.14
or later. Base class has some features and methods which provides basic
mechanism as plugins. This page shows these methods provided by
`Fluent::Plugin::Base`, and other methods provided commonly in some type
of plugins.

The methods listed below are considered as public methods, and will be
maintained not to break compatibility. Other methods may be changed
without compatibility consideration.

``` {.CodeRay}
require 'fluent/plugin/input' # this might be input, filter, output, parser, formatter, storage or buffer

module Fluent::Plugin
  class MyExampleInput < Input
    # Plugins should be registered by calling ``Fluent::Plugin.register_TYPE`` method with name and ``self``.
    # The first argument String is to identify that plugin in configuration files.
    # The second argument is class of plugin itself, ``self`` in most cases.
    Fluent::Plugin.register_output('my_example', self)

    desc "The port number"
    # config_param defines a parameter. You can refer a parameter via @port instance variable.
    # Without :default, a parameter is required.
    config_param :port, :integer

    config_section :user, param_name: :users, multi: true, required: false do
      desc "Username for authentication"
      config_param :username, :string
      desc "Password for authentication"
      config_param :password, :string, secret: true
    end

    def configure(conf)
      super

      # If the configuration is invalid, raise Fluent::ConfigError.
      if @port <= 1024
        raise Fluent::ConfigError, "port number is too small: #{@port}"
      end

      @users.each do |user|
        if user.password.length < 5
          raise Fluent::ConfigError, "password is too short for user '#{user.username}'"
        end
      end
    end

    def start
      super
      # ...
    end

    def shutdown
      # ...
      super
    end
  end
end
```


## Class methods

Base class has some methods to create configurable parameters for
plugins, or to provide system configurations to plugins.

#### .config\_param(name, type = nil, \*\*options, &block)

Define a parameter.

-   `name`: parameter name as symbol
-   `type`: parameter type
-   `options`: options for parameter
-   `block`: if block is given, convert value via given block

About types and options, see [Types of Configuration Parameters](/articles/api-config-types.md).

Code Example:

``` {.CodeRay}
config_param :name, :string, default: "John Doe", alias: :full_name

config_param :pattern, do |value|
  Regexp.compile(value)
end

config_param :delimiter, default: "\t" do |value|
  case value
  when /SPACE/i then " "
  when /COMMA/i then ","
  else "\t"
  end
end
```

#### .config\_set\_default(name, default\_value)

Set default value to `name`. If the default value has already been
existed, raise `ArgumentError`.

-   `name`: The name of parameter
-   `default_value`: Default value for the parameter

Code Example:

``` {.CodeRay}
# lib/fluent/plugin/buffer.rb
config_param :chunk_limit_size, :size, default: DEFAULT_CHUNK_LIMIT_SIZE

# lib/fluent/plugin/buf_file.rb
config_set_default :chunk_limit_size, DEFAULT_CHUNK_LIMIT_SIZE
```

#### .config\_set\_desc(name, description)

Set description to `name`. If the description has already been existed,
raise `ArgumentError`. This is for internal API. Use `desc` instead.

-   `name`: The name of parameter
-   `description`: Description about the parameter

#### .desc(description)

Set description to immediately following parameter.

-   `description`: Description about the parameter

Code Example:

``` {.CodeRay}
desc "description about following parameter"
config_param :user, :string
```

#### .config\_section(name, \*\*options, &block)

Define a section to construct structured configuration.

-   `name`: The name of section
-   `options`
    -   `root`: If true, this section is root section. This is only for
        internal use.
    -   `param_name`: This section name
    -   `final`: If true, subclass of this class cannot overwrite this
        section. e.g. 3rd party plugins cannot overwrite buffer section
    -   `init`: If true, parameters in this section must have default
        value. 3rd party plugins don't have to be conscious about this
        option.
    -   `required`: If true, this section is required. Fluentd will
        raise `Fluent::ConfigError` when this section is missing in
        configuration.
    -   `multi`: If true, users can write this section in configuration.
    -   `alias`: Alias of this section

Code Example:

``` {.CodeRay}
config_section :user, multi: true do
  config_param :name, :string
  config_param :password, :string, secret: true
end

# nested sections
config_section :child, :param_name: "children", required: false, multi: true do
  config_param :name, :string
  config_param :power, :integer, default: nil
  config_section :item, multi: true do
    config_param :name, :string
    config_param :flavor, :string
  end
end
```

Configuration Example:

``` {.CodeRay}
<user>
  name Alice
  password very-secret-password
</user>

# nested sections
<child>
  name Bob
  power 1000
  <item>
    name potion
    flavor very sour orange
  </item>
  <item>
    name gumi
    flavor super delicious apple
  </item>
</child>
```

#### .configured\_in(section\_name)

Inherit section `section_name` defined in super class.

-   `section_name`: section name as Symbol

#### .system\_config

Returns `Fluent::SystemConfig` instance.

For more details, see [System Configuration](/deployment/system-config.md).

Code Example:

``` {.CodeRay}
def configure(conf)
  super
  root_dir = system_config.root_dir
end
```

#### .system\_config\_override(options = {})

Overwrite system config

This is for internal use and plugin testing.

For more details, see [System Configuration](/deployment/system-config.md).

-   `options`: system configuration as Hash

Code Example:

``` {.CodeRay}
test "plugin instance can overwrite system_config if needed" do
  plugin = ExampleInput.new
  plugin.configure(conf)
  # ...
  plugin.system_config_override("workers" => 3)
  # ...
end
```


## Instance methods

#### \#initialize

This method is used to initialize internal states (instance variables).
Call `super` if the plugin overrides this method.

Code Example:

``` {.CodeRay}
def initialize
  super
  @internal_counter = 0
  @in_memory_cache = nil
end
```

#### \#configure(conf)

`conf` is an instance of `Fluent::Config::Element`. Call `super` if the
plugin overrides this method. Fluentd's Configurable module (included in
Base class) will traverse `conf` object, and set values from
configurations or default values into instance variables in `super`. So
instance variables or accessor methods are available after `super` in
`#configure` method.

The code to configure the plugin by itself should be after `super`.

Code Example:

``` {.CodeRay}
def configure(conf)
  super

  # cache_default_value is created/configured by config_param
  @in_memory_cache = Hash.new(@cache_default_value)
end
```

The return value of this method will be ignored.

#### \#log

Returns `Fluent::Log` instance

-   Log levels:
    -   `trace`
    -   `debug`
    -   `info`
    -   `warn`
    -   `error`
    -   `fatal`

For more details about Fluentd's logging mechanism, see [Logging of Fluentd](/deployment/logging.md).

Code Example:

``` {.CodeRay}
def start
  ...
  log.info("This is info level log")
  # evaluate blog only when log level is trace
  log.trace do
    # heavy calculation to trace plugin behavior
    "This is trace level log"
  end
end
```

#### \#has\_router?

This method returns true or false, which indicates `#router` method is
provided or not. Default is false. If the plugin uses `event_emitter`
plugin helper, this method will return true.

Input plugin enables \`\`event\_emitter\`\` plugin helper in default.

#### \#start

This method is called when Fluentd starts, after all configuration
steps. Call `super` if the plugin overrides this method.

Creating/Opening timers, threads, listening sockets, file handles and
others should be done in this method after `super`. Many of these may be
provided as plugin helpers. See API details of each plugin helpers.

Code Example:

``` {.CodeRay}
def start
  super

  timer_execute(:my_example_timer, 30) do
    # any code which will be executed every 30 seconds
    # during Fluentd is running
  end
end
```

#### \#stop

This method is called at first in shutdown sequence of Fluentd. Call
`super` if the plugin overrides this method.

This method should be used to enable flag to stop loops, network servers
or something else, gracefully. This method SHOULD NOT do anything which
may raise errors.

Code Example:

``` {.CodeRay}
def start # example
  super
  @my_thread_running = true
  @my_thread = thread_create(:example_code) do
    if @my_thread_running
      log.debug "loop is running"
    end
  end
end
def stop
  @my_thread_running = false

  super
end
```

`super` should be called at last in methods of shutdown sequence:
`stop`, `before_shutdown`, `shutdown`, `after_shutdown`, `close` and
`terminate`.

#### \#before\_shutdown

This method is called after `#stop` and before `#shutdown`. Call `super`
if the plugin overrides this method. There are no need to implement this
method by 3rd party plugins in most cases. This method is used to
control flushing buffered events in shutdown sequence.

#### \#shutdown

This method is called when shutting down. Call `super` if the plugin
overrides this method.

The plugin should close file handles, network connections, listening
servers and other resources. The plugin can emit events in this method,
and cannot emit events after this method is called.

Code Example:

``` {.CodeRay}
def shutdown
  @server.close
  records = my_convert_method(@server.rest_data)
  records.each do |record|
    router.emit(@tag, Fluent::Engine.now, record)
  end

  super
end
```

#### \#after\_shutdown

This method is called after `#shutdown`. Call `super` if the plugin
overrides this method. There are no need to implement this method by 3rd
party plugins in most cases. This method is used to control emitting
events in shutdown sequence.

#### \#close

Call `super` if the plugin overrides this method. The plugin can use
this method to close resources which is used in plugins and cannot be
closed in `#shutdown`.

#### \#terminate

Call `super` if the plugin overrides this method. The plugin can use
this method to re-initialize internal states to make it possible to
reuse plugin instances in tests or others.


## Methods for Input/Filter/Output

The methods below are available in subclass of Input, Filter and Output.
Other types

#### .helpers(\*symbols)

The plugin can include features of plugin helpers by calling this method
with symbol arguments.

Code Example:

``` {.CodeRay}
module Fluent::Plugin
  class MyPlugin < Input
    Fluent::Plugin.register_input('my_plugin', self)

    # This call enables Timer and Storage plugin helpers
    helpers :timer, :storage

    # ...
  end
end
```

It is strongly recommended to call this method at the top of plugin
class definition (just after calling `#register_foo`) to show which
plugin helpers this plugin uses explicitly.

#### \#plugin\_id

This method provides an id string of plugin instance which is unique in
Fluentd process. It might be specified by users in configuration files,
or might be generated automatically. The plugin must not expect any
fixed formats for return values.

#### \#plugin\_id\_configured?

This method returns true or false to indicate `#plugin_id` is configured
by users or not.


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
