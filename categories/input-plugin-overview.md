<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/input-plugin-overview">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Input Plugin Overview</h1>
</hgroup>
<p>Fluentd has 6 types of plugins: <a href="input-plugin-overview">Input</a>, <a href="parser-plugin-overview">Parser</a>, <a href="filter-plugin-overview">Filter</a>, <a href="output-plugin-overview">Output</a>, <a href="formatter-plugin-overview">Formatter</a> and <a href="buffer-plugin-overview">Buffer</a>. This article gives an overview of Input Plugin.</p>
<a name="overview"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#overview">Overview</a></li>
<li class="toc-item"><a href="#list-of-input-plugins">List of Input Plugins</a></li>
<li class="toc-item"><a href="#other-input-plugins">Other Input Plugins</a></li>
</ul>
</section>
<h2>Overview</h2>
<p>Input plugins extend Fluentd to retrieve and pull event logs from external sources. An input plugin typically creates a thread socket and a listen socket. It can also be written to periodically pull data from data sources.</p>
<a name="list-of-input-plugins"></a><h2>List of Input Plugins</h2>
<ul>
<li><a href="in_forward">in_forward</a></li>
<li><a href="in_unix">in_unix</a></li>
<li><a href="in_http">in_http</a></li>
<li><a href="in_tail">in_tail</a></li>
<li><a href="in_exec">in_exec</a></li>
<li><a href="in_syslog">in_syslog</a></li>
</ul>
<a name="other-input-plugins"></a><h2>Other Input Plugins</h2>
<p>Please refer to this list of available plugins to find out about other Input plugins.</p>
<ul>
<li><a href="http://fluentd.org/plugin/">Fluentd plugins</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2017-04-17 07:04:27 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/input-plugin-overview">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>