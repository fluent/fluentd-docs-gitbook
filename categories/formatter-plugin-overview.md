<hgroup>
<h1>Text Formatter Overview</h1>
</hgroup>
<p>Fluentd has 6 types of plugins: <a href="input-plugin-overview">Input</a>, <a href="parser-plugin-overview">Parser</a>, <a href="filter-plugin-overview">Filter</a>, <a href="output-plugin-overview">Output</a>, <a href="formatter-plugin-overview">Formatter</a> and <a href="buffer-plugin-overview">Buffer</a>. This article gives an overview of Formatter Plugin.</p>
<a name="overview"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#overview">Overview</a></li>
<li class="toc-item"><a href="#how-to-use">How To Use</a></li>
<li class="toc-item"><a href="#list-of-built-in-formatters">List of Built-in Formatters</a></li>
<li class="toc-item"><a href="#list-of-output-plugins-with-text-formatter-support">List of Output Plugins with Text Formatter Support</a></li>
</ul>
</section>
<h2>Overview</h2>
<p>Sometimes, the output format for an output plugin does not meet one’s needs. Fluentd has a pluggable system called Text Formatter that lets the user extend and re-use custom output formats.</p>
<a name="how-to-use"></a><h2>How To Use</h2>
<p>For an output plugin that supports Text Formatter, the <code>format</code> parameter can be used to change the output format.</p>
<p>For example, by default, <a href="out_file">out_file</a> plugin outputs data as</p>
<pre class="CodeRay">2014-08-25 00:00:00 +0000&lt;TAB&gt;foo.bar&lt;TAB&gt;{"k1":"v1", "k2":"v2"}
</pre>
<p>However, if you set <code>format json</code> like this</p>
<pre class="CodeRay">&lt;match foo.bar&gt;
  @type file
  path /path/to/file
  format json
&lt;/match&gt;
</pre>
<p>The output changes to</p>
<pre class="CodeRay">{"time": "2014-08-25 00:00:00 +0000", "tag":"foo.bar", "k1:"v1", "k2":"v2"}
</pre>
<p>i.e., each line is a single JSON object with “time” and “tag fields to retain the event’s timestamp and tag.</p>
<p>See <a href="plugin-development#text-formatter-plugins">this section</a> to learn how to develop a custom formatter.</p>
<a name="list-of-built-in-formatters"></a><h2>List of Built-in Formatters</h2>
<ul>
<li><a href="formatter_out_file">out_file</a></li>
<li><a href="formatter_json">json</a></li>
<li><a href="formatter_ltsv">ltsv</a></li>
<li><a href="formatter_csv">csv</a></li>
<li><a href="formatter_msgpack">msgpack</a></li>
<li><a href="formatter_hash">hash</a></li>
<li><a href="formatter_single_value">single_value</a></li>
</ul>
<a name="list-of-output-plugins-with-text-formatter-support"></a><h2>List of Output Plugins with Text Formatter Support</h2>
<ul>
<li><a href="out_file">out_file</a></li>
<li><a href="out_s3">out_s3</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/formatter-plugin-overview">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
