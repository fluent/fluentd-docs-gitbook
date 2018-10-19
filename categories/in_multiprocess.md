<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Multiprocess Input Plugin</h1>
</hgroup>
<p>By default, Fluentd only uses a single CPU core on the system. The <code>in_multiprocess</code> Input plugin enables Fluentd to use multiple CPU cores by spawning multiple child processes. One Fluentd user is using this plugin to handle 10+ billion records / day.</p>
<a name="install"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#install">Install</a></li>
<li class="toc-item"><a href="#example-configuration">Example Configuration</a></li>
<li class="toc-item"><a href="#parameters">Parameters</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#@type-(required)">@type (required)</a></li>
<li class="sub-toc-item"><a href="#graceful_kill_interval">graceful_kill_interval</a></li>
<li class="sub-toc-item"><a href="#graceful_kill_interval_increment">graceful_kill_interval_increment</a></li>
<li class="sub-toc-item"><a href="#graceful_kill_timeout">graceful_kill_timeout</a></li>
<li class="sub-toc-item"><a href="#process-(required)">process (required)</a></li>
<li class="sub-toc-item"><a href="#cmdline-(required)">cmdline (required)</a></li>
<li class="sub-toc-item"><a href="#sleep_before_start">sleep_before_start</a></li>
<li class="sub-toc-item"><a href="#sleep_before_shutdown">sleep_before_shutdown</a></li>
</ul>
</ul>
</section>
<h2>Install</h2>
<p><code>in_multiprocess</code> is NOT included in td-agent by default. td-agent users must install fluent-plugin-multiprocess manually.</p>
<ul>
<li>Fluentd: <code>fluent-gem install fluent-plugin-multiprocess</code>
</li>
<li>td-agent v2: <code>/usr/sbin/td-agent-gem install fluent-plugin-multiprocess</code>
</li>
<li>td-agent v1: <code>/usr/lib/fluent/ruby/bin/fluent-gem install fluent-plugin-multiprocess</code>
</li>
</ul>
<a name="example-configuration"></a><h2>Example Configuration</h2>
<pre class="CodeRay">&lt;source&gt;
  @type multiprocess

  &lt;process&gt;
    cmdline -c /etc/fluent/fluentd_child1.conf --log /var/log/fluent/fluentd_child1.log
    sleep_before_start 1s
    sleep_before_shutdown 5s
  &lt;/process&gt;
  &lt;process&gt;
    cmdline -c /etc/fluent/fluentd_child2.conf --log /var/log/fluent/fluentd_child2.log
    sleep_before_start 1s
    sleep_before_shutdown 5s
  &lt;/process&gt;
  &lt;process&gt;
    cmdline -c /etc/fluent/fluentd_child3.conf --log /var/log/fluent/fluentd_child3.log
    sleep_before_start 1s
    sleep_before_shutdown 5s
  &lt;/process&gt;
&lt;/source&gt;
</pre>
<table class="note">
<td class="icon"></td>
<td class="content">Please see the <a href="config-file">Config File</a> article for the basic structure and syntax of the configuration file.</td>
</table>
<table class="note">
<td class="icon"></td>
<td class="content">Especially for daemonized fluentd (ex: td-agent), `--log` option MUST be specified to put logs of child processes.</td>
</table>
<a name="parameters"></a><h2>Parameters</h2>
<a name="@type-(required)"></a><h3>@type (required)</h3>
<p>The value must be <code>multiprocess</code>.</p>
<a name="graceful_kill_interval"></a><h3>graceful_kill_interval</h3>
<p>The interval to send the signal to gracefully shut down the process (default: 2sec).</p>
<a name="graceful_kill_interval_increment"></a><h3>graceful_kill_interval_increment</h3>
<p>The increment time, when graceful shutdown fails (default: 3sec).</p>
<a name="graceful_kill_timeout"></a><h3>graceful_kill_timeout</h3>
<p>The timeout, to identify the failure of graceful shutdown (default: 60sec).</p>
<a name="process-(required)"></a><h3>process (required)</h3>
<p>The <code>process</code> section sets the command line arguments of a child process. This plugin creates one child process for each <process> section.</process></p>
<a name="cmdline-(required)"></a><h3>cmdline (required)</h3>
<p>The <code>cmdline</code> option is required in a <process> section</process></p>
<a name="sleep_before_start"></a><h3>sleep_before_start</h3>
<p>This parameter sets the wait time before starting the process (default: 0sec).</p>
<a name="sleep_before_shutdown"></a><h3>sleep_before_shutdown</h3>
<p>This parameter sets the wait time before shutting down the process (default: 0sec).</p>
<h4>log_level option</h4>
<p>The <code>log_level</code> option allows the user to set different levels of logging for each plugin. The supported log levels are: <code>fatal</code>, <code>error</code>, <code>warn</code>, <code>info</code>, <code>debug</code>, and <code>trace</code>.</p>
<p>Please see the <a href="logging">logging article</a> for further details.</p>
<div style="text-align:right">
  Last updated: 2016-10-21 06:29:58 UTC
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
</article>
</div>
<!-- /#topic_content -->
</div>
<!-- /#page -->
</section>