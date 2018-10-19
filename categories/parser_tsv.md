<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_tsv">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>TSV Parser Plugin</h1>
</hgroup>
<p>The <code>tsv</code> parser plugin parses TSV format.</p>
<a name="parameters"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#time_key">time_key</a></li>
<li class="sub-toc-item"><a href="#time_format">time_format</a></li>
<li class="sub-toc-item"><a href="#null_value_pattern">null_value_pattern</a></li>
<li class="sub-toc-item"><a href="#null_empty_string">null_empty_string</a></li>
<li class="sub-toc-item"><a href="#types">types</a></li>
</ul>
<li class="toc-item"><a href="#example">Example</a></li>
</ul>
</section>
<h2>Parameters</h2>
<a name="time_key"></a><h3>time_key</h3>
<p>Specify time field for event time. Default is <code>nil</code>.</p>
<p>If there is no time field in the record, this parser uses current time as an event time.</p>
<a name="time_format"></a><h3>time_format</h3>
<p>If time field value is formatted string, e.g. “28/Feb/2013:12:00:00 +0900”, you need to specify this parameter to parse it.</p>
<p>Default is <code>nil</code> and it uses <code>Time.parse</code> method to parse the field.</p>
<p>See <a href="http://ruby-doc.org/stdlib-2.4.1/libdoc/time/rdoc/Time.html#method-c-strptime">Time#strptime</a> for additional format information.</p>
<a name="null_value_pattern"></a><h3>null_value_pattern</h3>
<p>Specify null value pattern. Default is <code>nil</code>.</p>
<p>If given field value is matched with this pattern, the field value is replaced with <code>nil</code>.</p>
<a name="null_empty_string"></a><h3>null_empty_string</h3>
<p>If <code>true</code>, empty string field is replaced with <code>nil</code>. Default is <code>false</code>.</p>
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
<pre class="CodeRay">format tsv
keys time,host,req_id,user
time_key time
</pre>
<p>With this configuration:</p>
<pre class="CodeRay">2013/02/28 12:00:00\t192.168.0.1\t111\t-
</pre>
<p>This incoming event is parsed as:</p>
<pre class="CodeRay">time:
1362020400 (2013/02/28/ 12:00:00)

record:
{
  "host"   : "192.168.0.1",
  "req_id" : "111",
  "user"   : "-"
}
</pre>
<p>If you set <code>null_value_pattern '-'</code> in the configuration, <code>user</code> field becomes <code>nil</code> instead of <code>"-"</code>.</p>
<div style="text-align:right">
  Last updated: 2018-10-18 23:38:25 +0000
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/parser_tsv">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>