<hgroup>
<h1>Filter Plugin Overview</h1>
</hgroup>
<p>Fluentd has 6 types of plugins: <a href="input-plugin-overview">Input</a>, <a href="parser-plugin-overview">Parser</a>, <a href="filter-plugin-overview">Filter</a>, <a href="output-plugin-overview">Output</a>, <a href="formatter-plugin-overview">Formatter</a> and <a href="buffer-plugin-overview">Buffer</a>. This article gives an overview of Filter Plugin.</p>
<a name="overview"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#overview">Overview</a></li>
<li class="toc-item"><a href="#how-to-use">How to Use</a></li>
<li class="toc-item"><a href="#list-of-filter-plugins">List of Filter Plugins</a></li>
</ul>
</section>
<h2>Overview</h2>
<p>Filter plugins enables Fluentd to modify event streams. Example use cases are:</p>
<ol>
<li>Filtering out events by grepping the value of one or more fields.</li>
<li>Enriching events by adding new fields.</li>
<li>Deleting or masking certain fields for privacy and compliance.</li>
</ol>
<a name="how-to-use"></a><h2>How to Use</h2>
<p>It is used with the <code>&lt;filter&gt;</code> directive as follows:</p>
<pre class="CodeRay"><span class="string">&lt;filter foo.bar&gt;
</span><span class="string">  @type grep
</span><span class="string">  regexp1 message cool
</span><span class="string">&lt;/filter&gt;
</span></pre>
<p>The above directive matches events with the tag “foo.bar”, and if the “message” field’s value contains “cool”, the events go through the rest of the configuration.</p>
<p>Like the <code>&lt;match&gt;</code> directive for output plugins, <code>&lt;filter&gt;</code> matches against a tag. Once the event is processed by the filter, the event proceeds through the configuration top-down. Hence, if there are multiple filters for the same tag, they are applied in descending order. Hence, in the following example,</p>
<pre class="CodeRay"><span class="string">&lt;filter foo.bar&gt;
</span><span class="string">  @type grep
</span><span class="string">  regexp1 message cool
</span><span class="string">&lt;/filter&gt;
</span><span class="string">
</span><span class="string">&lt;filter foo.bar&gt;
</span><span class="string">  @type record_transformer
</span><span class="string">  &lt;record&gt;
</span><span class="string">    hostname "#{Socket.gethostname}"
</span><span class="string">  &lt;/record&gt;
</span><span class="string">&lt;/filter&gt;
</span></pre>
<p>Only the events whose “message” field contain “cool” get the new field “hostname” with the machine’s hostname as its value.</p>
<p>Users can create their own custom plugins with a bit of Ruby. See <a href="plugin-development#filter-plugins">this section</a> for more information.</p>
<a name="list-of-filter-plugins"></a><h2>List of Filter Plugins</h2>
<ul>
<li><a href="filter_grep">grep</a></li>
<li><a href="filter_record_transformer">record-transformer</a></li>
<li><a href="filter_stdout">filter_stdout</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-04-10 18:48:58 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/filter-plugin-overview">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
