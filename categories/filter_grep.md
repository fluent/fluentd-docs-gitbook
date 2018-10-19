<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/filter_grep">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>grep Filter Plugin</h1>
</hgroup>
<p>The <code>filter_grep</code> filter plugin “greps” events by the values of specified fields.</p>
<a name="example-configurations"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configurations">Example Configurations</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#&lt;regexp&gt;-directive-(optional)">&lt;regexp&gt; directive (optional)</a></li>
<li class="sub-toc-item"><a href="#regexpn-(optional)">regexpN (optional)</a></li>
<li class="sub-toc-item"><a href="#&lt;exclude&gt;-directive-(optional)">&lt;exclude&gt; directive (optional)</a></li>
<li class="sub-toc-item"><a href="#excluden-(optional)">excludeN (optional)</a></li>
</ul>
<li class="toc-item"><a href="#learn-more">Learn More</a></li>
</ul>
</section>
<h2>Example Configurations</h2>
<p><code>filter_grep</code> is included in Fluentd’s core. No installation required.</p>
<pre class="CodeRay">&lt;filter foo.bar&gt;
  @type grep
  &lt;regexp&gt;
    key message
    pattern cool
  &lt;/regexp&gt;
  &lt;regexp&gt;
    key hostname
    pattern ^web\d+\.example\.com$
  &lt;/regexp&gt;
  &lt;exclude&gt;
    key message
    pattern uncool
  &lt;/exclude&gt;
&lt;/filter&gt;
</pre>
<p>The above example matches any event that satisfies the following conditions:</p>
<ol>
<li>The value of the “message” field contains “cool”</li>
<li>The value of the “hostname” field matches <code>web&lt;INTEGER&gt;.example.com</code>.</li>
<li>The value of the “message” field does NOT contain “uncool”.</li>
</ol>
<p>Hence, the following events are kept:</p>
<pre class="CodeRay">{"message":"It's cool outside today", "hostname":"web001.example.com"}
{"message":"That's not cool", "hostname":"web1337.example.com"}
</pre>
<p>whereas the following examples are filtered out:</p>
<pre class="CodeRay">{"message":"I am cool but you are uncool", "hostname":"db001.example.com"}
{"hostname":"web001.example.com"}
{"message":"It's cool outside today"}
</pre>
<a name="parameters"></a><h2>Parameters</h2>
<a name="&lt;regexp&gt;-directive-(optional)"></a><h3>&lt;regexp&gt; directive (optional)</h3>
<p>Specify filtering rule. This directive contains two parameters. This parameter is available since v0.12.38.</p>
<ul>
<li>key</li>
</ul>
<p>The field name to which the regular expression is applied.</p>
<ul>
<li>pattern</li>
</ul>
<p>The regular expression.</p>
<p>For example, the following filters out events unless the field “price” is a positive integer.</p>
<pre class="CodeRay">&lt;regexp&gt;
  key price
  pattern [1-9]\d*
&lt;/regexp&gt;
</pre>
<p>The grep filter filters out UNLESS all <code>&lt;regexp&gt;</code>s are matched. Hence, if you have</p>
<pre class="CodeRay">&lt;regexp&gt;
  key price
  pattern [1-9]\d*
&lt;/regexp&gt;
&lt;regexp&gt;
  key item_name
  pattern ^book_
&lt;/regexp&gt;
</pre>
<p>unless the event’s “item_name” field starts with “book_” and the “price” field is an integer, it is filtered out.</p>
<p>For OR condition, you can use <code>|</code> operator of regular expressions. For example, if you have</p>
<pre class="CodeRay">&lt;regexp&gt;
  key item_name
  pattern (^book_|^article)
&lt;/regexp&gt;
</pre>
<p>unless the event’s “item_name” field starts with “book<em>” or “article</em>”, it is filtered out.</p>
<p>Learn regular expressions for more patterns.</p>
<a name="regexpn-(optional)"></a><h3>regexpN (optional)</h3>
<p>This is deprecated parameter. Use <code>&lt;regexp&gt;</code> instead if you use v0.12.38 or later.</p>
<p>The “N” at the end should be replaced with an integer between 1 and 20 (ex: “regexp1”). regexpN takes two whitespace-delimited arguments.</p>
<p>Here is <code>regexpN</code> version of <code>&lt;regexp&gt;</code> example:</p>
<pre class="CodeRay">regexp1 price [1-9]\d*
regexp2 item_name ^book_
</pre>
<a name="&lt;exclude&gt;-directive-(optional)"></a><h3>&lt;exclude&gt; directive (optional)</h3>
<p>Specify filtering rule to reject events. This directive contains two parameters.  This parameter is available since v0.12.38.</p>
<ul>
<li>key</li>
</ul>
<p>The field name to which the regular expression is applied.</p>
<ul>
<li>pattern</li>
</ul>
<p>The regular expression.</p>
<p>For example, the following filters out events whose “status_code” field is 5xx.</p>
<pre class="CodeRay">&lt;exclude&gt;
  key status_code
  pattern ^5\d\d$
&lt;/exclude&gt;
</pre>
<p>The grep filter filters out if any <code>&lt;exclude&gt;</code> is matched. Hence, if you have</p>
<pre class="CodeRay">&lt;exclude&gt;
  key status_code
  pattern ^5\d\d$
&lt;/exclude&gt;
&lt;exclude&gt;
  key url
  pattern \.css$
&lt;/exclude&gt;
</pre>
<p>Then, any event whose “status_code” is 5xx OR “url” ends with “.css” is filtered out.</p>
<a name="excluden-(optional)"></a><h3>excludeN (optional)</h3>
<p>This is deprecated parameter. Use <code>&lt;exclude&gt;</code> instead if you use v0.12.38 or later.</p>
<p>The “N” at the end should be replaced with an integer between 1 and 20 (ex: “exclude1”). excludeN takes two whitespace-delimited arguments.</p>
<p>Here is <code>excludeN</code> version of <code>&lt;exclude&gt;</code> example:</p>
<pre class="CodeRay">exclude1 status_code ^5\d\d$
exclude2 url \.css$
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">If <code>&lt;regexp&gt;</code> and <code>&lt;exclude&gt;</code> are used together, both are applied.</td>
</table>
<a name="learn-more"></a><h2>Learn More</h2>
<ul>
<li><a href="filter-plugin-overview">Filter Plugin Overview</a></li>
<li><a href="filter_record_transformer">record_transformer Filter Plugin</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-09-21 02:58:49 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/filter_grep">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>