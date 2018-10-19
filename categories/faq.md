<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/faq">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>FAQ</h1>
</hgroup>
<a name="what-version-of-ruby-does-fluentd-support?"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#what-version-of-ruby-does-fluentd-support?">What version of Ruby does fluentd support?</a></li>
<li class="toc-item"><a href="#known-issue">Known Issue</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#i-use-fluentd-with-ruby-2.0-but-fluentd-seems-deadlocked.-why?">I use Fluentd with Ruby 2.0 but Fluentd seems deadlocked. Why?</a></li>
</ul>
<li class="toc-item"><a href="#operations">Operations</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#i-have-millisecond-timestamp-log-but-fluentd-drops-subsecond.-why?">I have millisecond timestamp log but fluentd drops subsecond. Why?</a></li>
<li class="sub-toc-item"><a href="#i-have-a-weird-timestamp-value,-what-happened?">I have a weird timestamp value, what happened?</a></li>
<li class="sub-toc-item"><a href="#i-installed-td-agent-and-want-to-add-custom-plugins.-how-do-i-do-it?">I installed td-agent and want to add custom plugins. How do I do it?</a></li>
<li class="sub-toc-item"><a href="#i-installed-the-plugin-and-it-updates-fluentd-from-v0.12-to-v1.x.-why?">I installed the plugin and it updates fluentd from v0.12 to v1.x. Why?</a></li>
<li class="sub-toc-item"><a href="#how-can-i-match-(send)-an-event-to-multiple-outputs?">How can I match (send) an event to multiple outputs?</a></li>
<li class="sub-toc-item"><a href="#how-can-i-use-environment-variables-to-configure-parameters-dynamically?">How can I use environment variables to configure parameters dynamically?</a></li>
<li class="sub-toc-item"><a href="#fluentd-raises-an-error-for-host:port.-why?">Fluentd raises an error for host:port. Why?</a></li>
<li class="sub-toc-item"><a href="#i-got-%E2%80%9Cno-patterns-matched%E2%80%9D-in-the-log,-why?">I got “no patterns matched” in the log, why?</a></li>
<li class="sub-toc-item"><a href="#file-buffer-doesn%E2%80%99t-work-properly,-why?">File buffer doesn’t work properly, why?</a></li>
<li class="sub-toc-item"><a href="#i-got-enconding-error-inside-plugin.-how-to-fix-it?">I got enconding error inside plugin. How to fix it?</a></li>
</ul>
<li class="toc-item"><a href="#plugin-development">Plugin Development</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#how-do-i-develop-a-custom-plugin?">How do I develop a custom plugin?</a></li>
</ul>
<li class="toc-item"><a href="#howtos">HOWTOs</a></li>
</ul>
</section>
<h2>What version of Ruby does fluentd support?</h2>
<p>Fluentd v0.12 works on 1.9.3 or later. Since v1.x, 2.1 or later.</p>
<a name="known-issue"></a><h2>Known Issue</h2>
<a name="i-use-fluentd-with-ruby-2.0-but-fluentd-seems-deadlocked.-why?"></a><h3>I use Fluentd with Ruby 2.0 but Fluentd seems deadlocked. Why?</h3>
<p>The rubygems of Ruby 2.0-p353 has a deadlock problem (<a href="https://bugs.ruby-lang.org/issues/9224">#9224</a>).
If you use Ruby 2.0-p353, upgrading Ruby to latest patch level or Ruby 2.1 resolve this problem.</p>
<p>Please make sure that you are using either RHEL 7.1 and ruby-2.0.0.598-25.el7_1 package or alternatively you can choose more recent Ruby provided by Red Hat Software Collections (https://access.redhat.com/documentation/en/red-hat-software-collections/)</p>
<p>Unfortunately, Ruby 2.0 package of Ubuntu 14.04 use Ruby 2.0-p353. So don’t use Fluentd with Ruby 2.0 package on this environment.
You can install specified Ruby version using <a href="https://github.com/sstephenson/rbenv">rbenv</a>.</p>
<p>Using td-agent is another way to avoid this problem because td-agent includes own Ruby.</p>
<a name="operations"></a><h2>Operations</h2>
<a name="i-have-millisecond-timestamp-log-but-fluentd-drops-subsecond.-why?"></a><h3>I have millisecond timestamp log but fluentd drops subsecond. Why?</h3>
<p>In v0.12 or earlier, fluentd’s event time is second unit. It means fluentd converts millisecond/nanosecond timestamp into second timestamp.</p>
<p>Since v1.x, event tims has nanosecond resolution, so fluentd can handle millisecond/nanosecond timestamp properly.</p>
<p>Visit <a href="https://docs.fluentd.org/v1.0/articles/quickstart">v1.x document</a></p>
<a name="i-have-a-weird-timestamp-value,-what-happened?"></a><h3>I have a weird timestamp value, what happened?</h3>
<p>The timestamps of Fluentd and its logger libraries depend on your system’s clock. It’s highly recommended that you set up NTP on your nodes so that your clocks remain synced with the correct clocks.</p>
<a name="i-installed-td-agent-and-want-to-add-custom-plugins.-how-do-i-do-it?"></a><h3>I installed td-agent and want to add custom plugins. How do I do it?</h3>
<p>td-agent has own Ruby so you should install gems into td-agent’s Ruby, not system Ruby.</p>
<h4>td-agent:</h4>
<p>Please use <code>td-agent-gem</code> as shown below.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> /usr/sbin/td-agent-gem install &lt;plugin name&gt;
</span></pre>
<p>For example, issue the following command if you are adding <code>fluent-plugin-twitter</code>.</p>
<pre class="CodeRay"><span class="comment">$</span><span class="function"> /usr/sbin/td-agent-gem install fluent-plugin-twitter
</span></pre>
<p>Now you might be wondering, “Why do I need to specify the full path?” The reason is that td-agent does not modify any host environment variable, including <code>PATH</code>. If you want to make all td-agent/fluentd related programs available without writing “/usr/lib/…” every time, you can add</p>
<pre class="CodeRay">export PATH=$PATH:/opt/td-agent/embedded/bin/
</pre>
<p>to your <code>~/.bash_profile</code>.</p>
<p>If you would like to find out more about plugin management, please take a look at the <a href="/articles/plugin-management">Plugin Management</a> article.</p>
<a name="i-installed-the-plugin-and-it-updates-fluentd-from-v0.12-to-v1.x.-why?"></a><h3>I installed the plugin and it updates fluentd from v0.12 to v1.x. Why?</h3>
<p>You installed v1.0 based plugin. See <a href="/articles/plugin-management#plugin-version-management">Plugin Management</a>.</p>
<a name="how-can-i-match-(send)-an-event-to-multiple-outputs?"></a><h3>How can I match (send) an event to multiple outputs?</h3>
<p>You can use the <code>copy</code> <a href="/articles/out_copy">output plugin</a> to send the same event to multiple output destinations.</p>
<a name="how-can-i-use-environment-variables-to-configure-parameters-dynamically?"></a><h3>How can I use environment variables to configure parameters dynamically?</h3>
<p>Use <code>"#{ENV['YOUR_ENV_VARIABLE']}"</code>. For example,</p>
<pre class="CodeRay">some_field "#{ENV['FOO_HOME']}"
</pre>
<p>Note that it must be double quotes and not single quotes</p>
<a name="fluentd-raises-an-error-for-host:port.-why?"></a><h3>Fluentd raises an error for host:port. Why?</h3>
<p>There are several reasons:</p>
<ul>
<li>If you get <code>Address already in use</code> error, other process has already used <code>host:port</code>. Check port conflict between processes / plugins.</li>
<li>If you get <code>Permission denied</code> error, you try to use well-known port. Search <code>well-known port</code> for how to use well-known port. Use <code>capabilities</code> or something</li>
</ul>
<p>If you get other errors, google it.</p>
<a name="i-got-%E2%80%9Cno-patterns-matched%E2%80%9D-in-the-log,-why?"></a><h3>I got “no patterns matched” in the log, why?</h3>
<p>This means you emit the event but no <code>&lt;match&gt;</code> directive for emitted event. For example, if you emit the event with <code>foo.bar</code> tag, you need to define <code>&lt;match&gt;</code> for <code>foo.bar</code> tag like <code>&lt;match foo.**&gt;</code>.</p>
<p>See also: <a href="life-of-a-fluentd-event">Life of a Fluentd event</a> or <a href="config-file">Config File</a></p>
<a name="file-buffer-doesn%E2%80%99t-work-properly,-why?"></a><h3>File buffer doesn’t work properly, why?</h3>
<p><code>file</code> buffer has limitations. Check <a href="buf_file#limitation"><code>buf_file</code> article</a>.</p>
<a name="i-got-enconding-error-inside-plugin.-how-to-fix-it?"></a><h3>I got enconding error inside plugin. How to fix it?</h3>
<p>You may hit <code>"\xC3" from ASCII-8BIT to UTF-8"</code> like <code>UndefinedConversionError</code> in the plugin.
This error happens when string encoding is set to <code>ASCII-8BIT</code> but actual content is <code>UTF-8</code>.
Fluentd and almost plugins treat the logs as a <code>ASCII-8BIT</code> by default but
some libraries assume the log encoding is <code>UTF-8</code>. This is why this error happens.</p>
<p>There are several approaches to avoid this problem.</p>
<ul>
<li>Set encoding correctly.

<ul>
<li>
<code>tail</code> input has encoding related parameters to change the log encoding</li>
<li>Use <code>record_modifier</code> filter to change the encoding. See <a href="https://github.com/repeatedly/fluent-plugin-record-modifier#char_encoding">fluent-plugin-record-modifier README</a>
</li>
</ul>
</li>
<li>Use <code>yajl</code> instead of <code>json</code> when error happens inside <code>JSON.parse/JSON.dump</code>
</li>
</ul>
<a name="plugin-development"></a><h2>Plugin Development</h2>
<a name="how-do-i-develop-a-custom-plugin?"></a><h3>How do I develop a custom plugin?</h3>
<p>Please refer to the <a href="http://docs.fluentd.org/articles/plugin-development">Plugin Development Guide</a>.</p>
<a name="howtos"></a><h2>HOWTOs</h2>
<h3>How can I parse <code>&lt;my complex text log&gt;</code>?</h3>
<p>If you are willing to write Regexp, <a href="/articles/fluentd-ui#intail-setting">fluentd-ui’s in_tail editor</a> or <a href="http://fluentular.herokuapp.com">Fluentular</a> is a great tool to verify your Regexps.</p>
<p>If you do NOT want to write any Regexp, look at <a href="https://github.com/kiyoto/fluent-plugin-grok-parser">the Grok parser</a>.</p>
<div style="text-align:right">
  Last updated: 2016-12-12 09:43:19 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/faq">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>