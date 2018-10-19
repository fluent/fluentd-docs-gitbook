<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/formatter_msgpack">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>msgpack Formatter Plugin</h1>
</hgroup>
<p>The <code>msgpack</code> formatter plugin converts an event to msgpack binary.</p>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#include_time_key-(boolean,-optional,-defaults-to-false)">include_time_key (Boolean, Optional, defaults to false)</a></li>
<li class="sub-toc-item"><a href="#time_key-(string,-optional,-defaults-to-%E2%80%9Ctime%E2%80%9D)">time_key (String, Optional, defaults to “time”)</a></li>
<li class="sub-toc-item"><a href="#time_format-(string.-optional)">time_format (String. Optional)</a></li>
<li class="sub-toc-item"><a href="#include_tag_key-(boolean.-optional,-defaults-to-false)">include_tag_key (Boolean. Optional, defaults to false)</a></li>
<li class="sub-toc-item"><a href="#tag_key-(string,-optional,-defaults-to-%E2%80%9Ctag%E2%80%9D)">tag_key (String, Optional, defaults to “tag”)</a></li>
<li class="sub-toc-item"><a href="#localtime-(boolean.-optional,-defaults-to-true)">localtime (Boolean. Optional, defaults to true)</a></li>
<li class="sub-toc-item"><a href="#timezone-(string.-optional)">timezone (String. Optional)</a></li>
<li class="sub-toc-item"><a href="#time_as_epoch-(boolean,-optional,-defaults-to-false)">time_as_epoch (Boolean, Optional, defaults to false)</a></li>
</ul>
<li class="toc-item"><a href="#example">Example</a></li>
</ul>
</section>
<h2>Parameters</h2>
<a name="include_time_key-(boolean,-optional,-defaults-to-false)"></a><h3>include_time_key (Boolean, Optional, defaults to false)</h3>
<p>If true, the time field (as specified by the <code>time_key</code> parameter) is kept in the record.</p>
<a name="time_key-(string,-optional,-defaults-to-%E2%80%9Ctime%E2%80%9D)"></a><h3>time_key (String, Optional, defaults to “time”)</h3>
<p>The field name for the time key.</p>
<a name="time_format-(string.-optional)"></a><h3>time_format (String. Optional)</h3>
<p>By default, the output format is iso8601 (e.g. “2008-02-01T21:41:49”). One can specify their own format with this parameter.</p>
<a name="include_tag_key-(boolean.-optional,-defaults-to-false)"></a><h3>include_tag_key (Boolean. Optional, defaults to false)</h3>
<p>If true, the tag field (as specified by the <code>tag_key</code> parameter) is kept in the record.</p>
<a name="tag_key-(string,-optional,-defaults-to-%E2%80%9Ctag%E2%80%9D)"></a><h3>tag_key (String, Optional, defaults to “tag”)</h3>
<p>The field name for the tag key.</p>
<a name="localtime-(boolean.-optional,-defaults-to-true)"></a><h3>localtime (Boolean. Optional, defaults to true)</h3>
<p>  If true, use local time. Otherwise, UTC is used. This parameter is overwritten by the <code>utc</code> parameter.</p>
<a name="timezone-(string.-optional)"></a><h3>timezone (String. Optional)</h3>
<p>By setting this parameter, one can parse the time value in the specified timezone. The following formats are accepted:</p>
<ol>
<li>[+-]HH:MM (e.g. “+09:00”)</li>
<li>[+-]HHMM (e.g. “+0900”)</li>
<li>[+-]HH (e.g. “+09”)</li>
<li>Region/Zone (e.g. “Asia/Tokyo”)</li>
<li>Region/Zone/Zone (e.g. “America/Argentina/Buenos_Aires”)</li>
</ol>
<p>The timezone set in this parameter takes precedence over <code>localtime</code>**, e.g., if <code>localtime</code> is set to <code>true</code> but <code>timezone</code> is set to <code>+0000</code>, UTC would be used.</p>
<a name="time_as_epoch-(boolean,-optional,-defaults-to-false)"></a><h3>time_as_epoch (Boolean, Optional, defaults to false)</h3>
<p>Set integer event time instead of stringanized time to <code>time_key</code>.</p>
<a name="example"></a><h2>Example</h2>
<pre class="CodeRay">tag:    app.event
time:   1362020400
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
</pre>
<p>This incoming event is formatted to:</p>
<pre class="CodeRay">{"host":"192.168.0.1","size":777,"method":"PUT"}
</pre>
<p>With <code>include_tag_key true</code> and <code>tag_key event_tag</code>, result is:</p>
<pre class="CodeRay">\x83\xA4host\xAB192.168.0.1\xA4size\xCD\x03\t\xA6method\xA3PUT
</pre>
<div style="text-align:right">
  Last updated: 2018-10-18 23:38:54 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/formatter_msgpack">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>