<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/rpc">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Fluentd’s HTTP RPC</h1>
</hgroup>
<p>This article explains how <code>Fluentd</code> handles HTTP RPC.</p>
<a name="overview"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#overview">Overview</a></li>
<li class="toc-item"><a href="#configuration">Configuration</a></li>
<li class="toc-item"><a href="#rpcs">RPCs</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#/api/processes.interruptworkers">/api/processes.interruptWorkers</a></li>
<li class="sub-toc-item"><a href="#/api/processes.killworkers">/api/processes.killWorkers</a></li>
<li class="sub-toc-item"><a href="#/api/plugins.flushbuffers">/api/plugins.flushBuffers</a></li>
<li class="sub-toc-item"><a href="#/api/config.reload">/api/config.reload</a></li>
</ul>
</ul>
</section>
<h2>Overview</h2>
<p>HTTP RPC is one way of managing fluentd instance. Several provided RPCs are replacement of <a href="signals">signals</a>. The response body is JSON format.</p>
<p>On signal unsupported environment, e.g. Windows, you can use RPC instead of signals.</p>
<a name="configuration"></a><h2>Configuration</h2>
<p>RPC is off by default. If you want to enable RPC, set <code>rpc_endpoint</code> in <code>&lt;system&gt;</code> section.</p>
<pre class="CodeRay">&lt;system&gt;
  rpc_endpoint 127.0.0.1:24444
&lt;/system&gt;
</pre>
<p>After that, you can access to RPC like below.</p>
<pre class="CodeRay">$ curl http://127.0.0.1:24444/api/plugins.flushBuffers
{"ok":true}
</pre>
<a name="rpcs"></a><h2>RPCs</h2>
<a name="/api/processes.interruptworkers"></a><h3>/api/processes.interruptWorkers</h3>
<p>Replacement of signal’s <a href="signals#sigint-or-sigterm">SIGINT</a>. Stop the daemon.</p>
<a name="/api/processes.killworkers"></a><h3>/api/processes.killWorkers</h3>
<p>Replacement of signal’s <a href="signals#sigint-or-sigterm">SIGTERM</a>. Stop the daemon.</p>
<a name="/api/plugins.flushbuffers"></a><h3>/api/plugins.flushBuffers</h3>
<p>Replacement of signal’s <a href="signals#sigusr1">SIGUSR1</a>. Flushes buffered messages.</p>
<a name="/api/config.reload"></a><h3>/api/config.reload</h3>
<p>Replacement of signal’s <a href="signals#sighup">SIGHUP</a>. reload configuration.</p>
<div style="text-align:right">
  Last updated: 2016-03-01 13:42:40 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/rpc">v1.0 (td-agent3)</a>
    
  

  

  
    
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