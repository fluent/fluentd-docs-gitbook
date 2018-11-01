<hgroup>
<h1>parser Filter Plugin</h1>
</hgroup>
<p>The <code>filter_parser</code> filter plugin “parses” string field in event records and mutates its event record with parsed result.</p>
<a name="example-configurations"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configurations">Example Configurations</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#format">format</a></li>
<li class="sub-toc-item"><a href="#key_name">key_name</a></li>
<li class="sub-toc-item"><a href="#reserve_data">reserve_data</a></li>
<li class="sub-toc-item"><a href="#suppress_parse_error_log">suppress_parse_error_log</a></li>
<li class="sub-toc-item"><a href="#ignore_key_not_exist">ignore_key_not_exist</a></li>
<li class="sub-toc-item"><a href="#replace_invalid_sequence">replace_invalid_sequence</a></li>
<li class="sub-toc-item"><a href="#inject_key_prefix">inject_key_prefix</a></li>
<li class="sub-toc-item"><a href="#hash_value_field">hash_value_field</a></li>
<li class="sub-toc-item"><a href="#time_parse">time_parse</a></li>
<li class="sub-toc-item"><a href="#emit_invalid_record_to_error">emit_invalid_record_to_error</a></li>
</ul>
<li class="toc-item"><a href="#learn-more">Learn More</a></li>
</ul>
</section>
<h2>Example Configurations</h2>
<p><code>filter_parser</code> is included in Fluentd’s core since v0.12.29. No installation required. If you want to use <code>filter_parser</code> with lower fluentd versions, need to install <code>fluent-plugin-parser</code>.</p>
<p><code>filter_parser</code> has just same with <code>in_tail</code> about <code>format</code> and <code>time_format</code>:</p>
<pre class="CodeRay">&lt;filter foo.bar&gt;
  @type parser
  format /^(?&lt;host&gt;[^ ]*) [^ ]* (?&lt;user&gt;[^ ]*) \[(?&lt;time&gt;[^\]]*)\] "(?&lt;method&gt;\S+)(?: +(?&lt;path&gt;[^ ]*) +\S*)?" (?&lt;code&gt;[^ ]*) (?&lt;size&gt;[^ ]*)$/
  time_format %d/%b/%Y:%H:%M:%S %z
  key_name message
&lt;/filter&gt;
</pre>
<p><code>filter_parser</code> uses built-in parser plugins and your own customized parser plugin, so you can re-use pre-defined format like <code>apache</code>, <code>json</code> and etc.
See document page for more details: <a href="/articles/parser-plugin-overview">Parser Plugin Overview</a></p>
<a name="parameters"></a><h2>Parameters</h2>
<a name="format"></a><h3>format</h3>
<p>This is required parameter. Specify parser format or regexp pattern.</p>
<a name="key_name"></a><h3>key_name</h3>
<p>This is required parameter. Specify field name in the record to parse.</p>
<a name="reserve_data"></a><h3>reserve_data</h3>
<p>Keep original key-value pair in parsed result. Default is <code>false</code>.</p>
<pre class="CodeRay">&lt;filter foo.bar&gt;
  @type parser
  format json
  key_name log
  reserve_data true
&lt;/filter&gt;
</pre>
<p>With above configuration, result is below:</p>
<pre class="CodeRay"># input data:  {"key":"value","log":"{\"user\":1,\"num\":2}"}
# output data: {"key":"value","log":"{\"user\":1,\"num\":2}","user":1,"num":2}
</pre>
<p>Without <code>reserve_data</code>, result is below</p>
<pre class="CodeRay"># input data:  {"key":"value","log":"{\"user\":1,\"num\":2}"}
# output data: {"user":1,"num":2}
</pre>
<a name="suppress_parse_error_log"></a><h3>suppress_parse_error_log</h3>
<p>If <code>true</code>, a plugin suppresses <code>pattern not match</code> warning log. Default is <code>false</code>.</p>
<p>This parameter is useful for parsing mixed logs and you want to ignore non target lines.</p>
<a name="ignore_key_not_exist"></a><h3>ignore_key_not_exist</h3>
<p>Ignore “key not exist” log. Default is <code>false</code>.</p>
<p>Useful case is same with <code>suppress_parse_error_log</code>.</p>
<a name="replace_invalid_sequence"></a><h3>replace_invalid_sequence</h3>
<p>If <code>true</code>, invalid string is replaced with safe characters and re-parse it. Default is <code>false</code>.</p>
<a name="inject_key_prefix"></a><h3>inject_key_prefix</h3>
<p>Store parsed values with specified key name prefix. Default is <code>nil</code>.</p>
<pre class="CodeRay">&lt;filter foo.bar&gt;
  @type parser
  format json
  key_name log
  reserve_data true
  inject_key_prefix data.
&lt;/filter&gt;
</pre>
<p>With above configuration, result is below:</p>
<pre class="CodeRay"># input data:  {"log": "{\"user\":1,\"num\":2}"}
# output data: {"log":"{\"user\":1,\"num\":2}","data.user":1, "data.num":2}
</pre>
<a name="hash_value_field"></a><h3>hash_value_field</h3>
<p>Store parsed values as a hash value in a field. Default is <code>nil</code>.</p>
<pre class="CodeRay">&lt;filter foo.bar&gt;
  @type parser
  format json
  key_name log
  hash_value_field parsed
&lt;/filter&gt;
</pre>
<p>With above configuration, result is below:</p>
<pre class="CodeRay"># input data:  {"log": "{\"user\":1,\"num\":2}"}
# output data: {"parsed":{"user":1,"num":2}}
</pre>
<a name="time_parse"></a><h3>time_parse</h3>
<p>If false, time parsing is disabled in the parser. Default is true.</p>
<a name="emit_invalid_record_to_error"></a><h3>emit_invalid_record_to_error</h3>
<p>Emit invalid record to <code>@ERROR</code> label. Default is <code>false</code>. Invalid cases are</p>
<ul>
<li>key not exist</li>
<li>format is not matched</li>
<li>unexpected error</li>
</ul>
<p>You can rescue unexpected format logs in <code>@ERROR</code> label.</p>
<a name="learn-more"></a><h2>Learn More</h2>
<ul>
<li><a href="filter-plugin-overview">Filter Plugin Overview</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2017-03-16 10:36:00 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/filter_parser">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
