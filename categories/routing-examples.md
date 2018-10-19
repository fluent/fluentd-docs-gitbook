<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/routing-examples">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Routing Examples</h1>
</hgroup>
<p>This article shows typical routing examples.</p>
<a name="simple-input--&gt;-filter--&gt;-output"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#simple-input--&gt;-filter--&gt;-output">Simple Input -&gt; Filter -&gt; Output</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#two-input-cases">Two input cases</a></li>
</ul>
<li class="toc-item"><a href="#input--&gt;-filter--&gt;-output-with-label">Input -&gt; Filter -&gt; Output with Label</a></li>
<li class="toc-item"><a href="#re-route-event-by-tag">Re-route event by tag</a></li>
<li class="toc-item"><a href="#re-route-event-by-record-content">Re-route event by record content</a></li>
<li class="toc-item"><a href="#re-route-event-to-other-label">Re-route event to other Label</a></li>
</ul>
</section>
<h2>Simple Input -&gt; Filter -&gt; Output</h2>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;

&lt;filter app.**&gt;
  @type record_transformer
  &lt;record&gt;
    hostname "#{Socket.gethostname}"
  &lt;/record&gt;
&lt;/filter&gt;

&lt;match app.**&gt;
  @type file
  # ...
&lt;/match&gt;
</pre>
<a name="two-input-cases"></a><h3>Two input cases</h3>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;

&lt;source&gt;
  @type tail
  tag system.logs
  # ...
&lt;/source&gt;

&lt;filter app.**&gt;
  @type record_transformer
  &lt;record&gt;
    hostname "#{Socket.gethostname}"
  &lt;/record&gt;
&lt;/filter&gt;

&lt;match {app.**,system.logs}&gt;
  @type file
  # ...
&lt;/match&gt;
</pre>
<p>If you want to separate data pipeline for each sources, use Label.</p>
<a name="input--&gt;-filter--&gt;-output-with-label"></a><h2>Input -&gt; Filter -&gt; Output with Label</h2>
<p>Label reduces complex tag handling by separating data pipeline.</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;

&lt;source&gt;
  @type dstat
  @label @METRICS # dstat events are routed to &lt;label @METRICS&gt;
  # ...
&lt;/source&gt;

&lt;filter app.**&gt;
  @type record_transformer
  &lt;record&gt;
    # ...
  &lt;/record&gt;
&lt;/filter&gt;

&lt;match app.**&gt;
  @type file
  # ...
&lt;/match&gt;

&lt;label @METRICS&gt;
  &lt;match **&gt;
    @type elasticsearch
    # ...
  &lt;/match&gt;
&lt;/label&gt;
</pre>
<a name="re-route-event-by-tag"></a><h2>Re-route event by tag</h2>
<p>Use <a href="https://github.com/tagomoris/fluent-plugin-route">fluent-plugin-route</a> plugin. <code>route</code> plugin rewrites tag and re-emit events to other match or Label.</p>
<pre class="CodeRay">&lt;match worker.**&gt;
  @type route
  remove_tag_prefix worker
  add_tag_prefix metrics.event

  &lt;route **&gt;
    copy # For fall-through. Without copy, routing is stopped here. 
  &lt;/route&gt;
  &lt;route **&gt;
    copy
    @label @BACKUP
  &lt;/route&gt;
&lt;/match&gt;

&lt;match metrics.event.**&gt;
  @type stdout
&lt;/match&gt;

&lt;label @BACKUP&gt;
  &lt;match metrics.event.**&gt;
    @type file
    path /var/log/fluent/bakcup
  &lt;/match&gt;
&lt;/label&gt;
</pre>
<a name="re-route-event-by-record-content"></a><h2>Re-route event by record content</h2>
<p>Use <a href="https://github.com/fluent/fluent-plugin-rewrite-tag-filter">fluent-plugin-rewrite-tag-filter</a>.</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;

# event example: app.logs {"message":"[info]: ..."}
&lt;match app.**&gt;
  @type rewrite_tag_filter
  rewriterule1 message ^\[(\w+)\] $1.${tag}
&lt;/match&gt;

# send mail when receives alert level logs
&lt;match alert.app.**&gt;
  @type mail
  # ...
&lt;/match&gt;

# other logs are stored into file
&lt;match *.app.**&gt;
  @type file
  # ...
&lt;/match&gt;
</pre>
<p>See also <a href="out_rewrite_tag_filter">out_rewrite_tag_filter</a> article.</p>
<a name="re-route-event-to-other-label"></a><h2>Re-route event to other Label</h2>
<p>Use <a href="out_relabel">out_relabel</a> plugin. <code>relabel</code> plugin simply emits events to Label. No tag rewrite.</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;

&lt;match app.**&gt;
  @type copy
  &lt;store&gt;
    @type forward
    # ...
  &lt;/store&gt;
  &lt;store&gt;
    @type relabel
    @label @NOTIFICATION
  &lt;/store&gt;
&lt;/match&gt;

&lt;label @NOTIFICATION&gt;
  &lt;filter app.**&gt;
    @type grep
    regexp1 message ERROR
  &lt;/filter&gt;

  &lt;match app.**&gt;
    @type mail
  &lt;/match&gt;
&lt;/label&gt;
</pre>
<div style="text-align:right">
  Last updated: 2016-12-08 02:03:30 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/routing-examples">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>