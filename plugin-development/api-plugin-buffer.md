# How to Write Buffer Plugin

TODO: Write

## Methods

### evacuate_chunk

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
