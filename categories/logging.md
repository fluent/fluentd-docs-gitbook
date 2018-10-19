<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/logging">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Logging of Fluentd</h1>
</hgroup>
<p>This article describes Fluentd’s logging mechanism.</p>
<p>Fluentd has two log layers: global and per plugin. Different log levels can be set for global logging and plugin level logging.</p>
<a name="log-level"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#log-level">Log Level</a></li>
<li class="toc-item"><a href="#global-logs">Global Logs</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#by-command-line-option">By Command Line Option</a></li>
<li class="sub-toc-item"><a href="#by-config-file">By Config File</a></li>
</ul>
<li class="toc-item"><a href="#per-plugin-log">Per Plugin Log</a></li>
<li class="toc-item"><a href="#suppress-repeated-stacktrace">Suppress repeated stacktrace</a></li>
<li class="toc-item"><a href="#output-to-log-file">Output to log file</a></li>
<li class="toc-item"><a href="#capture-fluentd-logs">Capture Fluentd logs</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#case1:-send-fluentd-logs-to-monitoring-service">Case1: Send Fluentd logs to monitoring service</a></li>
<li class="sub-toc-item"><a href="#case2:-use-aggregation/monitoring-server">Case2: Use aggregation/monitoring server</a></li>
</ul>
</ul>
</section>
<h2>Log Level</h2>
<p>Shown below is the list of supported values, in increasing order of verbosity:</p>
<ul>
<li><code>fatal</code></li>
<li><code>error</code></li>
<li><code>warn</code></li>
<li><code>info</code></li>
<li><code>debug</code></li>
<li><code>trace</code></li>
</ul>
<p>The default log level is <code>info</code>, and Fluentd outputs <code>info</code>, <code>warn</code>, <code>error</code> and <code>fatal</code> logs by default.</p>
<a name="global-logs"></a><h2>Global Logs</h2>
<p>Global logging is used by Fluentd core and plugins that don’t set their own log levels.
The global log level can be adjusted up or down.</p>
<a name="by-command-line-option"></a><h3>By Command Line Option</h3>
<h4>Increase Verbosity Level</h4>
<p>The <code>-v</code> option sets the verbosity to <code>debug</code> while the <code>-vv</code> option sets the verbosity to <code>trace</code>.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluentd -v  ... # debug level
</span><span class="comment">$</span><span class="function"> fluentd -vv ... # trace level
</span></pre>
<p>These options are useful for debugging purposes.</p>
<h4>Decrease Verbosity Level</h4>
<p>The <code>-q</code> option sets the verbosity to <code>warn</code> while the <code>-qq</code> option sets the verbosity to <code>error</code>.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluentd -q  ... # warn level
</span><span class="comment">$</span><span class="function"> fluentd -qq ... # error level
</span></pre>
<a name="by-config-file"></a><h3>By Config File</h3>
<p>You can also change the logging level with <code>&lt;system&gt;</code> section in the config file like below.</p>
<pre class="CodeRay"><span class="string">&lt;system&gt;
</span><span class="string">  # equal to -qq option
</span><span class="string">  log_level error
</span><span class="string">&lt;/system&gt;
</span></pre>
<a name="per-plugin-log"></a><h2>Per Plugin Log</h2>
<p>The <code>log_level</code> option sets different levels of logging for each plugin. It can be set in each plugin’s configuration file.</p>
<p>For example, in order to debug <a href="in_tail">in_tail</a> but suppress all but fatal log messages for <a href="in_http">in_http</a>, their respective <code>log_level</code> options should be set as follows:</p>
<pre class="CodeRay">&lt;source&gt;
  @type tail
  @log_level debug
  path /var/log/data.log
  ...
&lt;/source&gt;
&lt;source&gt;
  @type http
  @log_level fatal
&lt;/source&gt;
</pre>
<p>If you don’t specify the <code>log_level</code> parameter, the plugin will use the global log level.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Some plugins haven't supported per-plugin logging yet. The <a href="plugin-development#logging">logging section of the Plugin Development article</a> explains how to update such plugins to support the new log level system.</td>
</table>
<a name="suppress-repeated-stacktrace"></a><h2>Suppress repeated stacktrace</h2>
<p>Fluentd can suppress same stacktrace with <code>--suppress-repeated-stacktrace</code>.
For example, if you pass <code>--suppress-repeated-stacktrace</code> to fluentd:</p>
<pre class="CodeRay"><span class="string">2013-12-04 15:05:53 +0900 [warn]: fluent/engine.rb:154:rescue in emit_stream: emit transaction failed  error_class = RuntimeError error = #&lt;RuntimeError: syslog&gt;
</span><span class="string">  2013-12-04 15:05:53 +0900 [warn]: fluent/engine.rb:140:emit_stream: /Users/repeatedly/devel/fluent/fluentd/lib/fluent/plugin/out_stdout.rb:43:in `emit'
</span><span class="string">  [snip]
</span><span class="string">  2013-12-04 15:05:53 +0900 [warn]: fluent/engine.rb:140:emit_stream: /Users/repeatedly/devel/fluent/fluentd/lib/fluent/plugin/in_object_space.rb:63:in `run'
</span><span class="string">2013-12-04 15:05:53 +0900 [error]: plugin/in_object_space.rb:113:rescue in on_timer: object space failed to emit error = "foo.bar" error_class = "RuntimeError" tag = "foo" record = "{ ...}"
</span><span class="string">2013-12-04 15:05:55 +0900 [warn]: fluent/engine.rb:154:rescue in emit_stream: emit transaction failed  error_class = RuntimeError error = #&lt;RuntimeError: syslog&gt;
</span><span class="string">  2013-12-04 15:05:53 +0900 [warn]: fluent/engine.rb:140:emit_stream: /Users/repeatedly/devel/fluent/fluentd/lib/fluent/plugin/o/2.0.0/gems/cool.io-1.1.1/lib/cool.io/loop.rb:96:in `run'
</span><span class="string">  [snip]
</span></pre>
<p>logs are changed to:</p>
<pre class="CodeRay"><span class="string">2013-12-04 15:05:53 +0900 [warn]: fluent/engine.rb:154:rescue in emit_stream: emit transaction failed  error_class = RuntimeError error = #&lt;RuntimeError: syslog&gt;
</span><span class="string">  2013-12-04 15:05:53 +0900 [warn]: fluent/engine.rb:140:emit_stream: /Users/repeatedly/devel/fluent/fluentd/lib/fluent/plugin/o/2.0.0/gems/cool.io-1.1.1/lib/cool.io/loop.rb:96:in `run'
</span><span class="string">  [snip]
</span><span class="string">  2013-12-04 15:05:53 +0900 [warn]: fluent/engine.rb:140:emit_stream: /Users/repeatedly/devel/fluent/fluentd/lib/fluent/plugin/in_object_space.rb:63:in `run'
</span><span class="string">2013-12-04 15:05:53 +0900 [error]: plugin/in_object_space.rb:113:rescue in on_timer: object space failed to emit error = "foo.bar" error_class = "RuntimeError" tag = "foo" record = "{ ...}"
</span><span class="string">2013-12-04 15:05:55 +0900 [warn]: fluent/engine.rb:154:rescue in emit_stream: emit transaction failed  error_class = RuntimeError error = #&lt;RuntimeError: syslog&gt;
</span><span class="string">  2013-12-04 15:05:55 +0900 [warn]: plugin/in_object_space.rb:111:on_timer: suppressed same stacktrace
</span></pre>
<p>Same stacktrace is replaced with <code>suppressed same stacktrace</code> message until other stacktrace is received.</p>
<a name="output-to-log-file"></a><h2>Output to log file</h2>
<p>Fluentd outputs logs to <code>STDOUT</code> by default. To output to a file instead, please specify the <code>-o</code> option.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluentd -o /path/to/log_file
</span></pre>
<table class="note">
<td class="icon"></td>
<td class="content">Fluentd doesn't support log rotation yet.</td>
</table>
<a name="capture-fluentd-logs"></a><h2>Capture Fluentd logs</h2>
<p>Fluentd marks its own logs with the <code>fluent</code> tag. You can process Fluentd logs by using <code>&lt;match fluent.**&gt;</code> or <code>&lt;match **&gt;</code>(Of course, <code>**</code> captures other logs). If you define <code>&lt;match fluent.**&gt;</code> in your configuration, then Fluentd will send its own logs to this match destination. This is useful for monitoring Fluentd logs.</p>
<p>For example, if you have the following <code>&lt;match fluent.**&gt;</code>:</p>
<pre class="CodeRay"># omit other source / match
&lt;match fluent.**&gt;
  @type stdout
&lt;/match&gt;
</pre>
<p>then Fluentd outputs <code>fluent.info</code> logs to stdout like below:</p>
<pre class="CodeRay">2014-02-27 00:00:00 +0900 [info]: shutting down fluentd
2014-02-27 00:00:01 +0900 fluent.info: {"message":"shutting down fluentd"} # by &lt;match fluent.**&gt;
2014-02-27 00:00:01 +0900 [info]: process finished code = 0
</pre>
<a name="case1:-send-fluentd-logs-to-monitoring-service"></a><h3>Case1: Send Fluentd logs to monitoring service</h3>
<p>You can send Fluentd logs to a monitoring service by plugins, e.g. datadog, sentry, irc, etc.</p>
<pre class="CodeRay"># Add hostname for identifying the server
&lt;filter fluent.**&gt;
  @type record_transformer
  &lt;record&gt;
    host "#{Socket.gethostname}"
  &lt;/record&gt;
&lt;/filter&gt;

&lt;match fluent.**&gt;
  @type monitoring_plugin
  # parameters...
&lt;/match&gt;
</pre>
<a name="case2:-use-aggregation/monitoring-server"></a><h3>Case2: Use aggregation/monitoring server</h3>
<p>You can use <a href="out_forward">out_forward</a> to send Fluentd logs to a monitoring server.
The monitoring server can then filter and send the logs to your notification system: chat, irc, etc.</p>
<p>Leaf server example:</p>
<pre class="CodeRay"># Add hostname for identifying the server and tag to filter by log level
&lt;filter fluent.**&gt;
  @type record_transformer
  &lt;record&gt;
    host "#{Socket.gethostname}"
    original_tag ${tag}
  &lt;/record&gt;
&lt;/filter&gt;

&lt;match fluent.**&gt;
  @type forward
  &lt;server&gt;
    # Monitoring server parameters
  &lt;/server&gt;
&lt;/match&gt;
</pre>
<p>Monitoring server example:</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
  label @FLUENTD_INTERNAL_LOG
&lt;/source&gt;

&lt;label @FLUENTD_INTERNAL_LOG&gt;
  # Ignore trace, debug and info log
  &lt;filter fluent.**&gt;
    @type grep
    regexp1 original_tag fluent.(warn|error|fatal)
  &lt;/filter&gt;

  &lt;match fluent.**&gt;
    # your notification setup. This example uses irc plugin
    @type irc
    host irc.domain
    channel notify
    message notice: %s [%s] @%s %s
    out_keys original_tag,time,host,message
  &lt;/match&gt;
&lt;/label&gt;
</pre>
<p>If an error occurs, you will get a notification message in your irc <code>notify</code> channel.</p>
<pre class="CodeRay">01:01  fluentd: [11:10:24] notice: fluent.warn [2014/02/27 01:00:00] @leaf.server.domain detached forwarding server 'server.name'
</pre>
<div style="text-align:right">
  Last updated: 2016-07-01 09:50:35 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/logging">v1.0 (td-agent3)</a>
    
  

  

  
    
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