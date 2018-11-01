<hgroup>
<h1>memory Buffer Plugin</h1>
</hgroup>
<p>The <code>memory</code> buffer plugin provides a fast buffer implementation. It uses memory to store buffer chunks. When Fluentd is shut down, buffered logs that can’t be written quickly are deleted.</p>
<a name="example-config"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-config">Example Config</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
</ul>
</section>
<h2>Example Config</h2>
<pre class="CodeRay">&lt;match pattern&gt;
  buffer_type memory
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<h4>buffer_type (required)</h4>
<p>The value must be <code>memory</code>.</p>
<h4>buffer_chunk_limit</h4>
<p>The size of each buffer chunk. The default is 8m. The suffixes “k” (KB), “m” (MB), and “g” (GB) can be used. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure.</p>
<h4>buffer_queue_limit</h4>
<p>The length limit of the chunk queue. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure. The default limit is 64 chunks.</p>
<h4>flush_interval</h4>
<p>The interval between data flushes. The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used</p>
<h4>flush_at_shutdown</h4>
<p>If true, queued chunks are flushed at shutdown process. The default is <code>true</code>.
If false, queued chunks are discarded unlike <code>buf_file</code>.</p>
<h4>retry_wait</h4>
<p>The interval between retries. The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used.</p>
<div style="text-align:right">
  Last updated: 2016-10-21 06:29:58 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/buf_memory">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
