<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_file">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>file Output Plugin</h1>
</hgroup>
<p>The <code>out_file</code> TimeSliced Output plugin writes events to files. By default, it creates files on a daily basis (around 00:10). This means that when you first import records using the plugin, no file is created immediately. The file will be created when the <code>time_slice_format</code> condition has been met. To change the output frequency, please modify the <code>time_slice_format</code> value.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#path-(required)">path (required)</a></li>
<li class="sub-toc-item"><a href="#append">append</a></li>
<li class="sub-toc-item"><a href="#format">format</a></li>
<li class="sub-toc-item"><a href="#time_format">time_format</a></li>
<li class="sub-toc-item"><a href="#utc">utc</a></li>
<li class="sub-toc-item"><a href="#compress">compress</a></li>
<li class="sub-toc-item"><a href="#symlink_path">symlink_path</a></li>
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
<h2>Example Configuration</h2>
<p><code>out_file</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;match pattern&gt;
  @type file
  path /var/log/fluent/myapp
  time_slice_format %Y%m%d
  time_slice_wait 10m
  time_format %Y%m%dT%H%M%S%z
  compress gzip
  utc
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>file</code>.</p>
<a name="path-(required)"></a><h3>path (required)</h3>
<p>The Path of the file. The actual path is path + time + ”.log”. The time portion is determined by the time_slice_format parameter, descried below.</p>
<p>The <code>path</code> parameter is used as <code>buffer_path</code> in this plugin.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Initially, you may see a file which looks like "/path/to/file.20140101.log.b4eea2c8166b147a0". This is an intermediate buffer file ("b4eea2c8166b147a0" identifies the buffer). Once the content of the buffer has been completely <a href="buf_file">flushed</a>, you will see the output file without the trailing identifier.</td>
</table>
<a name="append"></a><h3>append</h3>
<p>The flushed chunk is appended to existence file or not. The default is <code>false</code>.
By default, out_file flushes each chunk to different path.</p>
<pre class="CodeRay"># append false
log.20140608_0.log
log.20140608_1.log
log.20140609_0.log
log.20140609_1.log
</pre>
<p>This makes parallel file processing easy. But if you want to disable this behaviour,
you can disable it by setting <code>append true</code>.</p>
<pre class="CodeRay"># append true
log.20140608.log
log.20140609.log
</pre>
<a name="format"></a><h3>format</h3>
<p>The format of the file content. The default is <code>out_file</code>.</p>
<p>See <a href="formatter-plugin-overview">formatter article</a> for more detail.</p>
<a name="time_format"></a><h3>time_format</h3>
<p>The format of the time written in files. The default format is ISO-8601.</p>
<a name="utc"></a><h3>utc</h3>
<p>Uses UTC for path formatting. The default format is localtime.</p>
<a name="compress"></a><h3>compress</h3>
<p>Compresses flushed files using <code>gzip</code>. No compression is performed by default.</p>
<a name="symlink_path"></a><h3>symlink_path</h3>
<p>Create symlink to temporary buffered file when <code>buffer_type</code> is <code>file</code>. No symlink is created by default.
This is useful for tailing file content to check logs.</p>
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
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_file">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>
</div>
<!-- /#topic_content -->
</div>
<!-- /#page -->
</section>