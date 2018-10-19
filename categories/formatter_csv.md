<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/formatter_csv">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>csv Formatter Plugin</h1>
</hgroup>
<p>The <code>csv</code> formatter plugin output an event as CSV.</p>
<pre class="CodeRay">"value1"[delimiter]"value2"[delimiter]"value3"\n
</pre>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#fields-(array-of-string,-required.-defaults-to-%E2%80%9C%5Ct%E2%80%9D(tab))">fields (Array of String, Required. defaults to “\t”(TAB))</a></li>
<li class="sub-toc-item"><a href="#delimiter-(string,-optional.-defaults-to-%E2%80%9C,%E2%80%9D)">delimiter (String, Optional. defaults to “,”)</a></li>
<li class="sub-toc-item"><a href="#force_quotes-(boolean,-optional,-defaults-to-true)">force_quotes (Boolean, Optional, defaults to true)</a></li>
<li class="sub-toc-item"><a href="#add_newline-(boolean,-optional,-defaults-to-true)">add_newline (Boolean, Optional, defaults to true)</a></li>
<li class="sub-toc-item"><a href="#include_time_key-(boolean,-optional,-defaults-to-false)">include_time_key (Boolean, Optional, defaults to false)</a></li>
<li class="sub-toc-item"><a href="#time_key-(string,-optional,-defaults-to-%E2%80%9Ctime%E2%80%9D)">time_key (String, Optional, defaults to “time”)</a></li>
<li class="sub-toc-item"><a href="#time_format-(string.-optional)">time_format (String. Optional)</a></li>
<li class="sub-toc-item"><a href="#include_tag_key-(boolean.-optional,-defaults-to-false)">include_tag_key (Boolean. Optional, defaults to false)</a></li>
<li class="sub-toc-item"><a href="#tag_key-(string,-optional,-defaults-to-%E2%80%9Ctag%E2%80%9D)">tag_key (String, Optional, defaults to “tag”)</a></li>
<li class="sub-toc-item"><a href="#localtime-(boolean.-optional,-defaults-to-true)">localtime (Boolean. Optional, defaults to true)</a></li>
<li class="sub-toc-item"><a href="#timezone-(string.-optional)">timezone (String. Optional)</a></li>
</ul>
<li class="toc-item"><a href="#example">Example</a></li>
</ul>
</section>
<h2>Parameters</h2>
<a name="fields-(array-of-string,-required.-defaults-to-%E2%80%9C%5Ct%E2%80%9D(tab))"></a><h3>fields (Array of String, Required. defaults to “\t”(TAB))</h3>
<p>Specify output fields</p>
<a name="delimiter-(string,-optional.-defaults-to-%E2%80%9C,%E2%80%9D)"></a><h3>delimiter (String, Optional. defaults to “,”)</h3>
<p>Delimiter for values.</p>
<a name="force_quotes-(boolean,-optional,-defaults-to-true)"></a><h3>force_quotes (Boolean, Optional, defaults to true)</h3>
<p>If false, value won’t be framed by quotes.</p>
<a name="add_newline-(boolean,-optional,-defaults-to-true)"></a><h3>add_newline (Boolean, Optional, defaults to true)</h3>
<p>Add <code>\n</code> to the result.</p>
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
<a name="example"></a><h2>Example</h2>
<pre class="CodeRay">format csv
fields host,method
</pre>
<p>With this configuration:</p>
<pre class="CodeRay">tag:    app.event
time:   1362020400
record: {"host":"192.168.0.1","size":777,"method":"PUT"}
</pre>
<p>This incoming event is formatted to:</p>
<pre class="CodeRay">"192.168.0.1","PUT"\n
</pre>
<p>With <code>force_quotes false</code>, the result is:</p>
<pre class="CodeRay">192.168.0.1,PUT\n
</pre>
<div style="text-align:right">
  Last updated: 2018-10-18 23:38:50 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/formatter_csv">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>