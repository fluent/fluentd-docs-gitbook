<hgroup>
<h1>file Buffer Plugin</h1>
</hgroup>
<p>The <code>file</code> buffer plugin provides a persistent buffer implementation. It uses files to store buffer chunks on disk.</p>
<a name="example-config"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-config">Example Config</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<li class="toc-item"><a href="#caution">Caution</a></li>
</ul>
</section>
<h2>Example Config</h2>
<pre class="CodeRay">&lt;match pattern&gt;
  buffer_type file
  buffer_path /var/log/fluent/myapp.*.buffer
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<h4>buffer_type (required)</h4>
<p>The value must be <code>file</code>.</p>
<h4>buffer_path (required)</h4>
<p>The path where buffer chunks are stored. The ‘*’ is replaced with random characters. This parameter is require</p>
<p>This parameter must be unique to avoid race condition problem. For example, you can’t use fixed buffer_path parameter in fluent-plugin-forest. <code>${tag}</code> or similar placeholder is needed. Of course, this parameter must also be unique between fluentd instances.</p>
<p>In addition, <code>buffer_path</code> should not be an other <code>buffer_path</code> prefix. For example, the following conf doesn’t work well. <code>/var/log/fluent/foo</code> resumes <code>/var/log/fluent/foo.bar</code>’s buffer files during start phase and it causes <code>No such file or directory</code> in <code>/var/log/fluent/foo.bar</code> side.</p>
<pre class="CodeRay">&lt;match pattern1&gt;
    buffer_path /var/log/fluent/foo
&lt;/match&gt;

&lt;match pattern2&gt;
    buffer_path /var/log/fluent/foo.bar
&lt;/match&gt;
</pre>
<p>Here is the correct version to avoid prefix problem.</p>
<pre class="CodeRay">&lt;match pattern1&gt;
    buffer_path /var/log/fluent/foo.baz
&lt;/match&gt;

&lt;match pattern2&gt;
    buffer_path /var/log/fluent/foo.bar
&lt;/match&gt;
</pre>
<h4>buffer_chunk_limit</h4>
<p>The size of each buffer chunk. The default is 8m. The suffixes “k” (KB), “m” (MB), and “g” (GB) can be used. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure.</p>
<table class="note">
<td class="icon"></td>
<td class="content">The default value for Time Sliced Plugin is overwritten as 256m.</td>
</table>
<h4>buffer_queue_limit</h4>
<p>The length limit of the chunk queue. Please see the <a href="buffer-plugin-overview">Buffer Plugin Overview</a> article for the basic buffer structure. The default limit is 256 chunks.</p>
<h4>flush_interval</h4>
<p>The interval between data flushes. The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used</p>
<h4>flush_at_shutdown</h4>
<p>If true, queued chunks are flushed at shutdown process. The default is <code>false</code>.</p>
<h4>retry_wait</h4>
<p>The interval between retries. The suffixes “s” (seconds), “m” (minutes), and “h” (hours) can be used.</p>
<p>Limitation</p>
<a name="caution"></a><h2>Caution</h2>
<p><code>file</code> buffer implementation depends on the characteristics of local file system. Don’t use <code>file</code> buffer on remote file system, e.g. NFS, GlusterFS, HDFS and etc. We observed major data loss by using remote file system.</p>
<div style="text-align:right">
  Last updated: 2016-12-07 10:53:25 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/buf_file">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
