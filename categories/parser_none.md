<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_none">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>none Parser Plugin</h1>
</hgroup>
<p>The <code>none</code> parser plugin parses the line as-is with single field. This format is to defer parsing/structuring the data.</p>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#message_key">message_key</a></li>
</ul>
<li class="toc-item"><a href="#example">Example</a></li>
</ul>
</section>
<h2>Parameters</h2>
<a name="message_key"></a><h3>message_key</h3>
<p>Specify field name to contain logs. Default is <code>message</code>.</p>
<a name="example"></a><h2>Example</h2>
<pre class="CodeRay">Hello world. I am a line of log!
</pre>
<p>This incoming event is parsed as:</p>
<pre class="CodeRay">time:
1362020400 (current time)

record:
{"message":"Hello world. I am a line of log!"}
</pre>
<div style="text-align:right">
  Last updated: 2018-10-19 00:26:16 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_none">v1.0 (td-agent3)</a>
    
  

  

  
    
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