<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_tail">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>tail Input Plugin</h1>
</hgroup>
<p>The <code>in_tail</code> Input plugin allows Fluentd to read events from the tail of text files. Its behavior is similar to the <code>tail -F</code> command.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#how-it-works">How it Works</a></li>
</ul>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#tag-(required)">tag (required)</a></li>
<li class="sub-toc-item"><a href="#path-(required)">path (required)</a></li>
<li class="sub-toc-item"><a href="#exclude_path">exclude_path</a></li>
<li class="sub-toc-item"><a href="#refresh_interval">refresh_interval</a></li>
<li class="sub-toc-item"><a href="#limit_recently_modified">limit_recently_modified</a></li>
<li class="sub-toc-item"><a href="#skip_refresh_on_startup">skip_refresh_on_startup</a></li>
<li class="sub-toc-item"><a href="#read_from_head">read_from_head</a></li>
<li class="sub-toc-item"><a href="#encoding,-from_encoding">encoding, from_encoding</a></li>
<li class="sub-toc-item"><a href="#read_lines_limit">read_lines_limit</a></li>
<li class="sub-toc-item"><a href="#multiline_flush_interval">multiline_flush_interval</a></li>
<li class="sub-toc-item"><a href="#pos_file-(highly-recommended)">pos_file (highly recommended)</a></li>
<li class="sub-toc-item"><a href="#format-(required)">format (required)</a></li>
<li class="sub-toc-item"><a href="#path_key">path_key</a></li>
<li class="sub-toc-item"><a href="#rotate_wait">rotate_wait</a></li>
<li class="sub-toc-item"><a href="#enable_watch_timer">enable_watch_timer</a></li>
<li class="sub-toc-item"><a href="#ignore_repeated_permission_error">ignore_repeated_permission_error</a></li>
</ul>
<li class="toc-item"><a href="#faq">FAQ</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#in_tail-doesn%E2%80%99t-start-to-read-log-file,-why?">in_tail doesn’t start to read log file, why?</a></li>
<li class="sub-toc-item"><a href="#logrotate-setting">logrotate setting</a></li>
<li class="sub-toc-item"><a href="#what-happens-when-in_tail-receives-bufferqueuelimiterror?">What happens when in_tail receives BufferQueueLimitError?</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>in_tail</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;source&gt;
  @type tail
  path /var/log/httpd-access.log
  pos_file /var/log/td-agent/httpd-access.log.pos
  tag apache.access
  format apache2
&lt;/source&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="how-it-works"></a><h3>How it Works</h3>
<ul>
<li>When Fluentd is first configured with <code>in_tail</code>, it will start reading from the <strong>tail</strong> of that log, not the beginning.</li>
<li>Once the log is rotated, Fluentd starts reading the new file from the beginning. It keeps track of the current inode number.</li>
<li>If <code>td-agent</code> restarts, it starts reading from the last position td-agent read before the restart. This position is recorded in the position file specified by the pos_file parameter.</li>
</ul>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>tail</code>.</p>
<a name="tag-(required)"></a><h3>tag (required)</h3>
<p>The tag of the event.</p>
<p><code>*</code> can be used as a placeholder that expands to the actual file path, replacing ‘/’ with ‘.’. For example, if you have the following configuration</p>
<pre class="CodeRay">path /path/to/file
tag foo.*
</pre>
<p>in_tail emits the parsed events with the ‘foo.path.to.file’ tag.</p>
<a name="path-(required)"></a><h3>path (required)</h3>
<p>The paths to read. Multiple paths can be specified, separated by ‘,’.</p>
<p><code>*</code> and strftime format can be included to add/remove watch file dynamically. At interval of <code>refresh_interval</code>, Fluentd refreshes the list of watch file.</p>
<pre class="CodeRay">path /path/to/%Y/%m/%d/*
</pre>
<p>If the date is 20140401, Fluentd starts to watch the files in /path/to/2014/04/01 directory. See also <code>read_from_head</code> parameter.</p>
<table class="note">
<td class="icon"></td>
<td class="content">You should not use '*' with log rotation because it may cause the log duplication. In such case, you should separate in_tail plugin configuration.</td>
</table>
<a name="exclude_path"></a><h3>exclude_path</h3>
<p>The paths to exclude the files from watcher list. For example, if you want to remove compressed files, you can use following pattern.</p>
<pre class="CodeRay">path /path/to/*
exclude_path ["/path/to/*.gz", "/path/to/*.zip"]
</pre>
<a name="refresh_interval"></a><h3>refresh_interval</h3>
<p>The interval of refreshing the list of watch file. Default is 60 seconds.</p>
<a name="limit_recently_modified"></a><h3>limit_recently_modified</h3>
<p>This parameter is available since v0.12.33.</p>
<p>Limit the watching files that the modification time is within the specified time range when use <code>*</code> in <code>path</code> parameter.</p>
<a name="skip_refresh_on_startup"></a><h3>skip_refresh_on_startup</h3>
<p>This parameter is available since v0.12.33.</p>
<p>Skip the refresh of watching list on startup. This reduces the start up time when use <code>*</code> in <code>path</code>.</p>
<a name="read_from_head"></a><h3>read_from_head</h3>
<p>Start to read the logs from the head of file, not bottom. The default is <code>false</code>.</p>
<p>If you want to tail all contents with <code>*</code> or strftime dynamic path, set this parameter to <code>true</code>.
Instead, you should guarantee that log rotation will not occur in <code>*</code> directory.</p>
<table class="note">
<td class="icon"></td>
<td class="content">When this is true, in_tail tries to read a file during start up phase. If target file is large, it takes long time and starting other plugins isn't executed until reading file is finished.</td>
</table>
<a name="encoding,-from_encoding"></a><h3>encoding, from_encoding</h3>
<p>Specify the encoding of reading lines. The default is ASCII-8BIT.</p>
<p>By default, in_tail emits string value as ASCII-8BIT encoding. These options change it.</p>
<ul>
<li>If specify only <code>encoding</code>, in_tail changes string to <code>encoding</code>. This use ruby’s <a href="https://docs.ruby-lang.org/en/trunk/String.html#method-i-force_encoding">String#force_encoding</a>
</li>
<li>If specify <code>encoding</code> and <code>from_encoding</code>, in_tail tries to encode string from <code>from_encoding</code> to <code>encoding</code>. This uses ruby’s <a href="https://docs.ruby-lang.org/en/trunk/String.html#method-i-encode">String#encode</a>
</li>
</ul>
<p>You can get supported encoding list by typing following command:</p>
<pre class="CodeRay">$ ruby -e 'p Encoding.name_list.sort'
</pre>
<a name="read_lines_limit"></a><h3>read_lines_limit</h3>
<p>The number of reading lines at each IO. Default is 1000 lines.</p>
<p>If you see “Size of the emitted data exceeds buffer_chunk_limit.” log with in_tail, set smaller value.</p>
<a name="multiline_flush_interval"></a><h3>multiline_flush_interval</h3>
<p>The interval of flushing the buffer for multiline format. The default is disabled.</p>
<p>If you set <code>multiline_flush_interval 5s</code>, in_tail flushes buffered event after 5 seconds from last emit. This option is useful when you use <code>format_firstline</code> option. Since v0.12.20 or later.</p>
<a name="pos_file-(highly-recommended)"></a><h3>pos_file (highly recommended)</h3>
<p>This parameter is highly recommended. Fluentd will record the position it last read into this file.</p>
<pre class="CodeRay">pos_file /var/log/td-agent/tmp/access.log.pos
</pre>
<p><code>pos_file</code> handles multiple positions in one file so no need multiple <code>pos_file</code> parameters per <code>source</code>.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Don't share pos_file between in_tail configurations. It causes unexpected behavior, e.g. corrupt pos_file content.</td>
</table>
<table class="note">
<td class="icon"></td>
<td class="content">in_tail removes untracked file position during startup phase. It means the content of pos_file is growing until restart
when you tails lots of files with dynamic path setting. I will fix this problem in the future. Check <a href="https://github.com/fluent/fluentd/issues/1126">this issue</a>.</td>
</table>
<a name="format-(required)"></a><h3>format (required)</h3>
<p>The format of the log. <code>in_tail</code> uses parser plugin to parse the log. See <a href="parser-plugin-overview">parser article</a> for more detail.</p>
<a name="path_key"></a><h3>path_key</h3>
<p>Add watching file path to <code>path_key</code> field.</p>
<pre class="CodeRay">path /path/to/access.log
path_key tailed_path
</pre>
<p>With this config, generated events are like <code>{"tailed_path":"/path/to/access.log","k1":"v1",...,"kN":"vN"}</code>.</p>
<a name="rotate_wait"></a><h3>rotate_wait</h3>
<p>in_tail actually does a bit more than <code>tail -F</code> itself. When rotating a file, some data may still need to be written to the old file as opposed to the new one.</p>
<p>in_tail takes care of this by keeping a reference to the old file (even after it has been rotated) for some time before transitioning completely to the new file. This helps prevent data designated for the old file from getting lost. By default, this time interval is 5 seconds.</p>
<p>The rotate_wait parameter accepts a single integer representing the number of seconds you want this time interval to be.</p>
<a name="enable_watch_timer"></a><h3>enable_watch_timer</h3>
<p>Enable the additional watch timer.  Setting this parameter to <code>false</code> will significantly reduce CPU and I/O consumption when tailing a large number of files on systems with inotify support.  The default is <code>true</code> which results in an additional 1 second timer being used.</p>
<p><code>in_tail</code> (via Cool.io) uses inotify on systems which support it.  Earlier versions of libev on some platforms (eg Mac OS X) did not work properly; therefore, an explicit 1 second timer was used.  Even on systems with inotify support, this results in additional I/O each second, for every file being tailed.</p>
<p>Early testing demonstrates that modern Cool.io and <code>in_tail</code> work properly without the additional watch timer.  At some point in the future, depending on feedback and testing, the additional watch timer may be disabled by default.</p>
<a name="ignore_repeated_permission_error"></a><h3>ignore_repeated_permission_error</h3>
<p>If you hard to exclude non-permision files from watching list, set this parameter to <code>true</code>.
It suppress repeated permission error logs.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="faq"></a><h2>FAQ</h2>
<a name="in_tail-doesn%E2%80%99t-start-to-read-log-file,-why?"></a><h3>in_tail doesn’t start to read log file, why?</h3>
<p><code>in_tail</code> follows <code>tail -F</code> command behaviour by default, so <code>in_tail</code> reads only newer logs. If you want to read existing lines for batch use case, set <code>read_from_head true</code>.</p>
<a name="logrotate-setting"></a><h3>logrotate setting</h3>
<p><code>logrotate</code> has <code>nocreate</code> parameter and it doesn’t create new file after triggered log rotation. It means <code>in_tail</code> can’t find new file to tail.</p>
<p>This parameter doesn’t fit typical application log cases, so check your <code>logrotate</code> setting which doesn’t include <code>nocreate</code> parameter.</p>
<a name="what-happens-when-in_tail-receives-bufferqueuelimiterror?"></a><h3>What happens when in_tail receives BufferQueueLimitError?</h3>
<p>in_tail stops reading new lines and pos file update until BufferQueueLimitError is resolved. After resolved BufferQueueLimitError, restart emitting new lines and pos file update.</p>
<div style="text-align:right">
  Last updated: 2017-03-16 10:35:45 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_tail">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>