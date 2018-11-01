<hgroup>
<h1>Fluentd’s Signal Handling</h1>
</hgroup>
<p>This article explains how <code>Fluentd</code> handles UNIX signals.</p>
<a name="process-model"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#process-model">Process Model</a></li>
<li class="toc-item"><a href="#signals">Signals</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#sigint-or-sigterm">SIGINT or SIGTERM</a></li>
<li class="sub-toc-item"><a href="#sigusr1">SIGUSR1</a></li>
<li class="sub-toc-item"><a href="#sighup">SIGHUP</a></li>
<li class="sub-toc-item"><a href="#sigcont">SIGCONT</a></li>
</ul>
</ul>
</section>
<h2>Process Model</h2>
<p>When you launch Fluentd, it creates two processes: supervisor and worker. The supervisor process controls the life cycle of the worker process. Please make sure to send any signals to the supervisor process.</p>
<a name="signals"></a><h2>Signals</h2>
<a name="sigint-or-sigterm"></a><h3>SIGINT or SIGTERM</h3>
<p>Stops the daemon gracefully. Fluentd will try to flush the entire memory buffer at once, but will not retry if the flush fails. Fluentd will not flush the file buffer; the logs are persisted on the disk by default.</p>
<a name="sigusr1"></a><h3>SIGUSR1</h3>
<p>Forces the buffered messages to be flushed and reopens Fluentd’s log. Fluentd will try to flush the current buffer (both memory and file) immediately, and keep flushing at <code>flush_interval</code>.</p>
<a name="sighup"></a><h3>SIGHUP</h3>
<p>Reloads the configuration file by gracefully restarting the worker process. Fluentd will try to flush the entire memory buffer at once, but will not retry if the flush fails. Fluentd will not flush the file buffer; the logs are persisted on the disk by default.</p>
<a name="sigcont"></a><h3>SIGCONT</h3>
<p>Call sigdump to dump fluentd internal status. See <a href="trouble-shooting#dump-fluentd-internal-information">trouble-shooting</a> article.</p>
<div style="text-align:right">
  Last updated: 2016-06-06 04:47:13 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/signals">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
