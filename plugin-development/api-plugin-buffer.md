# How to Write Buffer Plugin

Fluentd supports [pluggable buffers](../buffer/) which keep the events of an output plugin until they are written to the destination. The plugin filenames prefixed `buf_` are registered as Buffer Plugins.

See [Plugin Base Class API](api-plugin-base.md) for details on the common APIs for all the plugin types.

A buffer plugin consists of two classes:

* a subclass of `Fluent::Plugin::Buffer`, which creates the chunks and restores them on start
* a subclass of `Fluent::Plugin::Buffer::Chunk`, which keeps the data of a chunk

`Fluent::Plugin::Buffer` does the rest: it decides which chunk the events go to, moves the chunks from the stage to the queue, hands them to the output plugin and enforces the limits such as `chunk_limit_size` and `total_limit_size`. See [Buffer Plugins](../buffer/README.md#how-buffer-works) for how the stage and the queue work.

Here is an example of a custom buffer plugin that keeps each chunk in two files in a directory: the data in `<chunk id>.data`, and the metadata of the chunk in `<chunk id>.meta`. It takes a required parameter called `path`, which is the pathname of that directory.

```ruby
require 'fileutils'

require 'fluent/msgpack_factory'
require 'fluent/plugin/buffer'
require 'fluent/plugin/buffer/chunk'

module Fluent::Plugin
  class MyDirBuffer < Buffer
    # Register MyDirBuffer as 'my_dir'.
    Fluent::Plugin.register_buffer('my_dir', self)

    config_param :path, :string

    def start
      FileUtils.mkdir_p(@path)

      # Buffer#start calls #resume.
      super
    end

    # Chunks are kept in files, so they survive a restart.
    def persistent?
      true
    end

    # Restores the chunks left by the previous run.
    def resume
      stage = {}
      queue = []

      Dir.glob('*.meta', base: @path) do |name|
        meta_path = File.join(@path, name)
        chunk = MyDirChunk.restore(meta_path, compress: @compress, decompression_size_limit: @decompression_size_limit)
        if chunk.queued?
          queue << chunk
        elsif stage.key?(chunk.metadata)
          # Only one staged chunk is allowed per metadata.
          queue << chunk.enqueued!
        else
          stage[chunk.metadata] = chunk
        end
      rescue => e
        log.error "failed to restore a chunk", path: meta_path, error: e
      end

      # Flush the older chunks first.
      queue.sort_by!(&:raw_create_at)

      return stage, queue
    end

    def generate_chunk(metadata)
      MyDirChunk.new(metadata, @path, compress: @compress, decompression_size_limit: @decompression_size_limit)
    end
  end

  # Keeps the data in "<id>.data" and its metadata in "<id>.meta".
  class MyDirChunk < Buffer::Chunk
    def self.restore(meta_path, compress:, decompression_size_limit:)
      meta = Fluent::MessagePackFactory.msgpack_unpacker(symbolize_keys: true).feed(File.binread(meta_path)).read
      # Check the data file before creating the chunk, which would create it.
      data_path = File.join(File.dirname(meta_path), "#{meta[:id]}.data")
      unless File.exist?(data_path) && File.size(data_path) >= meta[:bytesize]
        raise "#{data_path} is missing or shorter than the committed data"
      end

      metadata = Buffer::Metadata.new(meta[:timekey], meta[:tag], meta[:variables])
      chunk = new(metadata, File.dirname(meta_path), compress: compress, decompression_size_limit: decompression_size_limit, unique_id: [meta[:id]].pack('H*'))
      chunk.restore_state(meta)
      chunk
    end

    def initialize(metadata, dir, compress:, decompression_size_limit:, unique_id: nil)
      super(metadata, compress: compress, decompression_size_limit: decompression_size_limit)
      @unique_id = unique_id if unique_id
      id = dump_unique_id_hex(@unique_id)
      @data_path = File.join(dir, "#{id}.data")
      @meta_path = File.join(dir, "#{id}.meta")
      @file = File.open(@data_path, 'ab')
      @committed_bytesize = 0
      @adding_bytesize = 0
      @adding_size = 0
    end

    def restore_state(meta)
      # Drop the data written after the last commit.
      @file.truncate(meta[:bytesize])
      @committed_bytesize = meta[:bytesize]
      @size = meta[:size]
      @created_at = meta[:created_at]
      @modified_at = meta[:modified_at]
      meta[:state] == 'queued' ? enqueued! : staged!
    end

    def concat(bulk, bulk_size)
      @file.write(bulk)
      @adding_bytesize += bulk.bytesize
      @adding_size += bulk_size
      true
    end

    def commit
      @file.flush
      modified_at = Fluent::Clock.real_now
      # Write the meta file first. If it fails, #rollback still drops the
      # added data.
      write_meta(bytesize, size, modified_at)
      @committed_bytesize += @adding_bytesize
      @size += @adding_size
      @adding_bytesize = @adding_size = 0
      @modified_at = modified_at
      @modified_at_object = nil
      true
    end

    def rollback
      @file.truncate(@committed_bytesize)
      @adding_bytesize = @adding_size = 0
      true
    end

    def bytesize
      @committed_bytesize + @adding_bytesize
    end

    def size
      @size + @adding_size
    end

    def enqueued!
      super
      write_meta
      self
    end

    # Called on shutdown. Keeps the files unless the chunk has no data.
    def close
      super
      @file.close unless @file.closed?
      remove_files if @committed_bytesize == 0
      self
    end

    def purge
      super
      @file.close unless @file.closed?
      remove_files
      self
    end

    def read(**kwargs)
      File.binread(@data_path)
    end

    def open(**kwargs, &block)
      File.open(@data_path, 'rb', &block)
    end

    private

    def write_meta(bytesize = @committed_bytesize, size = @size, modified_at = @modified_at)
      meta = {
        id: dump_unique_id_hex(@unique_id),
        state: queued? ? 'queued' : 'staged',
        size: size,
        bytesize: bytesize,
        created_at: @created_at,
        modified_at: modified_at,
        timekey: @metadata.timekey,
        tag: @metadata.tag,
        variables: @metadata.variables,
      }
      # Renames a temporary file so that a crash in the middle of the write
      # does not leave a half-written file behind.
      File.binwrite("#{@meta_path}.tmp", Fluent::MessagePackFactory.thread_local_msgpack_packer.pack(meta).full_pack)
      File.rename("#{@meta_path}.tmp", @meta_path)
    end

    def remove_files
      # Remove the meta file first, so that a crash in between does not leave
      # a meta file without its data file.
      [@meta_path, @data_path].each do |path|
        File.unlink(path)
      rescue Errno::ENOENT
        # The meta file is not written until the first commit.
      end
    end
  end
end
```

Save this as `buf_my_dir.rb` in a loadable plugin path.

With `out_stdout` output plugin:

```text
<source>
  @type sample
  tag test
</source>

<match test>
  @type stdout
  <buffer>
    @type my_dir
    path /path/to/buffer
    flush_interval 60s
    flush_at_shutdown false
  </buffer>
</match>
```

The chunk files look like this. The meta file is in MessagePack, as `buf_file` does, so that any tag and chunk key value can be kept. Decode it to read:

```text
$ ls /path/to/buffer
660d66de1fa3469a85da1181c2ae47e7.data  660d66de1fa3469a85da1181c2ae47e7.meta
$ ruby -rfluent/msgpack_factory -e 'p Fluent::MessagePackFactory.msgpack_unpacker(symbolize_keys: true).feed(File.binread(ARGV[0])).read' /path/to/buffer/660d66de1fa3469a85da1181c2ae47e7.meta
{:id=>"660d66de1fa3469a85da1181c2ae47e7", :state=>"staged", :size=>8, :bytesize=>504, :created_at=>1795323943, :modified_at=>1795323950, :timekey=>nil, :tag=>"test", :variables=>nil}
```

If you stop Fluentd before the chunk is flushed, the files are kept, and the events in them are written out after Fluentd starts again. `out_stdout` sets `flush_at_shutdown` to `true` by default, so the example sets it to `false` to show this.

The example above is kept short. A buffer plugin for real use should also check in `#configure` that `path` is a writable directory, and raise `Fluent::ConfigError` if it is not. It should also decide what to do with a broken chunk on `#resume`, instead of only logging it, and with a data file left without its meta file by a crash before the first commit. It should reject a `path` that another buffer already uses, because two buffers on the same directory restore the same chunks. It should create the files and the directory with the `file_permission` and `dir_permission` of [`<system>`](../deployment/system-config.md). It also has to decide what to do under [multiple workers](../deployment/multi-process-workers.md): the example uses the same directory in every worker, so every worker restores the chunks of the others, and Fluentd accepts this configuration because `#multi_workers_ready?` returns `true` by default. See [`buf_file`](https://github.com/fluent/fluentd/blob/master/lib/fluent/plugin/buf_file.rb) and [`Fluent::Plugin::Buffer::FileChunk`](https://github.com/fluent/fluentd/blob/master/lib/fluent/plugin/buffer/file_chunk.rb), the built-in implementation, for all of them.

To keep the chunks in memory, use [`Fluent::Plugin::Buffer::MemoryChunk`](https://github.com/fluent/fluentd/blob/master/lib/fluent/plugin/buffer/memory_chunk.rb) in `#generate_chunk`, as [`buf_memory`](../buffer/memory.md) does, instead of writing a chunk class.

## Methods

### Buffer

`Fluent::Plugin::Buffer` raises `NotImplementedError` for the following methods, so a plugin must implement both.

#### `#resume`

It returns the chunks left by the previous run as two values: the stage, a `Hash` from the metadata to the chunk, and the queue, an `Array` of the chunks in the order to be flushed. `Fluent::Plugin::Buffer#start` calls it. A plugin which does not keep the chunks returns `{}` and `[]`.

Each chunk in the stage must be in the `staged` state, and the stage can have only one chunk for each metadata. Each chunk in the queue must be in the `queued` state. Call `#staged!` or `#enqueued!` on the restored chunk to set its state.

#### `#generate_chunk(metadata)`

It returns a new chunk for `metadata`. The chunk is empty, and `Fluent::Plugin::Buffer` sets its state.

Pass the `compress` parameter of the buffer, `@compress`, to the chunk. Since v1.20.0, also pass its `decompression_size_limit` parameter, `@decompression_size_limit`, as the keyword argument of the same name. v1.19.0 rejects this keyword with `ArgumentError`, so omit it there. `Fluent::Plugin::Buffer::Chunk` handles `compress gzip` and `compress zstd` by itself, so a chunk class stores and returns the compressed data as it is, and can ignore the keyword arguments of `#read`, `#open` and `#write_to`.

The following methods have working default implementations, and a plugin overrides them only when it needs another behavior.

#### `#persistent?`

It returns `true` if the chunks survive a restart of Fluentd. It changes the default of `flush_at_shutdown` of the output plugin to `false`, and `evacuate_limit_size` is used only when it returns `true`. \(default: `false`\)

#### `#evacuate_chunk(chunk)`

You can override this method to add feature to evacuate chunks before clearing the queue when reaching the retry limit.
See [Buffer - Handling Successive Failures](../buffer/README.md#handling-successive-failures) for details.

```ruby
def evacuate_chunk(chunk)
  unless chunk.is_a?(Fluent::Plugin::Buffer::FileChunk)
    raise ArgumentError, "The chunk must be FileChunk, but it was #{chunk.class}."
  end

  backup_dir = File.join(backup_base_dir, 'buffer', safe_owner_id)
  FileUtils.mkdir_p(backup_dir, mode: system_config.dir_permission || Fluent::DEFAULT_DIR_PERMISSION) unless Dir.exist?(backup_dir)

  FileUtils.copy([chunk.path, chunk.meta_path], backup_dir)
  log.warn "chunk files are evacuated to #{backup_dir}.", chunk_id: dump_unique_id_hex(chunk.unique_id)
rescue => e
  log.error "unexpected error while evacuating chunk files.", error: e
end
```

Since v1.20.0, the base class decides which chunks to pass to this method by `evacuate_limit_size`.
It counts the files directly under the directory used in the sample code above, so evacuate the chunk files to this directory.
Since v1.20.0, `evacuate_dir` returns this directory.
The base class subtracts only `chunk.bytesize` from the remaining capacity, so other files written by this method are not counted until the next evacuation.
The base class ignores `evacuate_limit_size` if `persistent?` of the buffer plugin returns `false`.

### Chunk

A chunk has a unique id, `#unique_id`, and the metadata, `#metadata`. The unique id is a 16-byte binary `String`, and `#dump_unique_id_hex` converts it to a hexadecimal one. The metadata is a `Fluent::Plugin::Buffer::Metadata`, which has the `timekey`, the `tag` and the `variables` \(a `Hash` with `Symbol` keys\) of the [chunk keys](../configuration/buffer-section.md#chunk-keys). A persistent buffer plugin must keep them, and restore them on `#resume`.

The data is added to a chunk in a transaction: `Fluent::Plugin::Buffer` calls `#concat` once or more, and then `#commit` to keep the added data or `#rollback` to drop it. It calls them while holding the lock of the chunk, so they are not called from two or more threads at the same time.

`Fluent::Plugin::Buffer::Chunk` raises `NotImplementedError` for the following methods, so a plugin must implement every one.

#### `#concat(bulk, bulk_size)`

It adds `bulk`, a binary `String` which has `bulk_size` events, to the chunk. The added data is not committed yet.

#### `#commit`

It keeps the data added since the last commit. After this, a persistent chunk must not lose the data on a crash.

#### `#rollback`

It drops the data added since the last commit.

#### `#bytesize`

It returns the size of the data in bytes, including the data which is not committed yet.

#### `#size`

It returns the number of the events, including the events which are not committed yet.

#### `#read(**kwargs)`

It returns the committed data as a `String`.

#### `#open(**kwargs, &block)`

It calls `&block` with an `IO` object to read the committed data from.

The following methods have working default implementations. A plugin overrides them only when it needs another behavior, and calls `super` in `#staged!`, `#enqueued!`, `#close` and `#purge` to update the state of the chunk.

#### `#empty?`

It returns `true` if the chunk has no events. \(default: `#size == 0`\)

#### `#staged!` and `#enqueued!`

They set the state of the chunk to `staged` or `queued`, and return the chunk itself. A persistent chunk overrides `#enqueued!` to keep the new state, so that the chunk is restored to the queue.

#### `#close`

It releases the resources of the chunk, such as an open file. It is called on shutdown, and for a staged chunk which has no events when it is moved to the queue. A persistent chunk keeps its data here unless the chunk is empty.

#### `#purge`

It removes the data of the chunk. It is called after the output plugin has written the chunk, and when the chunk is thrown away.

#### `#write_to(io, **kwargs)`

It writes the committed data into `io`. It uses `#open` by default.

## Writing Tests

There is no test driver for buffer plugins. Set a dummy output plugin as the owner of the buffer, and call the lifecycle methods of the buffer by yourself:

```ruby
# test/plugin/test_buf_my_dir.rb

require 'test/unit'
require 'fileutils'
require 'fluent/test'
require 'fluent/test/helpers'
require 'fluent/plugin/output'

# Your own plugin
require 'fluent/plugin/buf_my_dir'

class MyDirBufferTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  TMP_DIR = File.expand_path(File.dirname(__FILE__) + '/tmp/buf_my_dir')

  # A buffer plugin needs an owner plugin.
  class DummyOutput < Fluent::Plugin::Output
    def write(chunk)
    end
  end

  def setup
    Fluent::Test.setup
    FileUtils.rm_rf(TMP_DIR)
  end

  def teardown
    FileUtils.rm_rf(TMP_DIR)
  end

  def create_buffer(conf = { 'path' => TMP_DIR })
    buffer = Fluent::Plugin::MyDirBuffer.new
    buffer.owner = DummyOutput.new
    buffer.configure(config_element('buffer', '', conf))
    buffer.start
    buffer
  end

  def shutdown_buffer(buffer)
    buffer.stop
    buffer.before_shutdown
    buffer.shutdown
    buffer.after_shutdown
    buffer.close
    buffer.terminate
  end

  test 'requires path' do
    assert_raise(Fluent::ConfigError) do
      create_buffer({})
    end
  end

  test 'resumes the staged and queued chunks' do
    buffer = create_buffer
    m1 = buffer.new_metadata(tag: 'test.1')
    m2 = buffer.new_metadata(tag: 'test.2', variables: { key: 'value' })
    buffer.write({ m1 => ["a\n", "b\n"], m2 => ["c\n"] })
    buffer.enqueue_chunk(m1)
    shutdown_buffer(buffer)

    buffer = create_buffer
    assert_equal([m2], buffer.stage.keys)
    assert_equal("c\n", buffer.stage[m2].read)
    assert_equal(1, buffer.stage[m2].size)
    assert_equal(1, buffer.queue.size)
    assert_equal(m1, buffer.queue.first.metadata)
    assert_equal("a\nb\n", buffer.queue.first.read)
    assert_equal(2, buffer.queue.first.size)
    shutdown_buffer(buffer)
  end

  test 'drops the data written after the last commit' do
    buffer = create_buffer
    m = buffer.new_metadata(tag: 'test')
    buffer.write({ m => ["a\n"] })
    chunk = buffer.stage[m]
    chunk.append(["b\n"])
    chunk.rollback
    chunk.append(["c\n"])
    chunk.commit
    assert_equal("a\nc\n", chunk.read)
    chunk.append(["d\n"]) # not committed
    shutdown_buffer(buffer)

    buffer = create_buffer
    assert_equal("a\nc\n", buffer.stage[m].read)
    assert_equal(2, buffer.stage[m].size)
    shutdown_buffer(buffer)
  end

  test 'removes the files of purged chunks' do
    buffer = create_buffer
    m = buffer.new_metadata(tag: 'test')
    buffer.write({ m => ["a\n"] }, enqueue: true)
    chunk = buffer.dequeue_chunk
    buffer.purge_chunk(chunk.unique_id)
    assert_equal([], Dir.children(TMP_DIR))
    shutdown_buffer(buffer)
  end

  test 'removes the files of empty chunks on close' do
    buffer = create_buffer
    chunk = buffer.generate_chunk(buffer.new_metadata(tag: 'test'))
    chunk.close
    assert_equal([], Dir.children(TMP_DIR))
    shutdown_buffer(buffer)
  end
end
```

`#stage` and `#queue` of `Fluent::Plugin::Buffer` return the staged and the queued chunks, so that tests can check them.

To test the plugin together with an output plugin, configure a `<buffer>` section on the output plugin with `Fluent::Test::Driver::Output`. See [Testing API for Plugins](plugin-test-code.md) for details.
