# How to Write Service Discovery Plugin

Fluentd supports [pluggable service discovery](../service_discovery/) which lets an output plugin resolve its destinations at run time. The plugin filenames prefixed `sd_` are registered as Service Discovery Plugins.

See [Plugin Base Class API](api-plugin-base.md) for details on the common APIs for all the plugin types.

Here is an example of a custom service discovery plugin that reads a list of servers from a plain text file, one `host:port` per line, and re-reads it on a timer. It takes a required parameter called `path`, which is the pathname of that file, and an optional `interval`.

```ruby
require 'fluent/plugin/service_discovery'
require 'fluent/plugin_helper'

module Fluent::Plugin
  class MyListServiceDiscovery < ServiceDiscovery
    include Fluent::PluginHelper::Mixin

    # Register MyListServiceDiscovery as 'my_list'.
    Fluent::Plugin.register_sd('my_list', self)

    helpers :timer

    config_param :path, :string
    config_param :interval, :time, default: 10

    def configure(conf)
      super

      unless File.readable?(@path)
        raise Fluent::ConfigError, "my_list: path=#{@path} is not readable"
      end

      @services = fetch_services
    end

    def start(queue)
      timer_execute(:sd_my_list, @interval) do
        refresh(queue)
      end

      super()
    end

    private

    # Reads one "host:port" per line. Blank lines and # comments are skipped.
    def fetch_services
      File.readlines(@path).filter_map do |line|
        line = line.sub(/#.*/, '').strip
        next if line.empty?

        host, port = line.split(':', 2)
        Service.new(:my_list, host, port.to_i, line, 60, false, nil, nil, nil)
      end
    end

    # Announces the additions before the removals, so that the owner plugin is
    # never left without a destination.
    def refresh(queue)
      services = begin
                   fetch_services
                 rescue => e
                   log.error "my_list: failed to read the list", path: @path, error: e
                   return
                 end

      (services - @services).each { |s| queue.push(ServiceDiscovery.service_in_msg(s)) }
      (@services - services).each { |s| queue.push(ServiceDiscovery.service_out_msg(s)) }
      @services = services
    end
  end
end
```

Save this as `sd_my_list.rb` in a loadable plugin path.

With `out_forward` output plugin:

```text
<match test>
  @type forward
  <service_discovery>
    @type my_list
    path /path/to/servers.txt
    interval 2
  </service_discovery>
</match>
```

`/path/to/servers.txt` holds one server per line:

```text
# host:port
127.0.0.1:24230
127.0.0.1:24231
```

`out_forward` picks up both of them at startup:

```text
adding forwarding server '127.0.0.1:24230' host="127.0.0.1" port=24230 weight=60
adding forwarding server '127.0.0.1:24231' host="127.0.0.1" port=24231 weight=60
```

Replacing the second line of the file with another server swaps the destination without a restart:

```text
Service in: name=127.0.0.1:24232 127.0.0.1:24232
Service out: name=127.0.0.1:24231 127.0.0.1:24231
```

`Fluent::Plugin::ServiceDiscovery` does not include the plugin helper mixin, so a plugin which needs a helper includes `Fluent::PluginHelper::Mixin` itself, as the example above does. The built-in [`sd_file`](https://github.com/fluent/fluentd/blob/master/lib/fluent/plugin/sd_file.rb) and [`sd_srv`](https://github.com/fluent/fluentd/blob/master/lib/fluent/plugin/sd_srv.rb) do the same.

## How To Use Service Discovery From Plugins

Service discovery plugins are designed to be used from output plugins. The service discovery plugin helper is there for this purpose:

```ruby
# in class definition
helpers :service_discovery

# in #configure
service_discovery_configure(:my_output_sd_watcher, static_default_service_directive: 'server')

# in #write, or wherever a destination is picked
service_discovery_select_service do |node|
  send_data(node, chunk)
end
```

The helper owns the lifecycle of the configured plugins. It creates one instance per `<service_discovery>` section, starts them with the queue they push their updates onto, keeps the current set of services, and shuts them down with the owner plugin.

See [Service Discovery Plugin Helper API](../plugin-helper-overview/api-plugin-helper-service_discovery.md) for details.

## Methods

`Fluent::Plugin::ServiceDiscovery` keeps the current destinations in `@services`, and gives the plugin two class methods to announce a change. A plugin implements `#configure` for the initial list, and `#start` for the updates.

#### `#configure(conf)`

It sets `@services` to the destinations the plugin knows at startup. The owner plugin reads them while it configures itself, so a destination missing here does not exist for the owner plugin until the plugin announces it later.

Raise `Fluent::ConfigError` here for anything the plugin cannot work with, so that a misconfiguration stops Fluentd at startup instead of showing up later as a lost destination.

#### `#start(queue)`

It starts watching wherever the plugin discovers destinations from. `queue` is a `Thread::Queue` owned by the owner plugin. A plugin which never changes its list, like [`sd_static`](https://github.com/fluent/fluentd/blob/master/lib/fluent/plugin/sd_static.rb), does not have to override this method.

The plugin schedules its own updates. The example above and `sd_srv` use the [timer plugin helper](../plugin-helper-overview/api-plugin-helper-timer.md), and `sd_file` watches the file with the [event loop plugin helper](../plugin-helper-overview/api-plugin-helper-event_loop.md).

#### `.service_in_msg(service)`

It builds the message which adds `service` to the destinations of the owner plugin.

#### `.service_out_msg(service)`

It builds the message which removes `service` from the destinations of the owner plugin. The built-in plugins push the additions before the removals, so that the owner plugin always has at least one destination left.

## Services

A destination is a `Fluent::Plugin::ServiceDiscovery::Service`, a `Struct` with these members in this order:

| Member | Description |
| :--- | :--- |
| `plugin_name` | The name of the plugin which found the service. The built-in plugins use `:static`, `:file` and `:srv`. |
| `host` | The IP address or the host name of the server. |
| `port` | The port number of the server. |
| `name` | The name of the server. The owner plugin uses it for logging, and `out_forward` also uses it to verify the certificate when `host` is an address. |
| `weight` | The load balancing weight. The built-in plugins default to `60`. |
| `standby` | `true` marks the server as a standby node. |
| `username` | The username for authentication. |
| `password` | The password for authentication. |
| `shared_key` | The shared key for the server. |

`#discovery_id` identifies a service, and it is built from every member. Two services which differ in any one of them, `weight` included, are different services, so a changed weight is announced as one removal and one addition of the same server.

## How The Services Reach The Owner Plugin

The service discovery plugin helper owns a manager which holds the plugins configured in the `<service_discovery>` sections. The manager builds the initial set of destinations from `#services` of every plugin, then polls the queue every 3 seconds by default and applies the messages it finds there. This is where the `Service in:` and `Service out:` log lines come from.

The manager skips the polling when every configured plugin is `static`, since a static list never changes. A plugin registered under any other name is polled.

The owner plugin may keep an object of its own per service instead of the struct. `out_forward` builds a node which owns the connection to the server, which is why `service_discovery_select_service` yields that node rather than the `Service`.

## Writing Tests

Fluentd does not provide a test driver for service discovery plugins, so tests instantiate the plugin and drive it directly. The tests of the built-in plugins do the same.

```ruby
# test/plugin/test_sd_my_list.rb

require 'test/unit'
require 'fileutils'
require 'timeout'
require 'fluent/test'
require 'fluent/test/helpers'

# Your own plugin
require 'fluent/plugin/sd_my_list'

class ServiceDiscoveryMyListTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  TMP_DIR = File.expand_path(File.dirname(__FILE__) + '/tmp/sd_my_list')
  LIST_PATH = File.join(TMP_DIR, 'list.txt')

  Service = Fluent::Plugin::ServiceDiscovery::Service

  def setup
    Fluent::Test.setup
    FileUtils.mkdir_p(TMP_DIR)
  end

  def teardown
    FileUtils.rm_rf(TMP_DIR)
  end

  def create_plugin(conf)
    sd = Fluent::Plugin::MyListServiceDiscovery.new
    sd.configure(config_element('service_discovery', '', conf))
    sd
  end

  sub_test_case 'configure' do
    test 'reads the list' do
      File.write(LIST_PATH, "# host:port\n127.0.0.1:24224\n")
      sd = create_plugin('path' => LIST_PATH)
      assert_equal([Service.new(:my_list, '127.0.0.1', 24224, '127.0.0.1:24224', 60, false, nil, nil, nil)], sd.services)
    end

    test 'raises ConfigError for an unreadable path' do
      assert_raise(Fluent::ConfigError) do
        create_plugin('path' => File.join(TMP_DIR, 'no-such-file'))
      end
    end
  end

  sub_test_case 'start' do
    test 'pushes the difference onto the queue' do
      File.write(LIST_PATH, "127.0.0.1:24224\n")
      sd = create_plugin('path' => LIST_PATH, 'interval' => '1')
      queue = []
      sd.start(queue)
      begin
        File.write(LIST_PATH, "127.0.0.1:24225\n")
        Timeout.timeout(10) { sleep 0.1 until queue.size >= 2 }
      ensure
        sd.stop; sd.shutdown; sd.close; sd.terminate
      end
      assert_equal([:service_in, :service_out], queue.map(&:type))
      assert_equal(24225, queue[0].service.port)
      assert_equal(24224, queue[1].service.port)
    end
  end
end
```

`config_element` comes from `Fluent::Test::Helpers`, which `fluent/test` does not load by itself. A plain `Array` works as the queue in tests, since the plugin only pushes onto it.

### Overview of Tests

Testing for service discovery plugins is mainly for:

* Validation of configuration \(i.e. `#configure`\)
* Validation of the services built from the configuration
* Validation of the messages pushed while the plugin is running

The lifecycle of the plugin in a test is:

1. Instantiate the plugin
2. Configure the plugin
3. Start the plugin with a queue, and run test code
4. Assert the services and the messages on the queue
5. Shut the plugin down

For:

* configuration tests, repeat steps \# 1-2
* full feature tests, repeat steps \# 1-5

See [Testing API for Plugins](plugin-test-code.md) for details.
