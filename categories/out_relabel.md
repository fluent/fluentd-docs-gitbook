<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_relabel">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>relabel Output Plugin</h1>
</hgroup>
<p>The <code>relabel</code> output plugin re-labels events.</p>
<a name="example-configuration"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#@label">@label</a></li>
</ul>
</ul>
</section>
<h2>Example Configuration</h2>
<p><code>out_relabel</code> is included in Fluentd’s core. No additional installation process is required.</p>
<pre class="CodeRay">&lt;match pattern&gt;
  @type relabel
  @label @foo
&lt;/match&gt;

&lt;label @foo&gt;
  &lt;match patter&gt;
    ...
  &lt;/match&gt;
&lt;/label&gt;
</pre>
<p>The above example puts a label <code>@foo</code> to matched events, and the <code>label</code>
directive can take care of these events.</p>
<p>FYI: All of input and output plugins also have <code>@label</code> parameter provided by
Fluentd core. The <code>relabel</code> plugin is a plugin which actually does nothing,
but supports only <code>@label</code> parameter.</p>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>relabel</code>.</p>
<a name="@label"></a><h3>@label</h3>
<p>The label.</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/out_relabel">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>