# How to Write Tests for Plugin

This article explains how to write Fluentd plugin test code using [`test-unit`](https://test-unit.github.io/).

You can write test code with any other testing framework such as `RSpec`, `minitest`, etc.

## Basics of Plugin Testing

Fluentd provides useful Test Drivers according to plugin type. We can write maintainable test code for plugins using them. We can write helper.rb for output plugin as follows:

```ruby
require "test-unit"
require "fluent/test"
require "fluent/test/driver/output"
require "fluent/test/helpers"

Test::Unit::TestCase.include(Fluent::Test::Helpers)
Test::Unit::TestCase.extend(Fluent::Test::Helpers)
```

Note that Fluentd provides useful Test Drivers for `input`, `output`, `filter`, `parser` and `formatter`.

The recommended fluentd plugin project structure is:

```text
.
├── Gemfile
├── LICENSE
├── README.md
├── Rakefile
├── fluent-plugin-<your_fluentd_plugin_name>.gemspec
├── lib
│   └── fluent
│       └── plugin
│           └── <plugin_type>_<your_fluentd_plugin_name>.rb
└── test
    ├── helper.rb
    └── plugin
        └── test_<plugin_type>_<your_fluentd_plugin_name>.rb
```

## Plugin Test Driver Overview

There are some useful Test Drivers for plugin testing. We can write test code for plugins as following:

```ruby
# Load the module that defines common initialization method (Required)
require 'fluent/test'
# Load the module that defines helper methods for testing (Required)
require 'fluent/test/helpers'
# Load the test driver (Required)
require 'fluent/test/driver/output'
# Load the plugin (Required)
require 'fluent/plugin/out_file'

class FileOutputTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  def setup
    Fluent::Test.setup   # Setup test for Fluentd (Required)
    # Setup test for plugin (Optional)
    # ...
  end

  def teardown
    # Terminate test for plugin (Optional)
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::FileOutput).configure(conf)
  end

  # Configuration related test group
  sub_test_case 'configuration' do
    test 'basic configuration' do
      d = create_driver(basic_configuration)
      assert_equal 'something', d.instance.parameter_name
    end
  end

  # Another test group goes here
  sub_test_case 'path' do
    test 'normal' do
      d = create_driver('...')
      d.run(default_tag: 'test') do
        d.feed(event_time, record)
      end
      events = d.events
      assert_equal(1, events.size)
    end
  end
end
```

## Testing Utility Methods

You can get a plugin instance by calling Test Driver instance's `#instance` method. If utility methods are `private`, use `__send__`.

```ruby
# ...
class FileOutputTest < Test::Unit::TestCase
  # ...
  # Group by utility method
  sub_test_case '#compression_suffix' do
    test 'returns empty string for nil (no compression method specified)' do
      d = create_driver
      assert_equal('', d.instance.compression_suffix(nil))
    end
  end
end
```

## Test Driver Base API

The methods in this section are available for all Test Driver.

### `initialize(klass, opts: {}, &block)`

Initializes Test Driver instance.

* `klass`: A class of Fluentd plugin
* `opts`: Overwrite system config. This parameter is useful for testing multi

  workers.

* `block`: Customize plugin behavior. We can overwrite plugin code in this

  block.

Example:

```ruby
def create_driver(conf={})
  d = Fluent::Test::Driver::Output.new(Fluent::Plugin::MyOutput) do
    attr_accessor :exceptions
    # Almost same as to reopen plugin class
    def prefer_buffered_processing
      false
    end
    def process(tag, es)
      # Drop events
    end
  end
  d.configure(conf)
end
```

### `configure(conf, syntax: :v1)`

Configures plugin instance managed by the Test Driver.

* `conf`: `Fluent::Config::Element` or `String`
* `syntax`: { `:v1`, `:v0`, `:ruby` } `:v0` is obsolete.

Example:

```ruby
def create_driver(conf={})
  Fluent::Test::Driver::Output.new(Fluent::Plugin::MyOutput).configure(conf)
end

def test_process
  conf = %[
    path /path/to/something
    host localhost
    port 24229
  ]
  d = create_driver(conf)
end
```

### `end_if(&block)`

Registers the conditions to stop the running Test Driver gracefully.

All registered conditions must be `true` before Test Driver stops.

### `break_if(&block)`

Registers the conditions to stop the running Test Driver.

Test Driver should stop running if some of the breaking conditions are `true`.

### `broken?`

Returns `true` when some of the breaking conditions are `true`. Otherwise `false`.

### `run(timeout: nil, start: true, shutdown: true, &block)`

Runs the Test Driver. This Test Driver will stop running immediately after evaluating the `block` if given.

Otherwise, you must register the conditions to stop the running Test Driver.

This method may be overridden in subclasses.

* `timeout`: timeout \(seconds\)
* `start`: if `true`, start the Test Driver. Otherwise, invoke `instance_start`

  method to start it.

* `shutdown`: if `true`, shut down the running Test Driver.

Example:

```ruby
# Run Test Driver and feed an event (output)
d = create_driver
d.run do
  d.feed(time, record)
end

# Emit multiple events (output)
d = create_driver

d.run(default_tag: 'test', expect_emits: 1, timeout: 10, start: true,  shutdown: false) { d.feed(time, { "k1" => 1 })}

d.run(default_tag: 'test', expect_emits: 1, timeout: 10, start: false, shutdown: false) { d.feed(time, { "k1" => 2 })}

d.run(default_tag: 'test', expect_emits: 1, timeout: 10, start: true,  shutdown: true ) { d.feed(time, { "k1" => 3 })}
```

### `stop?`

Returns `true` when all the stopping conditions are `true`. Otherwise `false`.

### `logs`

Returns logs managed by this Test Driver.

### `instance`

Returns the plugin instance managed by this Test Driver.

## Test Driver Base Owner API

* `filter`
* `output`
* `multi_output`

### `run(expect_emits: nil, expect_records: nil, timeout: nil, start: true, shutdown: true, &block)`

Run Test Driver. This Test Driver will stop running immediately after evaluating `block` if given.

Otherwise, you must register conditions to stop running Test Driver.

This method may be overridden in subclasses.

* `expect_emits`: set the number of expected emits
* `expect_records`: set the number of expected records
* `timeout`: timeout \(seconds\)
* `start`: if `true`, start the Test Driver. Otherwise, invoke the

  `instance_start` method to start it.

* `shutdown`: if `true`, shut down the running Test Driver.

Example:

```ruby
# Run Test Driver and feed an event (owner plugin)
d = create_driver
d.run do
  d.feed(time, record)
end

# Emit multiple events (owner plugin)
d = create_driver

d.run(default_tag: 'test', expect_emits: 1, timeout: 10, start: true,  shutdown: false) { d.feed(time, { "k1" => 1 })}

d.run(default_tag: 'test', expect_emits: 1, timeout: 10, start: false, shutdown: false) { d.feed(time, { "k1" => 2 })}

d.run(default_tag: 'test', expect_emits: 1, timeout: 10, start: true,  shutdown: true ) { d.feed(time, { "k1" => 3 })}
```

### `events(tag: nil)`

Returns the events filtered by the given tag.

* `tag`: filter by this tag. If omitted, it returns all the events.

### `event_streams(tag: nil)`

Returns the event streams filtered by the given tag.

* `tag`: filter by this tag. If omitted, it returns all the event streams.

### `emit_count`

Returns the number of invoking `router.emit`.

If you want to delay the stopping of the Test Driver until a certain number of records are emitted, you can use `d.run(expected_records: n)` instead.

Example:

```ruby
d.run do
  d.feed('test', record)
end
assert_equal(1, d.emit_count)
```

### `record_count`

Returns the number of records.

If you want to delay the stopping of the Test Driver until a certain number of records are emitted, you can use `d.run(expected_records: n)` instead.

### `error_events(tag: nil)`

Returns error events filtered by the given tag.

* `tag`: filter by this tag. If omitted, it returns all error events.

## Test Driver Base owned API

### `configure(conf, syntax: :v1)`

Configures plugin instance managed by this Test Driver.

* `conf`: `Fluent::Config::Element`, `String`, or `Hash`
* `syntax`: Supported: { `:v1`, `:v0`, `:ruby` } `:v0` is obsolete.

## Test Driver Event Feeder API

* `filter`
* `output`
* `multi_output`

### `run(default_tag: nil, **kwargs, &block)`

Runs `EventFeeder`.

* `default_tag`: the default tag of the event

Example:

```ruby
d.run(default_tag: 'test') do
  d.feed(event_time, { 'message' => 'Hello, Fluentd!' })
end
```

### `feed(tag, time, record)`

Feeds an event to plugin instance.

* `tag`: the tag of the event
* `time`: event timestamp
* `record`: event record

Example:

```ruby
d.run do
  d.feed('test', event_time, { 'message' => 'Hello, Fluentd!' })
end
```

### `feed(tag, array_event_stream)`

Feeds an array of event stream to plugin instance.

* `tag`: the tag of the event
* `array_event_stream`: array of `[time, record]`
  * `time`: event timestamp
  * `record`: event record

Example:

```ruby
d.run do
  d.feed('test', [
    [event_time, { 'message' => 'Hello, user1!' }],
    [event_time, { 'message' => 'Hello, user2!' }]
  ])
end
```

### `feed(tag, es)`

Feeds an event stream to plugin instance.

* `tag`: the tag of the event
* `es`: event stream object

Example:

```ruby
es = Fluent::OneEventStream.new(event_time, { 'message' => 'Hello, Fluentd!' })
d.run do
  d.feed('test', es)
end
```

### `feed(record)`

Feeds an event with default tag to plugin instance.

* `record`: event record

Example:

```ruby
d.run(default_tag: 'test') do
  d.feed({ 'message' => 'Hello, Fluentd!' })
  # Same as above ^
  d.feed(event_time, { 'message' => 'Hello, Fluentd!' })
end
```

### `feed(time, record)`

Feeds an event with default tag to plugin instance.

* `time`: event timestamp
* `record`: event record

Example:

```ruby
d.run(default_tag: 'test') do
  d.feed(event_time, { 'message' => 'Hello, Fluentd!' })
end
```

### `feed(array_event_stream)`

Feeds an array of event stream with default tag to plugin instance.

* `array_event_stream`: array of `[time, record]`
  * `time`: event timestamp
  * `record`: event record

Example:

```ruby
d.run(default_tag: 'test') do
  d.feed([
    [event_time, { 'message' => 'Hello, user1!' }],
    [event_time, { 'message' => 'Hello, user2!' }]
  ])
end
```

### `feed(es)`

Feeds an event stream with default tag to plugin instance.

* `es`: event stream object

Example:

```ruby
es = Fluent::OneEventStream.new(event_time, { 'message' => 'Hello, Fluentd!' })
d.run(default_tag: 'test') do
  d.feed(es)
end
```

## Test Driver Filter API

### `filtered_records`

Collects the filtered records.

```ruby
d = create_driver(config)
d.run do
  d.feed('filter.test', event_time, { 'foo' => 'bar', 'message' => msg })
end
d.filtered_records
```

## Test Driver Output API

### `run(flush: true, wait_flush_completion: true, force_flush_retry: false, **kwargs, &block)`

* `flush`: flush forcibly
* `wait_flush_completion`: if `true`, waiting for `flush` to complete
* `force_flush_retry`: if `true`, retrying flush forcibly

Run Test Driver. This Test Driver will be stop running immediately after evaluating the `block` if given.

Otherwise, you must register conditions to stop running Test Driver.

Example:

```ruby
d = create_driver(config)
d.run do
  d.feed('filter.test', event_time, { 'foo' => 'bar', 'message' => msg })
end
```

### `formatted`

Returns the formatted records.

Example:

```ruby
d = create_driver(config)
d.run do
  d.feed('filter.test', event_time, { 'foo' => 'bar', 'message' => msg })
end
d.formatted
```

### `flush`

Flushes forcibly.

Example:

```ruby
d = create_driver(config)
d.run do
  d.feed('filter.test', event_time, { 'foo' => 'bar', 'message' => msg })
end
d.flush
```

## Test Helpers

### `assert_equal_event_time(expected, actual, message = nil)`

Asserts the `EventTime` instance.

* `expected`: expected `EventTime` instance
* `actual`: actual `EventTime` instance
* `message`: message to display when assertion fails

Example:

```ruby
parser = create_parser
parser.parse(text) do |time, record|
  assert_equal_event_time(event_time('2017-12-27 09:43:50.123456789'), time)
end
```

### `config_element(name = 'test', argument = '', params = {}, elements = [])`

Create `Fluent::Config::Element` instance.

* `name`: element name such as `match`, `filter`, `source`, `buffer`, `inject`,

  `format`, `parse`, etc.

* `argument`: argument for section defined by `config_argument`
* `params`: parameters for section defined by `config_element`
* `elements`: child elements of this config element

Example:

```ruby
conf = config_element('match', '**', {
  'path' => "#{TMP_DIR}/prohibited/${tag}/file.%Y%m%d.log",
}, [
     config_element('buffer', 'time,tag', {
      'time_key' => 86400,
      'timekey_zone' => '+0000'
    })
  ]
)
d = create_driver(conf)
```

### `event_time(str = nil, format: nil)`

Creates a `Fluent::EventTime` instance.

* `str`: time represented as `String`
* `format`: parse `str` as `time` according to this format. See also

  [`Time.strptime`](https://docs.ruby-lang.org/en/trunk/Time.html#method-c-strptime).

Example:

```ruby
time = event_time
time = event_time('2016-10-03 23:58:09 UTC')
time = event_time('2016-04-11 16:40:01 +0000')
time = event_time('2016-04-17 11:15:00 -0700')
time = event_time('2011-01-02 13:14:15')
time = event_time('Sep 11 00:00:00', format: '%b %d %H:%M:%S')
time = event_time('28/Feb/2013:12:00:00 +0900', format: '%d/%b/%Y:%H:%M:%S %z')
time = event_time('2017-02-06T13:14:15.003Z', format: '%Y-%m-%dT%H:%M:%S.%L%z')
```

### `with_timezone(tz, &block)`

Processes the given block with `tz`. This method overrides `ENV['TZ']` while processing its `block`.

* `tz`: timezone. This is set to `ENV['TZ']`.

Example:

```ruby
time = with_timezone('UTC+02') do
  parser = Fluent::TimeParser.new('%Y-%m-%d %H:%M:%S.%N', true)
  parser.parse('2016-09-02 18:42:31.123456789')
end
assert_equal_event_time(time, event_time('2016-09-02 18:42:31.123456789 -02:00', format: '%Y-%m-%d %H:%M:%S.%N %z'))
```

### `with_worker_config(root_dir: nil, workers: nil, worker_id: nil, &block)`

Processes `block` with the given parameters. This method overrides the system configuration while processing its `block`.

This is useful for testing Fluentd's internal behavior related to multi workers.

* `root_dir`: root directory
* `workers`: the number of workers
* `worker_id`: ID of workers

Example:

```ruby
class Dummy < Fluent::Plugin::Output
end

d = Dummy.new
with_worker_config(workers: 2, worker_id: 1) do
  d.configure(conf)
end

# ...
```

### `time2str(time, localtime: false, format: nil)`

Converts `time` to `String`.

This is useful for testing the formatter.

* `time`: `Fluent::EventTime` instance. See also

  [`Time.at`](https://docs.ruby-lang.org/en/trunk/Time.html#method-c-at).

* `localtime`: If `true`, processes `time` as `localtime`. Otherwise UTC.
* `format`: See also

  [`Time#strftime`](https://docs.ruby-lang.org/en/trunk/Time.html#method-i-strftime).

```ruby
formatter = configure_formatter(conf)
formatted = formatter.format(tag, time, record)
assert_equal("#{time2str(time)}\t#{JSON.dump(record)}\n", formatted)
```

### `msgpack(type)`

* `type`: Available types: { `:factory`, `:packer`, `:unpacker` }

Shorthand for:

* `Fluent::MessagePackFactory.factory`
* `Fluent::MessagePackFactory.packer` 
* `Fluent::MessagePackFactory.unpacker`

Example:

```ruby
events = []
factory = msgpack(:factory)
factory.unpacker.feed_each(binary) do |obj|
  events << obj
end
```

### `capture_stdout(&block)`

Captures the standard output while processing the given block.

This is useful for testing Fluentd utility commands.

Example:

```ruby
captured_string = capture_stdout do
  # Print something to STDOUT
  puts 'Hello!'
end

assert_equal('Hello!\n', capture_stdout)
```

## Testing Input Plugins

You must test the input plugins' `router#emit` method. But you do not have to test this method explicitly. Its testing code pattern is encapsulated in the Input Test Driver.

You can write input plugins test like this:

```ruby
require 'fluent/test'
require 'fluent/test/driver/input'
require 'fluent/test/helpers'
require 'fluent/plugin/input_my'

class MyInputTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  setup do
    Fluent::Test.setup
  end

  def create_driver(conf = {})
    Fluent::Test::Driver::Input.new(Fluent::Plugin::MyInput).configure(conf)
  end

  test 'emit' do
    d = create_driver(config)
    d.run(timeout: 0.5)

    d.events.each do |tag, time, record|
      assert_equal('input.test', tag)
      assert_equal({ 'foo' => 'bar' }, record)
      assert(time.is_a?(Fluent::EventTime))
    end
  end
end
```

## Testing Filter Plugins

You must test filter plugins' `#filter` method. But you do not have to test this method explicitly. Its testing code pattern is encapsulated in Filter Test Driver.

You can write filter plugins test like this:

```ruby
require 'fluent/test'
require 'fluent/test/driver/filter'
require 'fluent/test/helpers'
require 'fluent/plugin/filter_my'

class MyInputTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  setup do
    Fluent::Test.setup
  end

  def create_driver(conf = {})
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::MyFilter).configure(conf)
  end

  test 'filter' do
    d = create_driver(config)
    time = event_time
    d.run do
      d.feed('filter.test', time, { 'foo' => 'bar', 'message' => msg })
    end

    assert_equal(1, d.filtered_records.size)
  end
end
```

## Testing Output Plugins

You must test output plugins' `#process` or `#write` or `#try_write` method. But you do not have to test this method explicitly. Its testing code pattern is encapsulated in the Output Test Driver.

You can write output plugins test like this:

```ruby
require 'fluent/test'
require 'fluent/test/driver/output'
require 'fluent/test/helpers'
require 'fluent/plugin/output_my'

class MyInputTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  setup do
    Fluent::Test.setup
  end

  def create_driver(conf = {})
    Fluent::Test::Driver::Output.new(Fluent::Plugin::MyOutput).configure(conf)
  end

  test 'emit' do
    d = create_driver(config)
    time = event_time
    d.run do
      d.feed('output.test', time, { 'foo' => 'bar', 'message' => msg })
    end

    assert_equal(1, d.events.size)
  end
end
```

## Testing Parser Plugins

You must test the parser plugins' `#parse` method.

You can write parser plugins test like this:

```ruby
require 'fluent/test'
require 'fluent/test/driver/parser'
require 'fluent/test/helpers'
require 'fluent/plugin/parser_my'

class MyParserTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  setup do
    Fluent::Test.setup
  end

  def create_driver(conf = {})
    Fluent::Test::Driver::Parser.new(Fluent::Plugin::MyParser).configure(conf)
  end

  def create_parser(conf)
    create_driver(conf).instance
  end

  test 'parse' do
    parser = create_parser(conf)
    parser.parse(text) do |time, record|
      assert_equal(event_time('2017-12-26 11:56:50.1234567879'), time)
      assert_equal({ 'message' => 'Hello, Fluentd!' }, record)
    end
  end
end
```

## Testing Formatter Plugins

You must test the formatter plugins' `#format` method.

You can write formatter plugins test like this:

```ruby
require 'fluent/test'
require 'fluent/test/driver/formatter'
require 'fluent/test/helpers'
require 'fluent/plugin/formatter_my'

class MyFormatterTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  setup do
    Fluent::Test.setup
  end

  def create_driver(conf = {})
    Fluent::Test::Driver::Formatter.new(Fluent::Plugin::MyFormatter).configure(conf)
  end

  def create_formatter(conf)
    create_driver(conf).instance
  end

  test 'format' do
    formatter = create_formatter(conf)
    formatted = formatter.format(tag, time, record)
    assert_equal('message:awesome\tgreeting:hello', formatted)
  end
end
```

## Tests for Logs

Testing logs is easy.

Code example:

```ruby
# d is a Test Driver instance
assert_equal(1, d.logs.size)
logs = d.logs

assert do
  logs.any? { |log| log.include?(expected_log) }
end

assert do
  logs.last.match?(/This is last log/)
end
```

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.

