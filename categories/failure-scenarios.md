<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/failure-scenarios">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Failure Scenarios</h1>
</hgroup>
<p>This article lists various Fluentd failure scenarios. We will assume that you have configured Fluentd for <a href="high-availability">High Availability</a>, so that each app node has its local <em>forwarders</em> and all logs are aggregated into multiple <em>aggregators</em>.</p>
<a name="apps-cannot-post-records-to-forwarder"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#apps-cannot-post-records-to-forwarder">Apps Cannot Post Records to Forwarder</a></li>
<li class="toc-item"><a href="#forwarder-or-aggregator-fluentd-goes-down">Forwarder or Aggregator Fluentd Goes Down</a></li>
<li class="toc-item"><a href="#storage-destination-goes-down">Storage Destination Goes Down</a></li>
</ul>
</section>
<h2>Apps Cannot Post Records to Forwarder</h2>
<p>In the failure scenario, the application sometimes fails to post records to its local Fluentd instance when using logger libraries of various languages. Depending on the maturity of each logger library, some clever mechanisms have been implemented to prevent data loss.</p>
<h4>1) Memory Buffering (available for <a href="ruby">Ruby</a>, <a href="java">Java</a>, <a href="python">Python</a>, <a href="perl">Perl</a>)</h4>
<p>If the destination Fluentd instance dies, certain logger implementations will use extra memory to hold incoming logs. When Fluentd comes back, these loggers will automatically send out the buffered logs to Fluentd again. Once the maximum buffer memory size is reached, most current implementations will write the data onto the disk or throw away the logs.</p>
<h4>2) Exponential Backoff (available for <a href="ruby">Ruby</a>, <a href="java">Java</a>)</h4>
<p>When trying to resend logs to the local forwarder, some implementations will use exponential backoff to prevent excessive re-connect requests.</p>
<a name="forwarder-or-aggregator-fluentd-goes-down"></a><h2>Forwarder or Aggregator Fluentd Goes Down</h2>
<p>What happens when a Fluentd process dies for some reason? It depends on your buffer configuration.</p>
<h4>buf_memory</h4>
<p>If you’re using <a href="buf_memory">buf_memory</a>, the buffered data is completely lost. This is a tradeoff for higher performance. Lowering the flush_interval will reduce the probability of losing data, but will increase the number of transfers between forwarders and aggregators.</p>
<h4>buf_file</h4>
<p>If you’re using <a href="buf_file">buf_file</a>, the buffered data is stored on the disk. After Fluentd recovers, it will try to send the buffered data to the destination again.</p>
<p>Please note that the data will be lost if the buffer file is broken due to I/O errors. The data will also be lost if the disk is full, since there is nowhere to store the data on disk.</p>
<a name="storage-destination-goes-down"></a><h2>Storage Destination Goes Down</h2>
<p>If the storage destination (e.g. Amazon S3, MongoDB, HDFS, etc.) goes down, Fluentd will keep trying to resend the buffered data. The retry logic depends on the plugin implementation.</p>
<p>If you’re using <a href="buf_memory">buf_memory</a>, aggregators will stop accepting new logs once they reach their buffer limits. If you’re using <a href="buf_file">buf_file</a>, aggregators will continue accepting logs until they run out of disk space.</p>
<div style="text-align:right">
  Last updated: 2016-06-06 04:47:13 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/failure-scenarios">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>