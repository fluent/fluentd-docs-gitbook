<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/high-availability">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Fluentd High Availability Configuration</h1>
</hgroup>
<p>For high-traffic websites, we recommend using a high availability configuration of <code>Fluentd</code>.</p>
<a name="message-delivery-semantics"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#message-delivery-semantics">Message Delivery Semantics</a></li>
<li class="toc-item"><a href="#network-topology">Network Topology</a></li>
<li class="toc-item"><a href="#log-forwarder-configuration">Log Forwarder Configuration</a></li>
<li class="toc-item"><a href="#log-aggregator-configuration">Log Aggregator Configuration</a></li>
<li class="toc-item"><a href="#failure-case-scenarios">Failure Case Scenarios</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#forwarder-failure">Forwarder Failure</a></li>
<li class="sub-toc-item"><a href="#aggregator-failure">Aggregator Failure</a></li>
</ul>
<li class="toc-item"><a href="#trouble-shooting">Trouble Shooting</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#%E2%80%9Cno-nodes-are-available%E2%80%9D">“no nodes are available”</a></li>
</ul>
</ul>
</section>
<h2>Message Delivery Semantics</h2>
<p>Fluentd is designed primarily for event-log delivery systems.</p>
<p>In such systems, several delivery guarantees are possible:</p>
<ul>
<li>
<em>At most once</em>: Messages are immediately transferred. If the transfer succeeds, the message is never sent out again. However, many failure scenarios can cause lost messages (ex: no more write capacity)</li>
<li>
<em>At least once</em>: Each message is delivered at least once. In failure cases, messages may be delivered twice.</li>
<li>
<em>Exactly once</em>: Each message is delivered once and only once. This is what people want.</li>
</ul>
<p>If the system “can’t lose a single event”, and must also transfer “<em>exactly once</em>”, then the system must stop ingesting events when it runs out of write capacity. The proper approach would be to use synchronous logging and return errors when the event cannot be accepted.</p>
<p>That’s why <em>Fluentd provides ‘At most once’ and ‘At least once’ transfers</em>. In order to collect massive amounts of data without impacting application performance, a data logger must transfer data asynchronously. This improves performance at the cost of potential delivery failures.</p>
<p>However, most failure scenarios are preventable. The following sections describe how to set up Fluentd’s topology for high availability.</p>
<a name="network-topology"></a><h2>Network Topology</h2>
<p>To configure Fluentd for high availability, we assume that your network consists of ‘<em>log forwarders</em>’ and ‘<em>log aggregators</em>’.</p>
<p><img src="/images/fluentd_ha.png" width="600px"/></p>
<p>‘<em>log forwarders</em>’ are typically installed on every node to receive local events. Once an event is received, they forward it to the ‘log aggregators’ through the network.</p>
<p>‘<em>log aggregators</em>’ are daemons that continuously receive events from the log forwarders. They buffer the events and periodically upload the data into the cloud.</p>
<p>Fluentd can act as either a log forwarder or a log aggregator, depending on its configuration. The next sections describes the respective setups. We assume that the active log aggregator has ip ‘192.168.0.1’ and that the backup has ip ‘192.168.0.2’.</p>
<a name="log-forwarder-configuration"></a><h2>Log Forwarder Configuration</h2>
<p>Please add the following lines to your config file for log forwarders. This will configure your log forwarders to transfer logs to log aggregators.</p>
<pre class="CodeRay"><span class="string"># TCP input
</span><span class="string">&lt;source&gt;
</span><span class="string">  @type forward
</span><span class="string">  port 24224
</span><span class="string">&lt;/source&gt;
</span><span class="string">
</span><span class="string"># HTTP input
</span><span class="string">&lt;source&gt;
</span><span class="string">  @type http
</span><span class="string">  port 8888
</span><span class="string">&lt;/source&gt;
</span><span class="string">
</span><span class="string"># Log Forwarding
</span><span class="string">&lt;match mytag.**&gt;
</span><span class="string">  @type forward
</span><span class="string">
</span><span class="string">  # primary host
</span><span class="string">  &lt;server&gt;
</span><span class="string">    host 192.168.0.1
</span><span class="string">    port 24224
</span><span class="string">  &lt;/server&gt;
</span><span class="string">  # use secondary host
</span><span class="string">  &lt;server&gt;
</span><span class="string">    host 192.168.0.2
</span><span class="string">    port 24224
</span><span class="string">    standby
</span><span class="string">  &lt;/server&gt;
</span><span class="string">
</span><span class="string">  # use longer flush_interval to reduce CPU usage.
</span><span class="string">  # note that this is a trade-off against latency.
</span><span class="string">  flush_interval 60s
</span><span class="string">&lt;/match&gt;
</span></pre>
<p>When the active aggregator (192.168.0.1) dies, the logs will instead be sent to the backup aggregator (192.168.0.2). If both servers die, the logs are buffered on-disk at the corresponding forwarder nodes.</p>
<a name="log-aggregator-configuration"></a><h2>Log Aggregator Configuration</h2>
<p>Please add the following lines to the config file for log aggregators. The input source for the log transfer is TCP.</p>
<pre class="CodeRay"><span class="string"># Input
</span><span class="string">&lt;source&gt;
</span><span class="string">  @type forward
</span><span class="string">  port 24224
</span><span class="string">&lt;/source&gt;
</span><span class="string">
</span><span class="string"># Output
</span><span class="string">&lt;match mytag.**&gt;
</span><span class="string">  ...
</span><span class="string">&lt;/match&gt;
</span></pre>
<p>The incoming logs are buffered, then periodically uploaded into the cloud. If upload fails, the logs are stored on the local disk until the retransmission succeeds.</p>
<a name="failure-case-scenarios"></a><h2>Failure Case Scenarios</h2>
<a name="forwarder-failure"></a><h3>Forwarder Failure</h3>
<p>When a log forwarder receives events from applications, the events are first written into a disk buffer (specified by buffer_path). After every flush_interval, the buffered data is forwarded to aggregators.</p>
<p>This process is inherently robust against data loss. If a log forwarder’s fluentd process dies, the buffered data is properly transferred to its aggregator after it restarts. If the network between forwarders and aggregators breaks, the data transfer is automatically retried.</p>
<p>However, possible message loss scenarios do exist:</p>
<ul>
<li>The process dies immediately after receiving the events, but before writing them into the buffer.</li>
<li>The forwarder’s disk is broken, and the file buffer is lost.</li>
</ul>
<a name="aggregator-failure"></a><h3>Aggregator Failure</h3>
<p>When log aggregators receive events from log forwarders, the events are first written into a disk buffer (specified by buffer_path). After every flush_interval, the buffered data is uploaded into the cloud.</p>
<p>This process is inherently robust against data loss. If a log aggregator’s fluentd process dies, the data from the log forwarder is properly retransferred after it restarts. If the network between aggregators and the cloud breaks, the data transfer is automatically retried.</p>
<p>However, possible message loss scenarios do exist:</p>
<ul>
<li>The process dies immediately after receiving the events, but before writing them into the buffer.</li>
<li>The aggregator’s disk is broken, and the file buffer is lost.</li>
</ul>
<a name="trouble-shooting"></a><h2>Trouble Shooting</h2>
<a name="%E2%80%9Cno-nodes-are-available%E2%80%9D"></a><h3>“no nodes are available”</h3>
<p>Please make sure that you can communicate with port 24224 using <strong>not only TCP, but also UDP</strong>. These commands will be useful for checking the network configuration.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> telnet host 24224
</span><span class="comment">$</span><span class="function"> nmap -p 24224 -sU host
</span></pre>
<p>Please note that there is one <a href="http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&amp;cmd=displayKC&amp;externalId=2019944">known issue</a> where VMware will occasionally lose small UDP packages used for heartbeat.</p>
<div style="text-align:right">
  Last updated: 2015-12-01 21:20:32 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/high-availability">v1.0 (td-agent3)</a>
    
  

  

  
    
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