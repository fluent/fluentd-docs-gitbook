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
<h1>Collecting Log Data from Windows</h1>
</hgroup>
<p>In this article, we explain how to get started with collecting data from Windows machines (This setup has been tested on a 64-bit Windows 8 machine).</p>
<p>As of v10, Fluentd does NOT support Windows. However, there are times when you must collect data streams from Windows machines. For example:</p>
<ol>
<li>
<strong>Tailing log files on Windows</strong>: collect and analyze log data from a Windows application.</li>
<li>
<strong>Collecting Windows Event Logs</strong>: collect event logs from your Windows servers for system analysis, compliance checking, etc.</li>
</ol>
<p><strong>If you’re not familiar with Fluentd</strong>, please learn more about Fluentd first.</p>
<center>
<div class="btn-look" style="width: 300px;">
<a href="/articles/architecture">What is Fluentd?</a>
</div>
</center>
<p><br/>
<br/></p>
<a name="prerequisites"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#prerequisites">Prerequisites</a></li>
<li class="toc-item"><a href="#setup">Setup</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#set-up-a-linux-server-with-rsyslogd-and-fluentd">Set up a Linux server with rsyslogd and Fluentd</a></li>
<li class="sub-toc-item"><a href="#set-up-nxlog-on-windows">Set up nxlog on Windows</a></li>
<li class="sub-toc-item"><a href="#test">Test</a></li>
<li class="sub-toc-item"><a href="#parsing-json-logs">Parsing JSON Logs</a></li>
<li class="sub-toc-item"><a href="#next-step">Next Step</a></li>
</ul>
<li class="toc-item"><a href="#learn-more">Learn More</a></li>
</ul>
</section>
<h2>Prerequisites</h2>
<ol>
<li>
<a href="http://nxlog.org">nxlog</a>, an open source log management tool that runs on Windows.</li>
<li>A Linux server (we assume Ubuntu 12 for this article)</li>
</ol>
<a name="setup"></a><h2>Setup</h2>
<a name="set-up-a-linux-server-with-rsyslogd-and-fluentd"></a><h3>Set up a Linux server with rsyslogd and Fluentd</h3>
<ol>
<li>Get hold of a Linux server. In this example, we assume it is Ubuntu.</li>
<li><strong>Make sure it has ports open for TCP. In the following example, we assume port 5140 is open.</strong></li>
<li>
<a href="/articles/install-by-deb">Install td-agent</a>. (See <a href="/categories/installation">here</a> for various ways to install Fluentd/Treasure Agent)</li>
<li>
<p>Edit td-agent’s configuration file located at <code>/etc/td-agent/td-agent.conf</code> and add the following lines</p>
<pre class="CodeRay"> &lt;source&gt;
   @type tcp
   format none
   port 5140
   tag windowslog
 &lt;/source&gt;    
 &lt;match windowslog&gt;
   @type stdout
 &lt;/match&gt;

 The above code listens to port 5140 (UDP) and outputs the data to stdout (which is piped to `/var/log/td-agent/td-agent.log`)    
</pre>
</li>
<li>Start td-agent by running <code>sudo service td-agent start</code>
</li>
</ol>
<a name="set-up-nxlog-on-windows"></a><h3>Set up nxlog on Windows</h3>
<ol>
<li>Follow <a href="http://nxlog.org/download">this link</a> and download a copy of nxlog onto the Windows machine you want to collect log data from. Open the downloaded installer and follow the instructions. By default, it should be installed in <code>C:\Program Files (x86)\nxlog</code>
</li>
<li>
<p>Create an nxlog config file as follows and save it as <code>nxlog.conf</code>:</p>
<pre class="CodeRay"> #define ROOT C:\Program Files\nxlog
 define ROOT C:\Program Files (x86)\nxlog

 Moduledir %ROOT%\modules
 CacheDir %ROOT%\data
 Pidfile %ROOT%\data\nxlog.pid
 SpoolDir %ROOT%\data
 LogFile %ROOT%\data\nxlog.log

 &lt;Input in&gt;
   Module im_file
   File 'C:\Users\SomeUser\Desktop\nxlog_test.log' #Put the file to be tailed here.
   SavePos TRUE
   InputType LineBased
 &lt;/Input&gt;

 &lt;Output out&gt;
   Module om_tcp
   Host LINUX_MACHINE_RUNNING_FLUENTD
   Port 5140
 &lt;/Output&gt; 

 &lt;Route r&gt;
   Path in =&gt; out
 &lt;/Route&gt;
</pre>
<p> This configuration will send each line of the log file (see the File parameter inside &lt;Input in&amp;gt…&lt;/Input&gt;) as a syslog message to a remote Fluentd/Treasure Agent instance.</p>
</li>
</ol>
<a name="test"></a><h3>Test</h3>
<ol>
<li>
<p>Go to nxlog’s directory (in Powershell or Command Prompt) and run the following command:</p>
<pre class="CodeRay"> \nxlog.exe -f -c  &lt;path to nxlog.conf&gt;
</pre>
<p> The “-f” option runs nxlog in the foreground (this is for testing). If this is for production, you would want to turn it into a Windows Service.</p>
</li>
<li>
<p>Once nxlog is running, add a new line “Windows is awesome” into the tailed file like this:</p>
<pre class="CodeRay"> echo Windows is awesome &gt;&gt; 'C:\Users\SomeUser\Desktop\nxlog_test.log'
</pre>
</li>
<li>
<p>Now, go to the Linux server and run</p>
<pre class="CodeRay"> $ sudo tail -f /var/log/td-agent/td-agent.log
 ...
 ...
 ...
 2014-12-20 02:19:36 +0000 windowslog: {"message":"Windows is awesome \r"}
</pre>
</li>
<li>You successfully sent data from a Windows machine to a remote Fluentd instance running on Linux.</li>
</ol>
<a name="parsing-json-logs"></a><h3>Parsing JSON Logs</h3>
<p>If you are sending JSON logs on Windows to Fluentd, Fluentd can parse them as they come in. To do, simply change Fluentd’s configuration as follows. Note the change from <code>format none</code> to <code>format json</code>. (See <a href="parser-plugin-overview">this article</a> for more details about the parser plugins)</p>
<pre class="CodeRay">&lt;source&gt;
  @type tcp
  format json
  port 5140
  tag windowslog
&lt;/source&gt;    
&lt;match windowslog&gt;
  @type stdout
&lt;/match&gt;
</pre>
<p>Then, if you add a new line to the file on your windows machine like this:</p>
<pre class="CodeRay">echo {"name":"Sadayuki", "age":27} &gt;&gt; 'C:\Users\SomeUser\Desktop\nxlog_test.log'
</pre>
<p>On the Linux machine running Fluentd, you see the following line:</p>
<pre class="CodeRay">2014-12-20 02:22:44 +0000 windowslog: {"name":"Sadayuki","age":27}
</pre>
<a name="next-step"></a><h3>Next Step</h3>
<p>This example showed that we can collect data from a Windows machine and send it to a remote Fluentd instance. However, the data is not terribly useful because each line of data is placed into the “message” field as unstructured text. For production purposes, you would probably want to write a plugin/extend the syslog plugin so that you can parse the “message” field in the event.</p>
<a name="learn-more"></a><h2>Learn More</h2>
<ul>
<li><a href="architecture">Fluentd Architecture</a></li>
<li><a href="quickstart">Fluentd Get Started</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-06-13 06:11:23 UTC
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