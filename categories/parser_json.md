<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_json">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>json Parser Plugin</h1>
</hgroup>
<p>The <code>json</code> parser plugin parses JSON logs. One JSON map per line.</p>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#time_key">time_key</a></li>
<li class="sub-toc-item"><a href="#time_format">time_format</a></li>
<li class="sub-toc-item"><a href="#keep_time_key">keep_time_key</a></li>
</ul>
<li class="toc-item"><a href="#example">Example</a></li>
</ul>
</section>
<h2>Parameters</h2>
<a name="time_key"></a><h3>time_key</h3>
<p>Specify time field for event time. Default is <code>time</code>.</p>
<p>If there is no time field in the record, this parser uses current time as an event time.</p>
<a name="time_format"></a><h3>time_format</h3>
<p>If time field value is formatted string, e.g. “28/Feb/2013:12:00:00 +0900”, you need to specify this parameter to parse it.</p>
<p>Default is <code>nil</code> and it means time field value is a second integer like <code>1497915137</code>.</p>
<p>See <a href="http://ruby-doc.org/stdlib-2.4.1/libdoc/time/rdoc/Time.html#method-c-strptime">Time#strptime</a> for additional format information.</p>
<a name="keep_time_key"></a><h3>keep_time_key</h3>
<p>If you want to keep time field in the record, set <code>true</code>. Default is <code>false</code>.</p>
<a name="example"></a><h2>Example</h2>
<pre class="CodeRay">{"time":1362020400,"host":"192.168.0.1","size":777,"method":"PUT"}
</pre>
<p>This incoming event is parsed as:</p>
<pre class="CodeRay">time:
1362020400 (2013-02-28 12:00:00 +0900)

record:
{
  "host"  : "192.168.0.1",
  "size"  : 777,
  "method": "PUT",
}
</pre>
<div style="text-align:right">
  Last updated: 2018-10-18 22:55:28 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_json">v1.0 (td-agent3)</a>
    
  

  

  
    
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