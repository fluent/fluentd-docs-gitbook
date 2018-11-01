<hgroup>
<h1>HDFS (WebHDFS) Output Plugin</h1>
</hgroup>
<p>The <code>out_webhdfs</code> TimeSliced Output plugin writes records into HDFS (Hadoop Distributed File System). By default, it creates files on an hourly basis. This means that when you first import records using the plugin, no file is created immediately. The file will be created when the <code>time_slice_format</code> condition has been met. To change the output frequency, please modify the <code>time_slice_format</code> value.</p>
<table class="note">
<td class="icon"></td>
<td class="content">This document doesn't describe all parameters. If you want to know full features, check the Further Reading section.</td>
</table>
<a name="install"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#install">Install</a></li>
<li class="toc-item"><a href="#hdfs-configuration">HDFS Configuration</a></li>
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#host-(required)">host (required)</a></li>
<li class="sub-toc-item"><a href="#port-(required)">port (required)</a></li>
<li class="sub-toc-item"><a href="#path-(required)">path (required)</a></li>
</ul>
<li class="toc-item"><a href="#time-sliced-output-parameters-(and-overwritten-values-by-out_webhdfs)">Time Sliced Output Parameters (and overwritten values by out_webhdfs)</a></li>
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
</ul>
<li class="toc-item"><a href="#further-reading">Further Reading</a></li>
</ul>
</section>
<h2>Install</h2>
<p><code>out_webhdfs</code> is included in td-agent by default (v1.1.10 or later). Fluentd gem users will have to install the fluent-plugin-webhdfs gem using the following command.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluent-gem install fluent-plugin-webhdfs
</span></pre>
<a name="hdfs-configuration"></a><h2>HDFS Configuration</h2>
<p>Append operations are not enabled by default on CDH. Please put these configurations into your hdfs-site.xml file and restart the whole cluster.</p>
<pre class="CodeRay">&lt;property&gt;
  &lt;name&gt;dfs.webhdfs.enabled&lt;/name&gt;
  &lt;value&gt;true&lt;/value&gt;
&lt;/property&gt;

&lt;property&gt;
  &lt;name&gt;dfs.support.append&lt;/name&gt;
  &lt;value&gt;true&lt;/value&gt;
&lt;/property&gt;

&lt;property&gt;
  &lt;name&gt;dfs.support.broken.append&lt;/name&gt;
  &lt;value&gt;true&lt;/value&gt;
&lt;/property&gt;
</pre>
<a name="example-configuration"></a><h2>Example Configuration</h2>
<pre class="CodeRay">&lt;match access.**&gt;
  @type webhdfs
  host namenode.your.cluster.local
  port 50070
  path "/path/on/hdfs/access.log.%Y%m%d_%H.#{Socket.gethostname}.log"
  flush_interval 10s
&lt;/match&gt;
</pre>
<p>Please see the <a href="http-to-hdfs">Fluentd + HDFS: Instant Big Data Collection</a> article for real-world use cases.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>webhfds</code>.</p>
<a name="host-(required)"></a><h3>host (required)</h3>
<p>The namenode hostname.</p>
<a name="port-(required)"></a><h3>port (required)</h3>
<p>The namenode port number.</p>
<a name="path-(required)"></a><h3>path (required)</h3>
<p>The path on HDFS. Please include <code>"#{Socket.gethostname}"</code> in your path to avoid writing into the same HDFS file from multiple Fluentd instances. This conflict could result in data loss.</p>
<p>Path value can contain time placeholders (see <code>time_slice_format</code> section). If path contains time placeholders, webhdfs output configures <code>time_slice_format</code> automatically with these placeholders.</p>
<a name="time-sliced-output-parameters-(and-overwritten-values-by-out_webhdfs)"></a><h2>Time Sliced Output Parameters (and overwritten values by out_webhdfs)</h2>
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
<p>The default format is <code>%Y%m%d%H</code>, which creates one file per hour. This parameter may be overwritten by <code>path</code> configuration.</p>
<a name="time_slice_wait"></a><h3>time_slice_wait</h3>
<p>The amount of time Fluentd will wait for old logs to arrive. This is used to account for delays in logs arriving to your Fluentd node. The default wait time is 10 minutes (‘10m’), where Fluentd will wait until 10 minutes past the hour for any logs that occurred within the past hour.</p>
<p>For example, when splitting files on an hourly basis, a log recorded at 1:59 but arriving at the Fluentd node between 2:00 and 2:10 will be uploaded together with all the other logs from 1:00 to 1:59 in one transaction, avoiding extra overhead. Larger values can be set as needed.</p>
<a name="buffer_type"></a><h3>buffer_type</h3>
<p>The buffer type is <code>memory</code> by default (<a href="buf_memory">buf_memory</a>). The <code>file</code> (<a href="buf_file">buf_file</a>) buffer type can be chosen as well. If you use <code>file</code> buffer type, <code>buffer_path</code> parameter is required.</p>
<a name="buffer_queue_limit,-buffer_chunk_limit"></a><h3>buffer_queue_limit, buffer_chunk_limit</h3>
<p>The length of the chunk queue and the size of each chunk, respectively. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure. The default values are 64 and 8m, respectively. The suffixes “k” (KB), “m” (MB), and “g” (GB) can be used for buffer_chunk_limit.</p>
<a name="flush_interval"></a><h3>flush_interval</h3>
<p>The interval between data flushes. The default is unspecified, and buffer chunks will be flushed at the end of time slices. The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used.</p>
<a name="flush_at_shutdown"></a><h3>flush_at_shutdown</h3>
<p>The boolean value to specify whether to flush buffer chunks at shutdown time, or not. The default is true. Specify true if you use <code>memory</code> buffer type.</p>
<a name="retry_wait,-max_retry_wait"></a><h3>retry_wait, max_retry_wait</h3>
<p>The initial and maximum intervals between write retries.  The default values are 1.0 and unset (no limit).  The interval doubles (with +/-12.5% randomness) every retry until <code>max_retry_wait</code> is reached.</p>
<p>Since td-agent will retry 17 times before giving up by default (see the <code>retry_limit</code> parameter for details), the sleep interval can be up to approximately 131072 seconds (roughly 36 hours) in the default configurations.</p>
<a name="retry_limit,-disable_retry_limit"></a><h3>retry_limit, disable_retry_limit</h3>
<p>The limit on the number of retries before buffered data is discarded, and an
option to disable that limit (if true, the value of <code>retry_limit</code> is ignored and
there is no limit).  The default values are 17 and false (not disabled). If the limit is reached, buffered data is discarded and the retry interval is reset to its initial value (<code>retry_wait</code>).</p>
<a name="num_threads"></a><h3>num_threads</h3>
<p>The number of threads to flush the buffer. This option can be used to parallelize writes into the output(s) designated by the output plugin. The default is 1.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="further-reading"></a><h2>Further Reading</h2>
<ul>
<li><a href="https://github.com/fluent/fluent-plugin-webhdfs">fluent-plugin-webhdfs repository</a></li>
<li><a href="http://www.slideshare.net/tagomoris/fluentd-and-webhdfs">Slides: Fluentd and WebHDFS</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-07-01 09:50:35 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_webhdfs">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
