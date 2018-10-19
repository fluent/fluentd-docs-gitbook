<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_apache_error">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>apache_error Parser Plugin</h1>
</hgroup>
<p>The <code>apache_error</code> parser plugin parses apache error logs.</p>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#keep_time_key">keep_time_key</a></li>
<li class="sub-toc-item"><a href="#types">types</a></li>
</ul>
<li class="toc-item"><a href="#regexp-patterns">Regexp patterns</a></li>
<li class="toc-item"><a href="#example">Example</a></li>
</ul>
</section>
<h2>Parameters</h2>
<a name="keep_time_key"></a><h3>keep_time_key</h3>
<p>If you want to keep time field in the record, set <code>true</code>. Default is <code>false</code>.</p>
<a name="types"></a><h3>types</h3>
<p>Although every parsed field has type <code>string</code> by default, you can specify other types. This is useful when filtering particular fields numerically or storing data with sensible type information.</p>
<p>The syntax is</p>
<pre class="CodeRay">types &lt;field_name_1&gt;:&lt;type_name_1&gt;,&lt;field_name_2&gt;:&lt;type_name_2&gt;,...
</pre>
<p>e.g.,</p>
<pre class="CodeRay">types user_id:integer,paid:bool,paid_usd_amount:float
</pre>
<p>As demonstrated above, “,” is used to delimit field-type pairs while “:” is used to separate a field name with its intended type.</p>
<p>Unspecified fields are parsed at the default string type.</p>
<p>The list of supported types are shown below:</p>
<ul>
<li>string</li>
<li>bool</li>
<li>integer (“int” would NOT work!)</li>
<li>float</li>
<li>time</li>
<li>array</li>
</ul>
<p>For the <code>time</code> and <code>array</code> types, there is an optional third field after the type name. For the “time” type, you can specify a time format like you would in <code>time_format</code>.</p>
<p>For the “array” type, the third field specifies the delimiter (the default is “,”). For example, if a field called “item_ids” contains the value “3,4,5”, <code>types item_ids:array</code> parses it as [“3”, “4”, “5”]. Alternatively, if the value is “Adam|Alice|Bob”, <code>types item_ids:array:|</code> parses it as [“Adam”, “Alice”, “Bob”].</p>
<a name="regexp-patterns"></a><h2>Regexp patterns</h2>
<p>This is regexp pattern of this plugin:</p>
<pre class="CodeRay">format /^\[[^ ]* (?&lt;time&gt;[^\]]*)\] \[(?&lt;level&gt;[^\]]*)\](?: \[pid (?&lt;pid&gt;[^\]]*)\])? \[client (?&lt;client&gt;[^\]]*)\] (?&lt;message&gt;.*)$/
</pre>
<p><code>level</code>, <code>pid</code>, <code>client</code> and <code>message</code> are included in the event record. <code>time</code> is used for the event time.</p>
<a name="example"></a><h2>Example</h2>
<pre class="CodeRay">[Wed Oct 11 14:32:52 2000] [error] [client 127.0.0.1] client denied by server configuration
</pre>
<p>This incoming event is parsed as:</p>
<pre class="CodeRay">time:
971242372 (Wed Oct 11 14:32:52 2000)

record:
{
  "level"  : "error",
  "client" : "127.0.0.1",
  "message": "client denied by server configuration"
}
</pre>
<div style="text-align:right">
  Last updated: 2018-10-19 00:25:51 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_apache_error">v1.0 (td-agent3)</a>
    
  

  

  
    
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