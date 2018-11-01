<hgroup>
<h1>dummy Input Plugin</h1>
</hgroup>
<p>The <code>in_dummy</code> input plugin generates dummy events. It is useful for testing, debugging, benchmarking and getting started with Fluentd.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#tag-(required)">tag (required)</a></li>
<li class="sub-toc-item"><a href="#dummy-(optional)">dummy (optional)</a></li>
<li class="sub-toc-item"><a href="#auto_increment_key-(optional,-string-type)">auto_increment_key (optional, string type)</a></li>
<li class="sub-toc-item"><a href="#rate-(optional,-integer-type)">rate (optional, integer type)</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>in_dummy</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;source&gt;
  @type dummy
  dummy {"hello":"world"}
&lt;/source&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>dummy</code>.</p>
<a name="tag-(required)"></a><h3>tag (required)</h3>
<p>The value is the tag assigned to the generated events.</p>
<a name="dummy-(optional)"></a><h3>dummy (optional)</h3>
<p>The dummy data to be generated. It should be either an array of JSON hashes or a single JSON hash. If it is an array of JSON hashes, the hashes in the array are cycled through in order. By default, the value is <code>[{"message":"dummy"}]</code> (i.e., it continues to generate events with the record {“message”:“dummy”}).</p>
<a name="auto_increment_key-(optional,-string-type)"></a><h3>auto_increment_key (optional, string type)</h3>
<p>If specified, each generated event has an auto-incremented key field. For example, with <code>auto_increment_key foo_key</code>, the first couple of events look like</p>
<pre class="CodeRay"><span class="string">2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":0}
</span><span class="string">2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":1}
</span><span class="string">2014-12-14 23:23:38 +0000 test: {"message":"dummy","foo_key":2}
</span></pre>
<a name="rate-(optional,-integer-type)"></a><h3>rate (optional, integer type)</h3>
<p>It configures how many events to generate per second. The default value is 1.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/in_dummy">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
