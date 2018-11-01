<hgroup>
<h1>Apache Kafka Output Plugin</h1>
</hgroup>
<p>The <code>out_kafka</code> Output plugin writes records into <a href="https://kafka.apache.org/">Apache Kafka</a>.</p>
<table class="note">
<td class="icon"></td>
<td class="content">This document doesn't describe all parameters. If you want to know full features, check the Further Reading section.</td>
</table>
<a name="installation"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#installation">Installation</a></li>
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#brokers-(required/optional)">brokers (required/optional)</a></li>
<li class="sub-toc-item"><a href="#default_topic">default_topic</a></li>
<li class="sub-toc-item"><a href="#default_partition_key">default_partition_key</a></li>
<li class="sub-toc-item"><a href="#default_message_key">default_message_key</a></li>
<li class="sub-toc-item"><a href="#output_data_type">output_data_type</a></li>
<li class="sub-toc-item"><a href="#max_send_retries">max_send_retries</a></li>
<li class="sub-toc-item"><a href="#required_acks">required_acks</a></li>
<li class="sub-toc-item"><a href="#ack_timeout">ack_timeout</a></li>
<li class="sub-toc-item"><a href="#compression_codec">compression_codec</a></li>
</ul>
<li class="toc-item"><a href="#buffered-output-parameters">Buffered Output Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#buffer_type">buffer_type</a></li>
<li class="sub-toc-item"><a href="#buffer_queue_limit,-buffer_chunk_limit">buffer_queue_limit, buffer_chunk_limit</a></li>
<li class="sub-toc-item"><a href="#flush_interval">flush_interval</a></li>
<li class="sub-toc-item"><a href="#flush_at_shutdown">flush_at_shutdown</a></li>
<li class="sub-toc-item"><a href="#retry_wait,-max_retry_wait">retry_wait, max_retry_wait</a></li>
<li class="sub-toc-item"><a href="#retry_limit,-disable_retry_limit">retry_limit, disable_retry_limit</a></li>
<li class="sub-toc-item"><a href="#num_threads">num_threads</a></li>
<li class="sub-toc-item"><a href="#slow_flush_log_threshold">slow_flush_log_threshold</a></li>
</ul>
<li class="toc-item"><a href="#further-reading">Further Reading</a></li>
</ul>
</section>
<h2>Installation</h2>
<p><code>out_kafka</code> is included in td-agent2 after v2.3.3. Fluentd gem users will need to install the fluent-plugin-kafka gem using the following command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluent-gem install fluent-plugin-kafka
</span></pre>
<a name="example-configuration"></a><h2>Example Configuration</h2>
<pre class="CodeRay">&lt;match pattern&gt;
  @type kafka_buffered

  # list of seed brokers
  brokers &lt;broker1_host&gt;:&lt;broker1_port&gt;,&lt;broker2_host&gt;:&lt;broker2_port&gt;

  # buffer settings
  buffer_type file
  buffer_path /var/log/td-agent/buffer/td
  flush_interval 3s

  # topic settings
  default_topic messages

  # data type settings
  output_data_type json
  compression_codec gzip

  # producer settings
  max_send_retries 1
  required_acks -1
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<table class="note">
<td class="icon"></td>
<td class="content">Please make sure that you have <b>enough space in the buffer_path directory</b>. Running out of disk space is a problem frequently reported by users.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>kafka_buffered</code>.</p>
<a name="brokers-(required/optional)"></a><h3>brokers (required/optional)</h3>
<p>The list of all seed brokers, with their host and port information.</p>
<a name="default_topic"></a><h3>default_topic</h3>
<p>The name of default topic (default: nil).</p>
<a name="default_partition_key"></a><h3>default_partition_key</h3>
<p>The name of default partition key (default: nil).</p>
<a name="default_message_key"></a><h3>default_message_key</h3>
<p>The name of default message key (default: nil).</p>
<a name="output_data_type"></a><h3>output_data_type</h3>
<p>The format of each message. The available options are <code>json</code>, <code>ltsv</code>, <code>msgpack</code>, <code>attr:&lt;record name&gt;</code>, <code>&lt;formatter name&gt;</code>. <code>msgpack</code> is recommended since it’s more compact and faster.</p>
<a name="max_send_retries"></a><h3>max_send_retries</h3>
<p>The number of times to retry sending of messages to a leader (default: 1).</p>
<a name="required_acks"></a><h3>required_acks</h3>
<p>The number of acks required per request (default: -1).</p>
<a name="ack_timeout"></a><h3>ack_timeout</h3>
<p>How long the producer waits for acks. The unit is seconds (default: nil =&gt; Use default of ruby-kafka library)</p>
<a name="compression_codec"></a><h3>compression_codec</h3>
<p> The codec the producer uses to compress messages (default: nil). The available options are <code>gzip</code> and <code>snappy</code>. When you use <code>snappy</code>, you need to install <code>snappy</code> gem by <code>td-agent-gem</code> command.</p>
<a name="buffered-output-parameters"></a><h2>Buffered Output Parameters</h2>
<p>For advanced usage, you can tune Fluentd’s internal buffering mechanism with these parameters.</p>
<a name="buffer_type"></a><h3>buffer_type</h3>
<p>The buffer type is <code>memory</code> by default (<a href="buf_memory">buf_memory</a>) for the ease of testing, however <code>file</code> (<a href="buf_file">buf_file</a>) buffer type is always recommended for the production deployments. If you use <code>file</code> buffer type, <code>buffer_path</code> parameter is required.</p>
<a name="buffer_queue_limit,-buffer_chunk_limit"></a><h3>buffer_queue_limit, buffer_chunk_limit</h3>
<p>The length of the chunk queue and the size of each chunk, respectively. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure. The default values are 64 and 8m, respectively. The suffixes “k” (KB), “m” (MB), and “g” (GB) can be used for buffer_chunk_limit.</p>
<a name="flush_interval"></a><h3>flush_interval</h3>
<p>The interval between data flushes. The default is 60s. The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used.</p>
<a name="flush_at_shutdown"></a><h3>flush_at_shutdown</h3>
<p>If set to true, Fluentd waits for the buffer to flush at shutdown. By default, it is set to true for Memory Buffer and false for File Buffer.</p>
<a name="retry_wait,-max_retry_wait"></a><h3>retry_wait, max_retry_wait</h3>
<p>The initial and maximum intervals between write retries.  The default values are 1.0 seconds and unset (no limit).  The interval doubles (with +/-12.5% randomness) every retry until <code>max_retry_wait</code> is reached.</p>
<p>Since td-agent will retry 17 times before giving up by default (see the <code>retry_limit</code> parameter for details), the sleep interval can be up to approximately 131072 seconds (roughly 36 hours) in the default configurations.</p>
<a name="retry_limit,-disable_retry_limit"></a><h3>retry_limit, disable_retry_limit</h3>
<p>The limit on the number of retries before buffered data is discarded, and an
option to disable that limit (if true, the value of <code>retry_limit</code> is ignored and
there is no limit).  The default values are 17 and false (not disabled). If the limit is reached, buffered data is discarded and the retry interval is reset to its initial value (<code>retry_wait</code>).</p>
<a name="num_threads"></a><h3>num_threads</h3>
<p>The number of threads to flush the buffer. This option can be used to parallelize writes into the output(s) designated by the output plugin. Increasing the number of threads improves the flush throughput to hide write / network latency. The default is 1.</p>
<a name="slow_flush_log_threshold"></a><h3>slow_flush_log_threshold</h3>
<p>The threshold for checking chunk flush performance. The default value is <code>20.0</code> seconds. Note that parameter type is <code>float</code>, not <code>time</code>.</p>
<p>If chunk flush takes longer time than this threshold, fluentd logs warning message like below:</p>
<pre class="CodeRay">2016-12-19 12:00:00 +0000 [warn]: buffer flush took longer time than slow_flush_log_threshold: elapsed_time = 15.0031226690043695 slow_flush_log_threshold=10.0 plugin_id="foo"
</pre>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="further-reading"></a><h2>Further Reading</h2>
<p>This page doesn’t describe all the possible configurations. If you want to know about other configurations, please check the link below.</p>
<ul>
<li><a href="https://github.com/fluent/fluent-plugin-kafka">fluent-plugin-kafka repository</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2017-01-28 07:34:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
