<hgroup>
<h1>Forwarding Data Over SSL</h1>
</hgroup>
<a name="overview"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#overview">Overview</a></li>
<li class="toc-item"><a href="#setup:-receiver">Setup: Receiver</a></li>
<li class="toc-item"><a href="#setup:-sender">Setup: Sender</a></li>
<li class="toc-item"><a href="#confirm:-send-an-event-over-ssl">Confirm: Send an Event Over SSL</a></li>
<li class="toc-item"><a href="#resources">Resources</a></li>
</ul>
</section>
<h2>Overview</h2>
<p>This is a quick tutorial on how to use the <a href="//github.com/tagomoris/fluent-plugin-secure-forward">secure forward plugin</a> to <strong>enable SSL for Fluentd-to-Fluentd data transport</strong>.</p>
<p>It is intended as a quick introduction. For comprehensive documentation, including parameter definitions, please checkout out the <a href="out_secure_forward">out_secure_forward</a> and <a href="in_secure_forward">in_secure_forward</a>.</p>
<a name="setup:-receiver"></a><h2>Setup: Receiver</h2>
<p>First, install the secure forward plugin.</p>
<ul>
<li>Fluentd: <code>gem install fluent-plugin-secure-forward</code>
</li>
<li>td-agent v2: <code>/usr/sbin/td-agent-gem install fluent-plugin-secure-forward</code>
</li>
<li>td-agent v1: <code>/usr/lib/fluent/ruby/bin/fluent-gem install fluent-plugin-secure-forward</code>
</li>
</ul>
<p>Then, set up the configuration file as follows:</p>
<pre class="CodeRay">&lt;source&gt;
  @type secure_forward
  shared_key YOUR_SHARED_KEY
  self_hostname server.fqdn.local
  cert_auto_generate yes
&lt;/source&gt;

&lt;match secure.**&gt;
  @type stdout
&lt;/match&gt;
</pre>
<p>The <code>&lt;match&gt;</code> clause is there to print out the forwarded message into STDOUT (which is fed into <code>var/log/td-agent/td-agent.log</code> for td-agent) using <a href="out_stdout">out_stdout</a>.</p>
<p>Then, (re)start Fluentd/td-agent.</p>
<a name="setup:-sender"></a><h2>Setup: Sender</h2>
<p>First, install the secure forward plugin.</p>
<ul>
<li>Fluentd: <code>fluent-gem install fluent-plugin-secure-forward</code>
</li>
<li>td-agent v2: <code>/usr/sbin/td-agent-gem install fluent-plugin-secure-forward</code>
</li>
<li>td-agent v1: <code>/usr/lib/fluent/ruby/bin/fluent-gem install fluent-plugin-secure-forward</code>
</li>
</ul>
<p>Then, set up the configuration file as follows:</p>
<pre class="CodeRay">&lt;source&gt;
  @type forward
&lt;/source&gt;

&lt;match secure.**&gt;
  @type secure_forward
  shared_key YOUR_SHARED_KEY
  self_hostname "#{Socket.gethostname}"
  &lt;server&gt;
    host RECEIVER_IP
    port 24284
  &lt;/server&gt;
&lt;/match&gt;
</pre>
<p>The <code>&lt;source&gt;</code> clause is there to feed test data into Fluentd using <a href="in_forward">in_forward</a>. Make sure that <code>YOUR_SHARED_KEY</code> is same with the receiver’s.</p>
<p>Then, (re)start td-agent.</p>
<a name="confirm:-send-an-event-over-ssl"></a><h2>Confirm: Send an Event Over SSL</h2>
<p>On the sender machine, run the following command using <code>fluent-cat</code></p>
<ul>
<li>Fluentd:
<code>echo '{"message":"testing the SSL forwarding"}' | fluent-cat --json secure.test</code>
</li>
<li>td-agent v2:
<code>echo '{"message":"testing the SSL forwarding"}' | /opt/td-agent/embedded/bin/fluent-cat --json secure.test</code>
</li>
<li>td-agent v1:
<code>echo '{"message":"testing the SSL forwarding"}' | /usr/lib/fluent/ruby/bin/fluent-cat --json secure.test</code>
</li>
</ul>
<p>Now, checking the receiver’s Fluentd’s log (for td-agent, this would be <code>/var/log/td-agent/td-agent.log</code>), there should be a line like this:</p>
<pre class="CodeRay">2014-10-21 18:18:26 -0400 secure.test: {"message":"testing the SSL forwarding"}
</pre>
<a name="resources"></a><h2>Resources</h2>
<ul>
<li><a href="in_secure_forward">in_secure_forward</a></li>
<li><a href="out_secure_forward">out_secure_forward</a></li>
<li><a href="//github.com/fluent/fluent-plugin-secure-forward">the secure forward plugin’s GitHub repo</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-07-01 09:50:35 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
