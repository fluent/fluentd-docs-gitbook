<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_multiline">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>multiline Parser Plugin</h1>
</hgroup>
<p>The <code>multiline</code> parser plugin parses multiline logs. This plugin is multiline version of <code>regexp</code> parser.</p>
<p>The <code>multiline</code> parser parses log with <code>formatN</code> and <code>format_firstline</code> parameters.
<code>format_firstline</code> is for detecting start line of multiline log.
<code>formatN</code>, N’s range is 1..20, is the list of Regexp format for multiline log.</p>
<table class="note">
<td class="icon"></td>
<td class="content">Unlike other parser plugins, this plugin needs special code in input plugin, e.g. handle format_firstline. So currently, in_tail plugin works with `multiline` but other input plugins don't work with `multiline`.</td>
</table>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#time_key">time_key</a></li>
<li class="sub-toc-item"><a href="#time_format">time_format</a></li>
<li class="sub-toc-item"><a href="#format_firstline">format_firstline</a></li>
<li class="sub-toc-item"><a href="#formatn">formatN</a></li>
<li class="sub-toc-item"><a href="#keep_time_key">keep_time_key</a></li>
</ul>
<li class="toc-item"><a href="#example">Example</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#rails-log">Rails log</a></li>
<li class="sub-toc-item"><a href="#java-stacktrace-log">Java stacktrace log</a></li>
</ul>
</ul>
</section>
<h2>Parameters</h2>
<a name="time_key"></a><h3>time_key</h3>
<p>Specify the field for event time. Default is <code>time</code>.</p>
<a name="time_format"></a><h3>time_format</h3>
<p>Specify time format for <code>time_key</code>.</p>
<p>See <a href="http://ruby-doc.org/stdlib-2.4.1/libdoc/time/rdoc/Time.html#method-c-strptime">Time#strptime</a> for additional format information.</p>
<a name="format_firstline"></a><h3>format_firstline</h3>
<p>Specify regexp pattern for start line of multiple lines. Input plugin can skip the logs until <code>format_firstline</code> is matched. Default is <code>nil</code>.</p>
<p>If <code>format_firstline</code> is not specified, input plugin should store unmatched new lines in temporary buffer and try to match buffered logs with each new line.</p>
<a name="formatn"></a><h3>formatN</h3>
<p>Specify regexp patterns. For readability, you can separate regexp patterns into multiple regexpN parameters, See “Rails log” example. These patterns are joined and constructs regexp pattern with multiline mode.</p>
<a name="keep_time_key"></a><h3>keep_time_key</h3>
<p>If you want to keep time field in the record, set <code>true</code>. Default is <code>false</code>.</p>
<a name="example"></a><h2>Example</h2>
<a name="rails-log"></a><h3>Rails log</h3>
<pre class="CodeRay">format multiline
format_firstline /^Started/
format1 /Started (?&lt;method&gt;[^ ]+) "(?&lt;path&gt;[^"]+)" for (?&lt;host&gt;[^ ]+) at (?&lt;time&gt;[^ ]+ [^ ]+ [^ ]+)\n/
format2 /Processing by (?&lt;controller&gt;[^\u0023]+)\u0023(?&lt;controller_method&gt;[^ ]+) as (?&lt;format&gt;[^ ]+?)\n/
format3 /(  Parameters: (?&lt;parameters&gt;[^ ]+)\n)?/
format4 /  Rendered (?&lt;template&gt;[^ ]+) within (?&lt;layout&gt;.+) \([\d\.]+ms\)\n/
format5 /Completed (?&lt;code&gt;[^ ]+) [^ ]+ in (?&lt;runtime&gt;[\d\.]+)ms \(Views: (?&lt;view_runtime&gt;[\d\.]+)ms \| ActiveRecord: (?&lt;ar_runtime&gt;[\d\.]+)ms\)/
</pre>
<p>With this configuration:</p>
<pre class="CodeRay">Started GET "/users/123/" for 127.0.0.1 at 2013-06-14 12:00:11 +0900
Processing by UsersController#show as HTML
  Parameters: {"user_id"=&gt;"123"}
  Rendered users/show.html.erb within layouts/application (0.3ms)
Completed 200 OK in 4ms (Views: 3.2ms | ActiveRecord: 0.0ms)
</pre>
<p>This incoming event is parsed as:</p>
<pre class="CodeRay">time:
1371178811 (2013-06-14 12:00:11 +0900)

record:
{
  "method"           :"GET",
  "path"             :"/users/123/",
  "host"             :"127.0.0.1",
  "controller"       :"UsersController",
  "controller_method":"show",
  "format"           :"HTML",
  "parameters"       :"{ \"user_id\":\"123\"}",
  ...
}
</pre>
<a name="java-stacktrace-log"></a><h3>Java stacktrace log</h3>
<pre class="CodeRay">format multiline
format_firstline /\d{4}-\d{1,2}-\d{1,2}/
format1 /^(?&lt;time&gt;\d{4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}) \[(?&lt;thread&gt;.*)\] (?&lt;level&gt;[^\s]+)(?&lt;message&gt;.*)/
</pre>
<p>With this configuration:</p>
<pre class="CodeRay">2013-3-03 14:27:33 [main] INFO  Main - Start
2013-3-03 14:27:33 [main] ERROR Main - Exception
javax.management.RuntimeErrorException: null
    at Main.main(Main.java:16) ~[bin/:na]
2013-3-03 14:27:33 [main] INFO  Main - End
</pre>
<p>These incoming events are parsed as:</p>
<pre class="CodeRay">time:
2013-03-03 14:27:33 +0900
record:
{
  "thread" :"main",
  "level"  :"INFO",
  "message":"  Main - Start"
}

time:
2013-03-03 14:27:33 +0900
record:
{
  "thread" :"main",
  "level"  :"ERROR",
  "message":" Main - Exception\njavax.management.RuntimeErrorException: null\n    at Main.main(Main.java:16) ~[bin/:na]"
}

time:
2013-03-03 14:27:33 +0900
record:
{
  "thread" :"main",
  "level"  :"INFO",
  "message":"  Main - End"
}
</pre>
<div style="text-align:right">
  Last updated: 2018-10-19 00:26:13 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_multiline">v1.0 (td-agent3)</a>
    
  

  

  
    
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