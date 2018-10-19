<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/formatter_single_value">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>single_value Formatter Plugin</h1>
</hgroup>
<p>The <code>single_value</code> formatter plugin output the value of a single field instead of the whole record.</p>
<p>This formatter is often used in conjunction with <a href="in_tail">in_tail</a>’s <code>format none</code>.</p>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#add_newline-(boolean,-optional,-defaults-to-true)">add_newline (Boolean, Optional, defaults to true)</a></li>
<li class="sub-toc-item"><a href="#message_key-(string,-optional,-defaults-to-%E2%80%9Cmessage%E2%80%9D)">message_key (String, Optional, defaults to “message”)</a></li>
</ul>
<li class="toc-item"><a href="#example">Example</a></li>
</ul>
</section>
<h2>Parameters</h2>
<a name="add_newline-(boolean,-optional,-defaults-to-true)"></a><h3>add_newline (Boolean, Optional, defaults to true)</h3>
<p>Add <code>\n</code> to the result. If there is a trailing “\n” already, set it “false”</p>
<a name="message_key-(string,-optional,-defaults-to-%E2%80%9Cmessage%E2%80%9D)"></a><h3>message_key (String, Optional, defaults to “message”)</h3>
<p>The value of this field is outputted.</p>
<a name="example"></a><h2>Example</h2>
<pre class="CodeRay">tag:    app.event
time:   1362020400
record: {"message":"Hello from Fluentd!"}
</pre>
<p>This incoming event is formatted to:</p>
<pre class="CodeRay">Hello from Fluentd!\n
</pre>
<div style="text-align:right">
  Last updated: 2018-10-18 23:39:00 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/formatter_single_value">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>