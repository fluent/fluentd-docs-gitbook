<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/fluentd-ui">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Fluentd UI</h1>
</hgroup>
<p><a href="https://github.com/fluent/fluentd-ui">fluentd-ui</a> is a browser-based <a href="http://fluentd.org/">fluentd</a> and <a href="http://docs.treasuredata.com/articles/td-agent">td-agent</a> manager that supports following operations.</p>
<ul>
<li>Install, uninstall, and upgrade Fluentd plugins</li>
<li>start/stop/restart fluentd process</li>
<li>Configure Fluentd settings such as config file content, pid file path, etc</li>
<li>View Fluentd log with simple error viewer</li>
</ul>
<a name="getting-started"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#getting-started">Getting Started</a></li>
<li class="toc-item"><a href="#screenshots">Screenshots</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#dashboard">Dashboard</a></li>
<li class="sub-toc-item"><a href="#setting">Setting</a></li>
<li class="sub-toc-item"><a href="#in_tail-setting">in_tail setting</a></li>
<li class="sub-toc-item"><a href="#plugin">Plugin</a></li>
</ul>
</ul>
</section>
<h2>Getting Started</h2>
<p>If you’ve installed td-agent, you can start it by <code>td-agent-ui start</code> as below:</p>
<pre class="CodeRay">$ sudo /usr/sbin/td-agent-ui start
Puma 2.9.2 starting...
* Min threads: 0, max threads: 16
* Environment: production
* Listening on tcp://0.0.0.0:9292
</pre>
<p>Or if you use fluentd gem, install fluentd-ui via <code>gem</code> command at first.</p>
<pre class="CodeRay">$ gem install -V fluentd-ui
$ fluentd-ui start
Puma 2.9.2 starting...
* Min threads: 0, max threads: 16
* Environment: production
* Listening on tcp://0.0.0.0:9292
</pre>
<p>Then, open <a href="http://localhost:9292/">http://localhost:9292/</a> by your browser.</p>
<p>The default account is username=“admin” and password=“changeme”</p>
<p><img alt="fluentd-ui" src="/images/fluentd-ui/fluentd-ui.gif"/></p>
<a name="screenshots"></a><h2>Screenshots</h2>
<p>(v0.3.9)</p>
<a name="dashboard"></a><h3>Dashboard</h3>
<p><img alt="dashboard" src="/images/fluentd-ui/dashboard.gif"/></p>
<a name="setting"></a><h3>Setting</h3>
<p><img alt="setting" src="/images/fluentd-ui/setting.gif"/></p>
<a name="in_tail-setting"></a><h3>in_tail setting</h3>
<p><img alt="in_tail" src="/images/fluentd-ui/in_tail.gif"/></p>
<a name="plugin"></a><h3>Plugin</h3>
<p><img alt="plugin" src="/images/fluentd-ui/plugin.gif"/></p>
<p><img alt="ss01" src="/images/fluentd-ui/01.png"/>
<img alt="ss02" src="/images/fluentd-ui/02.png"/>
<img alt="ss03" src="/images/fluentd-ui/03.png"/>
<img alt="ss04" src="/images/fluentd-ui/04.png"/>
<img alt="ss05" src="/images/fluentd-ui/05.png"/></p>
<div style="text-align:right">
  Last updated: 2015-05-28 06:46:49 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/fluentd-ui">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>