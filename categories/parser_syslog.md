<hgroup>
<h1>syslog Parser Plugin</h1>
</hgroup>
<p>The <code>syslog</code> parser plugin parses syslog generated logs. This plugin supports two RFC formats, rfc3164 and rfc5424.</p>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#time_format">time_format</a></li>
<li class="sub-toc-item"><a href="#message_format">message_format</a></li>
<li class="sub-toc-item"><a href="#with_priority">with_priority</a></li>
<li class="sub-toc-item"><a href="#keep_time_key">keep_time_key</a></li>
</ul>
<li class="toc-item"><a href="#regexp-patterns">Regexp patterns</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#rfc3164-pattern">rfc3164 pattern</a></li>
<li class="sub-toc-item"><a href="#rfc5424-pattern">rfc5424 pattern</a></li>
</ul>
<li class="toc-item"><a href="#example">Example</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#rfc3164-log">rfc3164 log</a></li>
<li class="sub-toc-item"><a href="#rfc5424-log">rfc5424 log</a></li>
</ul>
</ul>
</section>
<h2>Parameters</h2>
<a name="time_format"></a><h3>time_format</h3>
<p>Specify time format for event time. Default is “%b %d %H:%M:%S” for rfc3164 protocol.</p>
<a name="message_format"></a><h3>message_format</h3>
<p>Specify protocol format. Supported values are <code>rfc3164</code>, <code>rfc5424</code> and <code>auto</code>. Default is <code>rfc3164</code>. If your syslog uses <code>rfc5424</code>, use <code>rfc5424</code> instead.</p>
<p><code>auto</code> is useful when this parser receives both <code>rfc3164</code> and <code>rfc5424</code> message. <code>syslog</code> parser detects message format by using message prefix.</p>
<p>This parameter is used inside <code>in_syslog</code> plugin because the file logs via syslog don’t have <code>&lt;9&gt;</code> like priority prefix.</p>
<a name="with_priority"></a><h3>with_priority</h3>
<p>If the incoming logs have priority prefix, e.g. &lt;9&gt;, set <code>true</code>. Default is <code>false</code>.</p>
<a name="keep_time_key"></a><h3>keep_time_key</h3>
<p>If you want to keep time field in the record, set <code>true</code>. Default is <code>false</code>.</p>
<a name="regexp-patterns"></a><h2>Regexp patterns</h2>
<a name="rfc3164-pattern"></a><h3>rfc3164 pattern</h3>
<pre class="CodeRay">format /^\&lt;(?&lt;pri&gt;[0-9]+)\&gt;(?&lt;time&gt;[^ ]* {1,2}[^ ]* [^ ]*) (?&lt;host&gt;[^ ]*) (?&lt;ident&gt;[a-zA-Z0-9_\/\.\-]*)(?:\[(?&lt;pid&gt;[0-9]+)\])?(?:[^\:]*\:)? *(?&lt;message&gt;.*)$/
time_format "%b %d %H:%M:%S"
</pre>
<p><code>pri</code>, <code>host</code>, <code>ident</code>, <code>pid</code> and <code>message</code> are included in the event record. <code>time</code> is used for the event time.</p>
<p><code>pri</code> value is converted into integer type.</p>
<p>If <code>with_priority</code> is <code>false</code>, <code>^\&lt;(?&lt;pri&gt;[0-9]+)\&gt;</code> is removed from the pattern.</p>
<a name="rfc5424-pattern"></a><h3>rfc5424 pattern</h3>
<pre class="CodeRay">format /\A^\&lt;(?&lt;pri&gt;[0-9]{1,3})\&gt;[1-9]\d{0,2} (?&lt;time&gt;[^ ]+) (?&lt;host&gt;[^ ]+) (?&lt;ident&gt;[^ ]+) (?&lt;pid&gt;[-0-9]+) (?&lt;msgid&gt;[^ ]+) (?&lt;extradata&gt;(\[(.*)\]|[^ ])) (?&lt;message&gt;.+)$\z/
time_format "%Y-%m-%dT%H:%M:%S.%L%z"
</pre>
<p><code>pri</code>, <code>host</code>, <code>ident</code>, <code>pid</code>, <code>msgid</code>, <code>extradata</code> and <code>message</code> are included in the event record. <code>time</code> is used for the event time.</p>
<p><code>pri</code> value is converted into integer type.</p>
<a name="example"></a><h2>Example</h2>
<a name="rfc3164-log"></a><h3>rfc3164 log</h3>
<pre class="CodeRay">&lt;6&gt;Feb 28 12:00:00 192.168.0.1 fluentd[11111]: [error] Syslog test
</pre>
<p>This incoming event is parsed as:</p>
<pre class="CodeRay">time:
1362020400 (Feb 28 12:00:00)

record:
{
  "pri"    : 6,
  "host"   : "192.168.0.1",
  "ident"  : "fluentd",
  "pid"    : "11111",
  "message": "[error] Syslog test"
}
</pre>
<a name="rfc5424-log"></a><h3>rfc5424 log</h3>
<pre class="CodeRay">&lt;16&gt;1 2013-02-28T12:00:00.003Z 192.168.0.1 fluentd 11111 ID24224 [exampleSDID@20224 iut="3" eventSource="Application" eventID="11211"] Hi, from Fluentd!
</pre>
<p>This incoming event is parsed as:</p>
<pre class="CodeRay">time:
1362052800 (2013-02-28T12:00:00.003Z)

record:
{
  "pri"      : 16,
  "host"     : "192.168.0.1",
  "ident"    : "fluentd",
  "pid"      : "11111",
  "msgid"    : "ID24224",
  "extradata": "[exampleSDID@20224 iut=\"3\" eventSource=\"Application\" eventID=\"11211\"]",
  "message"  : "Hi, from Fluentd!"
}
</pre>
<div style="text-align:right">
  Last updated: 2018-10-19 00:25:57 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_syslog">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
