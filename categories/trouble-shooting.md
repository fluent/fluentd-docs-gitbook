<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/trouble-shooting">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Troubleshooting Fluentd</h1>
</hgroup>
<a name="look-at-logs"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#look-at-logs">Look at Logs</a></li>
<li class="toc-item"><a href="#turn-on-verbose-logging">Turn on Verbose Logging</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#rpm/deb">rpm/deb</a></li>
<li class="sub-toc-item"><a href="#gem">gem</a></li>
</ul>
<li class="toc-item"><a href="#dump-fluentd-internal-information">Dump fluentd internal information</a></li>
<li class="toc-item"><a href="#high-cpu-usage-issue">High CPU usage issue</a></li>
<li class="toc-item"><a href="#check-uncaught-logs">Check uncaught logs</a></li>
</ul>
</section>
<h2>Look at Logs</h2>
<p>If things aren’t happening as expected, please first look at your logs. For td-agent (rpm/deb), the logs are located at <code>/var/log/td-agent/td-agent.log</code>.</p>
<a name="turn-on-verbose-logging"></a><h2>Turn on Verbose Logging</h2>
<p>You can get more information about the logs if verbose logging is turned on. Please follow the steps below.</p>
<a name="rpm/deb"></a><h3>rpm/deb</h3>
<ol>
<li>Open the service setting file for td-agent (see below for its file path).</li>
<li>Add <code>-vv</code> to TD_AGENT_OPTIONS.</li>
<li>
<p>Restart td-agent.</p>
<pre class="CodeRay"># Add the following settings to:
# - /etc/sysconfig/td-agent (CentOS/RedHat)
# - /etc/default/td-agent (Debian/Ubuntu)
TD_AGENT_OPTIONS="-vv"
</pre>
</li>
</ol>
<p>Note: The environment variable TD_AGENT_OPTIONS has been introduced in td-agent v2.2.1. If you are using an older version of td-agent, you need to edit <code>/etc/init.d/td-agent</code> and insert <code>-vv</code> options to TD_AGENT_ARGS or DAEMON_ARGS manually.</p>
<a name="gem"></a><h3>gem</h3>
<p>Please add <code>-vv</code> to your command line.</p>
<pre class="CodeRay">$ fluentd .. -vv
</pre>
<a name="dump-fluentd-internal-information"></a><h2>Dump fluentd internal information</h2>
<p>Fluentd uses <a href="https://github.com/frsyuki/sigdump">sigdump</a> for dumping fluentd internal information to local file, e.g. thread dump, object allocation and etc.
If you have a problem with fluentd like process hang, please send <code>SIGCONT</code> to fluentd parent and child processes.</p>
<a name="high-cpu-usage-issue"></a><h2>High CPU usage issue</h2>
<p>If fluentd suddenly hits unexpected high CPU usage problem, there are several reasons:</p>
<ul>
<li>a plugin has a race condition or similar bug</li>
<li>dependent gems have a bug</li>
<li>regular expression with broken data</li>
<li>system calls has a bug, e.g. <code>inotify</code> with lots of files</li>
</ul>
<p>In such cases, you can use <code>perf</code> tool on recent Linux to investigate the problem. See <a href="http://www.brendangregg.com/perf.html">Linux perf Examples</a> page.<br/>
If you want to know which call causes the problem, <a href="https://gist.github.com/nurse/0619b6af90df140508c2">pid2line.rb</a> is useful.</p>
<a name="check-uncaught-logs"></a><h2>Check uncaught logs</h2>
<p>You sometimes hit unexpected shutdown with non-zero exit status like below.</p>
<pre class="CodeRay">2016-01-01 00:00:00 +0800 [info]: starting fluentd-0.12.28
2016-01-01 00:00:00 +0800 [info]: reading config file path="/etc/td-agent/td-agent.conf"
[...snip...]
2016-01-01 00:00:02 +0800 [info]: process finished code=6
</pre>
<p>If the problem happens inside ruby, e.g. segmentation fault, C extension bug, etc,
you can’t get entire log when fluentd process is daemonized.
For example, td-agent launches fluentd with <code>--daemon</code> option. In td-agent case,
you can get entire log using following command to simulate <code>/etc/init.d/td-agent start</code> without daemonize.</p>
<pre class="CodeRay">$ sudo LD_PRELOAD=/opt/td-agent/embedded/lib/libjemalloc.so /usr/sbin/td-agent -c /etc/td-agent/td-agent.conf --user td-agent --group td-agent
</pre>
<div style="text-align:right">
  Last updated: 2016-09-05 20:13:06 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/trouble-shooting">v1.0 (td-agent3)</a>
    
  

  

  
    
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