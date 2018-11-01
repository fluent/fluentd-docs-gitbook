<hgroup>
<h1>Output Plugin Overview</h1>
</hgroup>
<p>Fluentd has 6 types of plugins: <a href="input-plugin-overview">Input</a>, <a href="parser-plugin-overview">Parser</a>, <a href="filter-plugin-overview">Filter</a>, <a href="output-plugin-overview">Output</a>, <a href="formatter-plugin-overview">Formatter</a> and <a href="buffer-plugin-overview">Buffer</a>. This article gives an overview of Output Plugin.</p>
<a name="overview"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#overview">Overview</a></li>
<li class="toc-item"><a href="#list-of-non-buffered-output-plugins">List of Non-Buffered Output Plugins</a></li>
<li class="toc-item"><a href="#list-of-buffered-output-plugins">List of Buffered Output Plugins</a></li>
<li class="toc-item"><a href="#list-of-time-sliced-output-plugins">List of Time Sliced Output Plugins</a></li>
<li class="toc-item"><a href="#other-plugins">Other Plugins</a></li>
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
<li class="sub-toc-item"><a href="#secondary-output">secondary output</a></li>
</ul>
<li class="toc-item"><a href="#time-sliced-output-parameters">Time Sliced Output Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#time_slice_format">time_slice_format</a></li>
<li class="sub-toc-item"><a href="#time_slice_wait">time_slice_wait</a></li>
<li class="sub-toc-item"><a href="#buffer_type">buffer_type</a></li>
<li class="sub-toc-item"><a href="#buffer_queue_limit,-buffer_chunk_limit">buffer_queue_limit, buffer_chunk_limit</a></li>
<li class="sub-toc-item"><a href="#flush_interval">flush_interval</a></li>
<li class="sub-toc-item"><a href="#flush_at_shutdown">flush_at_shutdown</a></li>
<li class="sub-toc-item"><a href="#retry_wait,-max_retry_wait">retry_wait, max_retry_wait</a></li>
<li class="sub-toc-item"><a href="#retry_limit,-disable_retry_limit">retry_limit, disable_retry_limit</a></li>
<li class="sub-toc-item"><a href="#num_threads">num_threads</a></li>
<li class="sub-toc-item"><a href="#slow_flush_log_threshold">slow_flush_log_threshold</a></li>
</ul>
</ul>
</section>
<h2>Overview</h2>
<p>There are three types of output plugins: Non-Buffered, Buffered, and Time Sliced.</p>
<ul>
<li>
<em>Non-Buffered</em> output plugins do not buffer data and immediately write out results.</li>
<li>
<em>Buffered</em> output plugins maintain a queue of chunks (a chunk is a collection of events), and its behavior can be tuned by the “chunk limit” and “queue limit” parameters (See the diagram  below).</li>
<li>
<em>Time Sliced</em> output plugins are in fact a type of Bufferred plugin, but the chunks are keyed by time (See the diagram below).</li>
</ul>
<p><img src="http://image.slidesharecdn.com/fluentdmeetup-diveintofluentplugin-120203210125-phpapp02/95/slide-60-728.jpg" style="display:block;"/></p>
<p>The output plugin’s buffer behavior (if any) is defined by a separate <a href="buffer-plugin-overview">Buffer plugin</a>. Different buffer plugins can be chosen for each output plugin. Some output plugins are fully customized and do not use buffers.</p>
<a name="list-of-non-buffered-output-plugins"></a><h2>List of Non-Buffered Output Plugins</h2>
<ul>
<li><a href="out_copy">out_copy</a></li>
<li><a href="out_null">out_null</a></li>
<li><a href="out_roundrobin">out_roundrobin</a></li>
<li><a href="out_stdout">out_stdout</a></li>
</ul>
<a name="list-of-buffered-output-plugins"></a><h2>List of Buffered Output Plugins</h2>
<ul>
<li><a href="out_exec_filter">out_exec_filter</a></li>
<li><a href="out_forward">out_forward</a></li>
<li>
<a href="out_mongo">out_mongo</a> or <a href="out_mongo_replset">out_mongo_replset</a>
</li>
</ul>
<a name="list-of-time-sliced-output-plugins"></a><h2>List of Time Sliced Output Plugins</h2>
<ul>
<li><a href="out_exec">out_exec</a></li>
<li><a href="out_file">out_file</a></li>
<li><a href="out_s3">out_s3</a></li>
<li><a href="out_webhdfs">out_webhdfs</a></li>
</ul>
<a name="other-plugins"></a><h2>Other Plugins</h2>
<p>Please refer to this list of available plugins to find out about other Output plugins.</p>
<ul>
<li><a href="http://fluentd.org/plugin/">others</a></li>
</ul>
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
<a name="secondary-output"></a><h3>secondary output</h3>
<p>At Buffered output plugin, the user can specify <code>&lt;secondary&gt;</code> with any output plugin in <code>&lt;match&gt;</code> configuration.
If the retry count exceeds the buffer’s <code>retry_limit</code> (and the retry limit has
not been disabled via <code>disable_retry_limit</code>), then buffered chunk is output to <code>&lt;secondary&gt;</code> output plugin.</p>
<p><code>&lt;secondary&gt;</code> is useful for backup when destination servers are unavailable, e.g. forward, mongo and other plugins. We strongly recommend <code>out_file</code> plugin for <code>&lt;secondary&gt;</code>.</p>
<a name="time-sliced-output-parameters"></a><h2>Time Sliced Output Parameters</h2>
<p>For advanced usage, you can tune Fluentd’s internal buffering mechanism with these parameters.</p>
<a name="time_slice_format"></a><h3>time_slice_format</h3>
<p>The time format used as part of the file name. The following characters are replaced with actual values when the file is created:</p>
<ul>
<li>%Y: year including the century (at least 4 digits)</li>
<li>%m: month of the year (01..12)</li>
<li>%d: Day of the month (01..31)</li>
<li>%H: Hour of the day, 24-hour clock (00..23)</li>
<li>%M: Minute of the hour (00..59)</li>
<li>%S: Second of the minute (00..60)</li>
</ul>
<p>The default format is <code>%Y%m%d%H</code>, which creates one file per hour.</p>
<a name="time_slice_wait"></a><h3>time_slice_wait</h3>
<p>The amount of time Fluentd will wait for old logs to arrive. This is used to account for delays in logs arriving to your Fluentd node. The default wait time is 10 minutes (‘10m’), where Fluentd will wait until 10 minutes past the hour for any logs that occurred within the past hour.</p>
<p>For example, when splitting files on an hourly basis, a log recorded at 1:59 but arriving at the Fluentd node between 2:00 and 2:10 will be uploaded together with all the other logs from 1:00 to 1:59 in one transaction, avoiding extra overhead. Larger values can be set as needed.</p>
<a name="buffer_type"></a><h3>buffer_type</h3>
<p>The buffer type is <code>file</code> by default (<a href="buf_file">buf_file</a>). The <code>memory</code> (<a href="buf_memory">buf_memory</a>) buffer type can be chosen as well. If you use <code>file</code> buffer type, <code>buffer_path</code> parameter is required.</p>
<a name="buffer_queue_limit,-buffer_chunk_limit"></a><h3>buffer_queue_limit, buffer_chunk_limit</h3>
<p>The length of the chunk queue and the size of each chunk, respectively. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure. The default values are 64 and 8m, respectively. The suffixes “k” (KB), “m” (MB), and “g” (GB) can be used for buffer_chunk_limit.</p>
<a name="flush_interval"></a><h3>flush_interval</h3>
<p>The interval between data flushes. The default is 60s. The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used.</p>
<a name="flush_at_shutdown"></a><h3>flush_at_shutdown</h3>
<p>If set to true, Fluentd waits for the buffer to flush at shutdown. By default, it is set to true for Memory Buffer and false for File Buffer.</p>
<a name="retry_wait,-max_retry_wait"></a><h3>retry_wait, max_retry_wait</h3>
<p>The initial and maximum intervals between write retries.  The default values are 1.0 and unset (no limit).  The interval doubles (with +/-12.5% randomness) every retry until <code>max_retry_wait</code> is reached.</p>
<p>Since td-agent will retry 17 times before giving up by default (see the <code>retry_limit</code> parameter for details), the sleep interval can be up to approximately 131072 seconds (roughly 36 hours) in the default configurations.</p>
<a name="retry_limit,-disable_retry_limit"></a><h3>retry_limit, disable_retry_limit</h3>
<p>The limit on the number of retries before buffered data is discarded, and an
option to disable that limit (if true, the value of <code>retry_limit</code> is ignored and
there is no limit).  The default values are 17 and false (not disabled). If the limit is reached, buffered data is discarded and the retry interval is reset to its initial value (<code>retry_wait</code>).</p>
<a name="num_threads"></a><h3>num_threads</h3>
<p>The number of threads to flush the buffer. This option can be used to parallelize writes into the output(s) designated by the output plugin. The default is 1.</p>
<a name="slow_flush_log_threshold"></a><h3>slow_flush_log_threshold</h3>
<p>Same as Buffered Output but default value is changed to <code>40.0</code> seconds.</p>
<div style="text-align:right">
  Last updated: 2015-10-11 06:06:16 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/output-plugin-overview">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
