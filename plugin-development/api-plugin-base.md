# How to Write Base Plugin

All plugin types are subclasses of `Fluent::Plugin::Base` in Fluentd v1 or later. The `Base` class has some features and methods that provide the basic mechanism as plugins. This page shows these methods provided by `Fluent::Plugin::Base`, and other methods provided commonly in some type of plugins.

The methods listed below are considered as public methods, and will be maintained not to break compatibility. Other methods may be changed without compatibility consideration.

```ruby
require 'fluent/plugin/input' # This may be input, filter, output, parser, formatter, storage or buffer.

module Fluent::Plugin
  class MyExampleInput < Input
    # Plugins should be registered by calling `Fluent::Plugin.register_TYPE` method with name and `self`.
    # The first argument String is to identify the plugin in the configuration file.
    # The second argument is class of the plugin itself, `self` in most cases.
    Fluent::Plugin.register_input('my_example', self)

    desc 'The port number'
    # `config_param` Defines a parameter. You can refer the following parameter via @port instance variable.
    # Without `:default`, a parameter is required.
    config_param :port, :integer

    config_section :user, param_name: :users, multi: true, required: false do
      desc 'Username for authentication'
      config_param :username, :string
      desc 'Password for authentication'
      config_param :password, :string, secret: true
    end

    def configure(conf)
      super

      # If the configuration is invalid, raise `Fluent::ConfigError`.
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

## Class Methods

`Base` class provides methods to create configurable parameters for plugins. It also supports methods to provide system configurations to plugins.

### `.config_param(name, type = nil, **options, &block)`

Defines a parameter.

* `name`: the parameter name as a symbol
* `type`: the parameter type
* `options`: the options for the parameter
* `block`: if given, convert the value via the given block

For details on types and options, see [Types of Configuration Parameters](api-config-types.md).

Code Example:

```ruby
config_param :name, :string, default: 'John Doe', alias: :full_name

config_param :pattern do |value|
  Regexp.compile(value)
end

config_param :delimiter, default: "\t" do |value|
  case value
  when /SPACE/i then ' '
  when /COMMA/i then ','
  else "\t"
  end
end
```

### `.config_set_default(name, default_value)`

Sets the default value of the parameter specified by `name`. If the default value already exists, it raises `ArgumentError`.

* `name`: The name of the parameter.
* `default_value`: Default value of the parameter.

Code Example:

```ruby
# lib/fluent/plugin/buffer.rb
config_param :chunk_limit_size, :size, default: DEFAULT_CHUNK_LIMIT_SIZE

# lib/fluent/plugin/buf_file.rb
config_set_default :chunk_limit_size, DEFAULT_CHUNK_LIMIT_SIZE
```

### `.config_set_desc(name, description)`

Sets description of the parameter specified by `name`. If the description already exists, it raises `ArgumentError`. For internal use only! Use `desc` instead.

* `name`: The name of the parameter.
* `description`: Description of the parameter.

### `.desc(description)`

Sets description of the immediately following parameter.

* `description`: Description of the parameter.

Code Example:

```ruby
desc 'The username'
config_param :user, :string
```

### `.config_section(name, **options, &block)`

Defines a section to construct structured \(nested\) configuration.

* `name`: The name of the section.
* `options`:
  * `root`: If `true`, this section is the root section. For internal use only!
  * `param_name`: The section name.
  * `final`: If `true`, the subclass of this class cannot override this section.

    For example, the third0party plugins cannot override the buffer section.

  * `init`: If `true`, the parameters in this section must have default values.

    Not applicable to third-party plugins.

  * `required`: If `true`, the section is required. Fluentd will raise

    `Fluent::ConfigError` if the section is missing.

  * `multi`: If `true`, users can configure this section multiple times.
  * `alias`: Alias for this section.

Code Example:

```ruby
config_section :user, multi: true do
  config_param :name, :string
  config_param :password, :string, secret: true
end

# nested sections
config_section :child, :param_name: 'children', required: false, multi: true do
  config_param :name, :string
  config_param :power, :integer, default: nil
  config_section :item, multi: true do
    config_param :name, :string
    config_param :flavor, :string
  end
end
```

Configuration Example:

```text
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

### `.configured_in(section_name)`

Inherits section `section_name` defined in the super class.

* `section_name`: The section name as Symbol.

### `.system_config`

Returns `Fluent::SystemConfig` instance.

For more details, see [System Configuration](../deployment/system-config.md).

Code Example:

```ruby
def configure(conf)
  super

  root_dir = system_config.root_dir
end
```

### `.system_config_override(options = {})`

Overrides the system configuration.

This is for internal use and plugin testing.

For more details, see [System Configuration](../deployment/system-config.md).

* `options`: The system configuration as Hash.

Code Example:

```ruby
test 'plugin instance can overwrite system_config if needed' do
  plugin = ExampleInput.new
  plugin.configure(conf)
  # ...
  plugin.system_config_override('workers' => 3)
  # ...
end
```

## Instance Methods

### `#initialize`

Initializes the internal states \(instance variables\).

Call `super` if the plugin overrides this method.

Code Example:

```ruby
def initialize
  super

  @internal_counter = 0
  @in_memory_cache = nil
end
```

### `#configure(conf)`

The `conf` parameter is an instance of `Fluent::Config::Element`. Call `super` if the plugin overrides this method. Fluentd's Configurable module \(included in Base class\) will traverse `conf` object, and set values from configurations or default values into the instance variables in `super`. So, the instance variables or accessor methods are available after `super` in `#configure` method.

The code to configure the plugin should be after `super`.

Code Example:

```ruby
def configure(conf)
  super

  # cache_default_value is created/configured by config_param
  @in_memory_cache = Hash.new(@cache_default_value)
end
```

**NOTE**: The return value of this method will be ignored.

### `#log`

Returns `Fluent::Log` instance.

Log levels:

* `trace`
* `debug`
* `info`
* `warn`
* `error`
* `fatal`

For more details on Fluentd's logging mechanism, see [Logging](../deployment/logging.md).

Code Example:

```ruby
def start
  # ...
  log.info('This is info level log')

  # Evaluate only if log level is trace
  log.trace do
    # Heavy calculation to trace plugin behavior
    'This is trace level log'
  end
end
```

### `#has_router?`

Indicates whether the `#router` method exists or not. \(default: `false`\)

If the plugin uses `event_emitter` plugin helper, this method will return `true`.

**NOTE**: Input plugin enables `event_emitter` by default.

### `#start`

This method is automatically called when Fluentd starts after the configuration. Call `super` if the plugin overrides this method.

Creating/opening timers, threads, listening sockets, file handles and others should be done in this method after `super`. Many of these may be provided as plugin helpers. See API details of each plugin helper.

Code Example:

```ruby
def start
  super

  timer_execute(:my_example_timer, 30) do
    # Code that will be executed every 30 seconds
  end
end
```

### `#stop`

This method is automatically called first in the shutdown sequence of Fluentd. It should be used to manipulate flags to stop loops, e.g. network servers, gracefully. This method SHOULD NOT do anything that may raise errors.

Call `super` if the plugin overrides this method.

Code Example:

```ruby
def start
  super

  @my_thread_running = true
  @my_thread = thread_create(:example_code) do
    if @my_thread_running
      log.debug 'loop is running'
    end
  end
end

def stop
  @my_thread_running = false

  super
end
```

`super` should be called at last in methods of shutdown sequence: `stop`, `before_shutdown`, `shutdown`, `after_shutdown`, `close` and `terminate`.

### `#before_shutdown`

This method is automatically called after `#stop` and before `#shutdown`. It may be used to control the flushing of buffered events in the shutdown sequence.

Call `super` if the plugin overrides this method. The third-party plugins do not need to implement this method in most cases.

### `#shutdown`

This method is automatically called while shutting down. It may be used to close file handles, network connections, listening servers, and other resources that need cleanup. The event can be emitted in this method but not after this method is called.

Call `super` if the plugin overrides this method.

Code Example:

```ruby
def shutdown
  @server.close
  records = my_convert_method(@server.rest_data)
  records.each do |record|
    router.emit(@tag, Fluent::Engine.now, record)
  end

  super
end
```

### `#after_shutdown`

This method is automatically called after `#shutdown`. It is used to control the emitting of events in shutdown sequence.

Call `super` if the plugin overrides this method. Third-party plugins do not need to implement this method in most cases.

### `#close`

This method may be used to close those resources that cannot be closed in `#shutdown`.

Call `super` if the plugin overrides this method.

### `#terminate`

This method may be used to re-initialize the internal states for the reuse of plugin instances in tests, etc.

Call `super` if the plugin overrides this method.

## Methods for Input/Filter/Output

Following methods are available in the subclass of Input, Filter and Output:

### `.helpers(*symbols)`

Includes the features of the plugin helpers.

Code Example:

```ruby
module Fluent::Plugin
  class MyPlugin < Input
    Fluent::Plugin.register_input('my_plugin', self)

    # This call enables Timer and Storage plugin helpers
    helpers :timer, :storage

    # ...
  end
end
```

It is strongly recommended to call this method at the top of the plugin class definition \(just after calling `#register_`\) to show what plugin helpers this plugin uses explicitly.

### `#plugin_id`

Provides a unique ID string for the plugin instance. It might be specified by users in the configuration files, or generated automatically. The plugin must not expect any fixed formats for its return value.

### `#plugin_id_configured?`

Indicates whether `#plugin_id` is configured by users or not.

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

