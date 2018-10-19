<section id="main">
<div id="page">
<div class="topic_content">
<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/quickstart">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Quickstart Guide</h1>
</hgroup>
<p>Let’s get started with <strong>Fluentd</strong>! <strong>Fluentd</strong> is a fully free and fully open-source log collector that instantly enables you to have a ‘<strong>Log Everything</strong>’ architecture with <a href="http://fluentd.org/plugin/">600+ types of systems</a>.</p>
<center>
<img src="/images/fluentd-architecture.png" width="450px"/><br/><br/>
</center>
<p>Fluentd treats logs as JSON, a popular machine-readable format. It is written primarily in C with a thin-Ruby wrapper that gives users flexibility.</p>
<p>Fluentd’s scalability has been proven in the field: its largest user currently collects logs from <strong>500,000+ servers</strong>.</p>
<a name="step1:-installing-fluentd"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#step1:-installing-fluentd">Step1: Installing Fluentd</a></li>
<li class="toc-item"><a href="#step2:-use-cases">Step2: Use Cases</a></li>
<li class="toc-item"><a href="#step3:-learn-more">Step3: Learn More</a></li>
</ul>
</section>
<h2>Step1: Installing Fluentd</h2>
<p>Please follow the installation/quickstart guides below that matches your environment.</p>
<ul>
<li>
<a href="install-by-rpm">Install Fluentd by RPM package</a> (Redhat Linux)</li>
<li>
<a href="install-by-deb">Install Fluentd by Deb package</a> (Ubuntu/Debian Linux)</li>
<li>
<a href="install-by-dmg">Install Fluentd by DMG package</a> (Mac OS X)</li>
<li><a href="install-by-gem">Install Fluentd by Ruby Gem</a></li>
<li><a href="install-by-chef">Install Fluentd by Chef</a></li>
<li><a href="install-from-source">Install Fluentd from source</a></li>
</ul>
<table class="note">
<td class="icon"></td>
<td class="content">Fluentd v0.12 doesn't support Windows environment. Please see <a href="windows">Collecting Log Data from Windows</a> for details. Fluentd v1.x supports Windows.</td>
</table>
<a name="step2:-use-cases"></a><h2>Step2: Use Cases</h2>
<p>The articles shown below cover the typical use cases of Fluentd. Please refer to the article(s) that suits your needs.</p>
<ul>
<li>Use Cases

<ul>
<li><a href="free-alternative-to-splunk-by-fluentd">Data Search like Splunk</a></li>
<li><a href="splunk-like-grep-and-alert-email">Data Filtering and Alerting</a></li>
<li><a href="http-to-td">Data Analytics with Treasure Data</a></li>
<li><a href="apache-to-mongodb">Data Collection to MongoDB</a></li>
<li><a href="http-to-hdfs">Data Collection to HDFS</a></li>
<li><a href="apache-to-s3">Data Archiving to Amazon S3</a></li>
<li><a href="windows">Windows Event Collection</a></li>
</ul>
</li>
<li>Basic Configuration

<ul>
<li><a href="config-file">Config File</a></li>
</ul>
</li>
<li>Application Logs

<ul>
<li>
<a href="ruby">Ruby</a>, <a href="java">Java</a>, <a href="python">Python</a>, <a href="php">PHP</a>, <a href="perl">Perl</a>, <a href="nodejs">Node.js</a>, <a href="scala">Scala</a>
</li>
</ul>
</li>
<li>Happy Users :)

<ul>
<li><a href="users">Users</a></li>
</ul>
</li>
</ul>
<a name="step3:-learn-more"></a><h2>Step3: Learn More</h2>
<p>The articles shown below will provide detailed information for you to learn more about Fluentd.</p>
<ul>
<li><a href="architecture">Architecture Overview</a></li>
<li><a href="life-of-a-fluentd-event">Life of a Fluentd Event</a></li>
<li>Plugin Overview

<ul>
<li><a href="input-plugin-overview">Input Plugins</a></li>
<li><a href="output-plugin-overview">Output Plugins</a></li>
<li><a href="buffer-plugin-overview">Buffer Plugins</a></li>
<li><a href="filter-plugin-overview">Filter Plugins</a></li>
<li><a href="parser-plugin-overview">Parser Plugins</a></li>
<li><a href="formatter-plugin-overview">Formatter Plugins</a></li>
</ul>
</li>
<li><a href="high-availability">High Availability Configuration</a></li>
<li><a href="faq">FAQ</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2017-03-08 14:51:05 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/quickstart">v1.0 (td-agent3)</a>
    
  

  

  
    
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