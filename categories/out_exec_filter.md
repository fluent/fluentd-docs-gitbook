<hgroup>
<h1>exec_filter Output Plugin</h1>
</hgroup>
<p>The <code>out_exec_filter</code> Buffered Output plugin (1) executes an external program using an event as input and (2) reads a new event from the program output. It passes tab-separated values (TSV) to stdin and reads TSV from stdout by default.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#command-(required)">command (required)</a></li>
<li class="sub-toc-item"><a href="#num_children">num_children</a></li>
<li class="sub-toc-item"><a href="#child_respawn">child_respawn</a></li>
<li class="sub-toc-item"><a href="#in_format">in_format</a></li>
<li class="sub-toc-item"><a href="#out_format">out_format</a></li>
<li class="sub-toc-item"><a href="#tag_key">tag_key</a></li>
<li class="sub-toc-item"><a href="#time_key">time_key</a></li>
<li class="sub-toc-item"><a href="#time_format">time_format</a></li>
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
<li class="toc-item"><a href="#script-example">Script example</a></li>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>out_exec_filter</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;match pattern&gt;
  @type exec_filter
  command cmd arg arg
  in_keys k1,k2,k3
  out_keys k1,k2,k3,k4
  tag_key k1
  time_key k2
  time_format %Y-%m-%d %H:%M:%S
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>exec_filter</code>.</p>
<a name="command-(required)"></a><h3>command (required)</h3>
<p>The command (program) to execute. The <code>out_exec_filter</code> plugin passes the incoming event to the program input and receives the filtered event from the program output.</p>
<a name="num_children"></a><h3>num_children</h3>
<p>The number of spawned process for <code>command</code>. Default is 1.</p>
<p>If the number is larger than 2, fluentd uses spawned processes by round robin fashion.</p>
<a name="child_respawn"></a><h3>child_respawn</h3>
<p>Respawn command when command exit. Default is disabled.</p>
<p>If you specify a positive number, try to respawn until specified times.
If you specify <code>inf</code> or <code>-1</code>, try to respawn forever.</p>
<a name="in_format"></a><h3>in_format</h3>
<p>The format used to map the incoming event to the program input.</p>
<p>The following formats are supported:</p>
<ul>
<li>tsv (default)</li>
</ul>
<p>When using the tsv format, please also specify the comma-separated <code>in_keys</code> parameter.</p>
<pre class="CodeRay">in_keys k1,k2,k3
</pre>
<ul>
<li>json</li>
<li>msgpack</li>
</ul>
<a name="out_format"></a><h3>out_format</h3>
<p>The format used to process the program output.</p>
<p>The following formats are supported:</p>
<ul>
<li>tsv (default)</li>
</ul>
<p>When using the tsv format, please also specify the comma-separated <code>out_keys</code> parameter.</p>
<pre class="CodeRay">out_keys k1,k2,k3,k4
</pre>
<ul>
<li>json</li>
<li>msgpack</li>
</ul>
<table class="note">
<td class="icon"></td>
<td class="content">When using the json format, this plugin uses the Yajl library to parse the program output. Yajl buffers data internally so the output isn't always instantaneous.</td>
</table>
<a name="tag_key"></a><h3>tag_key</h3>
<p>The name of the key to use as the event tag. This replaces the value in the event record.</p>
<a name="time_key"></a><h3>time_key</h3>
<p>The name of the key to use as the event time. This replaces the the value in the event record.</p>
<a name="time_format"></a><h3>time_format</h3>
<p>The format for event time used when the <code>time_key</code> parameter is specified. The default is UNIX time (integer).</p>
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
<a name="script-example"></a><h2>Script example</h2>
<p>Here is an example writtein in ruby.</p>
<pre class="CodeRay">require <span class="string"><span class="delimiter">'</span><span class="content">json</span><span class="delimiter">'</span></span>
require <span class="string"><span class="delimiter">'</span><span class="content">msgpack</span><span class="delimiter">'</span></span>

<span class="keyword">begin</span>
  <span class="keyword">while</span> line = <span class="predefined-constant">STDIN</span>.gets <span class="comment"># continue to read a event from stdin</span>
    line.chomp!

    <span class="comment"># Input format depends on exec_filter's in_format setting</span>
    json = <span class="constant">JSON</span>.parse(line)

    <span class="comment"># main processing. You can do anything, mutate record, access to database and etc.</span>
    json[<span class="string"><span class="delimiter">'</span><span class="content">new_field</span><span class="delimiter">'</span></span>] = <span class="string"><span class="delimiter">"</span><span class="content">Hey from exec_filter script!</span><span class="delimiter">"</span></span>

    <span class="comment"># Write data to stdout. Output format depends on exec_filter's out_format setting</span>
    <span class="predefined-constant">STDOUT</span>.print <span class="constant">MessagePack</span>.pack(json)

    <span class="comment"># Call flush to avoid buffering events</span>
    <span class="predefined-constant">STDOUT</span>.flush
  <span class="keyword">end</span>
<span class="keyword">rescue</span> <span class="constant">Interrupt</span> <span class="comment"># Ignore Interrupt exception because it happens during exec_filter shutdown</span>
<span class="keyword">end</span>
</pre>
<p>Corresponding configuration is below:</p>
<pre class="CodeRay">&lt;match test.**&gt;
  @type exec_filter
  command ruby /path/to/ruby_script.rb
  in_format json
  out_format msgpack
  flush_interval 10s
  tag filtered.exec
&lt;/match&gt;
</pre>
<p>If you want to use other language, translate above script example into your language.</p>
<div style="text-align:right">
  Last updated: 2016-04-12 21:53:18 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_exec_filter">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
