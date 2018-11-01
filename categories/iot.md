<hgroup>
<h1>Cloud Data Logger by Raspberry Pi</h1>
</hgroup>
<p><a href="http://www.raspberrypi.org/">Raspberry Pi</a> is a credit-card-sized single-board computer. Because it is low-cost and easy to equip with various types of sensors, using Raspberry Pi as a cloud data logger is one of its ideal use cases.</p>
<center>
<img src="/images/raspberry-pi-cloud-data-logger.png" width="400px"/>
</center>
<p><br/><br/></p>
<p>This article introduces how to transport sensor data from Raspberry Pi to the cloud, using Fluentd as the data collector. For the cloud side, we’ll use the <a href="http://www.fluentd.org/treasuredata">Treasure Data</a> cloud data service as an example, but you can use any cloud service in its place.</p>
<center>
<div class="btn-look" style="width: 300px;">
<a href="/articles/architecture">What is Fluentd?</a>
</div>
</center>
<p><br/>
<br/>
<br/></p>
<a name="install-raspbian"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#install-raspbian">Install Raspbian</a></li>
<li class="toc-item"><a href="#install-fluentd">Install Fluentd</a></li>
<li class="toc-item"><a href="#configure-and-launch-fluentd">Configure and Launch Fluentd</a></li>
<li class="toc-item"><a href="#upload-test">Upload Test</a></li>
<li class="toc-item"><a href="#conclusion">Conclusion</a></li>
<li class="toc-item"><a href="#learn-more">Learn More</a></li>
</ul>
</section>
<h2>Install Raspbian</h2>
<p><a href="http://www.raspbian.org/">Raspbian</a> is a free operating system based on Debian, optimized for the Raspberry Pi. Please install Raspbian on your Raspberry Pi by following the instructions in the blog post below:</p>
<ul>
<li><a href="http://www.andrewmunsell.com/blog/getting-started-raspberry-pi-install-raspbian">Getting Started with Raspberry Pi: Installing Raspbian</a></li>
</ul>
<a name="install-fluentd"></a><h2>Install Fluentd</h2>
<p>Next, we’ll install Fluentd on Raspbian. Raspbian bundles Ruby 1.9.3 by default, but we need the extra development package to install Fluentd.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> sudo aptitude install ruby-dev
</span></pre>
<p>We’ll now install Fluentd and the necessary plugins.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> sudo gem install fluentd -v "~&gt; 0.12.0"
</span><span class="comment">$</span><span class="function"> sudo fluent-gem install fluent-plugin-td
</span></pre>
<a name="configure-and-launch-fluentd"></a><h2>Configure and Launch Fluentd</h2>
<p>Please sign up to Treasure Data from the <a href="https://console.treasuredata.com/users/sign_up">sign up page</a>. Its free plan lets you store and analyze millions of data points. You can get your account’s API key from the <a href="https://console.treasuredata.com/users/current">users page</a>.</p>
<p>Please prepare the <code>fluentd.conf</code> file with the following information, including your API key.</p>
<pre class="CodeRay">&lt;match td.*.*&gt;
  @type tdlog
  apikey YOUR_API_KEY_HERE

  auto_create_table
  buffer_type file
  buffer_path /home/pi/fluentd/td
&lt;/match&gt;
&lt;source&gt;
  @type http
  port 8888
&lt;/source&gt;
&lt;source&gt;
  @type forward
&lt;/source&gt;
</pre>
<p>Finally, please launch Fluentd via your terminal.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> fluentd -c fluent.conf
</span></pre>
<a name="upload-test"></a><h2>Upload Test</h2>
<p>To test the configuration, just post a JSON message to Fluentd via HTTP.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> curl -X POST -d 'json={"sensor1":3123.13,"sensor2":321.3}' \
</span><span class="function">  http://localhost:8888/td.testdb.raspberrypi
</span></pre>
<table class="note">
<td class="icon"></td>
<td class="content">If you're using Python, you can use Fluentd's <a href="python">python logger</a> library.</td>
</table>
<p>Now, access the databases page to confirm that your data has been uploaded to the cloud properly.</p>
<ul>
<li><a href="https://console.treasuredata.com/databases">Treasure Data: List of Databases</a></li>
</ul>
<p>You can now issue queries against the imported data.</p>
<ul>
<li><a href="https://console.treasuredata.com/query_forms/new">Treasure Data: New Query</a></li>
</ul>
<p>For example, these queries calculate the average sensor1 value and the sum of sensor2 values.</p>
<pre class="CodeRay"><span class="class">SELECT</span> <span class="predefined">AVG</span>(sensor1) <span class="keyword">FROM</span> raspberrypi;
<span class="class">SELECT</span> <span class="predefined">SUM</span>(sensor2) <span class="keyword">FROM</span> raspberrypi;
</pre>
<a name="conclusion"></a><h2>Conclusion</h2>
<p>Raspberry Pi is an ideal platform for prototyping data logger hardware. Fluentd helps Raspberry Pi transfer the collected data to the cloud easily and reliably.</p>
<a name="learn-more"></a><h2>Learn More</h2>
<ul>
<li><a href="architecture">Fluentd Architecture</a></li>
<li><a href="quickstart">Fluentd Get Started</a></li>
</ul>
<div style="text-align:right">
  Last updated: 2016-06-14 11:55:31 UTC
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
