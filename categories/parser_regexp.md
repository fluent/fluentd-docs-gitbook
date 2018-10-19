<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_regexp">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>regexp Parser Plugin</h1>
</hgroup>
<p>The <code>regexp</code> parser plugin parses logs by given regexp pattern. If the parameter value starts and ends with “/”, it is considered to be a regexp. The regexp must have at least one named capture (?&lt;NAME&gt;PATTERN). If the regexp has a capture named <code>time</code>, this is configurable, it is used as the time of the event. You can specify the time format using the time_format parameter.</p>
<pre class="CodeRay">format /.../ # regexp parser is used
format json  # json parser is used
</pre>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#time_key">time_key</a></li>
<li class="sub-toc-item"><a href="#time_format">time_format</a></li>
<li class="sub-toc-item"><a href="#keep_time_key">keep_time_key</a></li>
<li class="sub-toc-item"><a href="#types">types</a></li>
</ul>
<li class="toc-item"><a href="#example">Example</a></li>
<li class="toc-item"><a href="#faq">FAQ</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#how-to-debug-my-regexp-pattern?">How to debug my regexp pattern?</a></li>
</ul>
</ul>
</section>
<h2>Parameters</h2>
<a name="time_key"></a><h3>time_key</h3>
<p>Specify the field for event time. Default is <code>time</code>.</p>
<a name="time_format"></a><h3>time_format</h3>
<p>Specify time format for <code>time_key</code>.</p>
<p>See <a href="http://ruby-doc.org/stdlib-2.4.1/libdoc/time/rdoc/Time.html#method-c-strptime">Time#strptime</a> for additional format information.</p>
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
<a name="example"></a><h2>Example</h2>
<pre class="CodeRay">format /^\[(?&lt;logtime&gt;[^\]]*)\] (?&lt;name&gt;[^ ]*) (?&lt;title&gt;[^ ]*) (?&lt;id&gt;\d*)$/
time_key logtime
time_format %Y-%m-%d %H:%M:%S %z
types id:integer
</pre>
<p>With this config:</p>
<pre class="CodeRay">[2013-02-28 12:00:00 +0900] alice engineer 1
</pre>
<p>This incoming log is parsed as:</p>
<pre class="CodeRay">time:
1362020400 (22013-02-28 12:00:00 +0900)

record:
{
  "name" : "alice",
  "title": "engineer",
  "id"   : 1
}
</pre>
<a name="faq"></a><h2>FAQ</h2>
<a name="how-to-debug-my-regexp-pattern?"></a><h3>How to debug my regexp pattern?</h3>
<p><a href="/articles/fluentd-ui#intail-setting">fluentd-ui’s in_tail editor</a> helps your regexp testing. Another way, <a href="http://fluentular.herokuapp.com/">Fluentular</a> is a great website to test your regexp for Fluentd configuration.</p>
<p>NOTE: You may hit Application Error at Fluentular due to <a href="https://www.heroku.com/pricing">heroku free plan limitation</a>. Retry a few hours later or use fluentd-ui instead.</p>
<div style="text-align:right">
  Last updated: 2018-10-19 00:25:44 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_regexp">v1.0 (td-agent3)</a>
    
  

  

  
    
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