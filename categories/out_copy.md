<hgroup>
<h1>copy Output Plugin</h1>
</hgroup>
<p>The <code>copy</code> output plugin copies events to multiple outputs.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#deep_copy">deep_copy</a></li>
<li class="sub-toc-item"><a href="#&lt;store&gt;-(at-least-one-required)">&lt;store&gt; (at least one required)</a></li>
</ul>
<li class="toc-item"><a href="#faq">FAQ</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#how-to-ignore-each-error-in-%5C&lt;store&gt;?">How to ignore each error in \&lt;store&gt;?</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>out_copy</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;match pattern&gt;
  @type copy
  &lt;store&gt;
    @type file
    path /var/log/fluent/myapp1
    ...
  &lt;/store&gt;
  &lt;store&gt;
    ...
  &lt;/store&gt;
  &lt;store&gt;
    ...
  &lt;/store&gt;
&lt;/match&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<p>Here is an example set up to send events to both a local file under <code>/var/log/fluent/myapp</code> and the collection <code>fluentd.test</code> in a local MongoDB instance (Please see the <a href="/articles/out_file">out_file</a> and <a href="/articles/out_mongo">out_mongo</a> articles for more details about the respective plugins.)</p>
<pre class="CodeRay">&lt;match myevent.file_and_mongo&gt;
  @type copy
  &lt;store&gt;
    @type file
    path /var/log/fluent/myapp
    time_slice_format %Y%m%d
    time_slice_wait 10m
    time_format %Y%m%dT%H%M%S%z
    compress gzip
    utc
  &lt;/store&gt;
  &lt;store&gt;
    @type mongo
    host fluentd
    port 27017
    database fluentd
    collection test
  &lt;/store&gt;
&lt;/match&gt;
</pre>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>copy</code>.</p>
<a name="deep_copy"></a><h3>deep_copy</h3>
<p><code>out_copy</code> shares a record between <code>store</code> plugins by default.</p>
<p>When <code>deep_copy</code> is true, <code>out_copy</code> passes different record to each <code>store</code> plugin.</p>
<a name="&lt;store&gt;-(at-least-one-required)"></a><h3>&lt;store&gt; (at least one required)</h3>
<p>Specifies the storage destinations. The format is the same as the &lt;match&gt; directive.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<a name="faq"></a><h2>FAQ</h2>
<a name="how-to-ignore-each-error-in-%5C&lt;store&gt;?"></a><h3>How to ignore each error in \&lt;store&gt;?</h3>
<p>If one <code>store</code> raises an error, it affects other <code>&lt;store&gt;</code>. If you want to ignore an exception from less important <code>&lt;store&gt;</code>,
you can use 3rd party <a href="https://github.com/sonots/fluent-plugin-copy_ex">out_copy_ex</a> instead.</p>
<div style="text-align:right">
  Last updated: 2016-12-19 06:57:20 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_copy">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
