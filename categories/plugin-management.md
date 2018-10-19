<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/plugin-management">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Plugin Management</h1>
</hgroup>
<p>This article explains how to manage Fluentd plugins, including adding 3rd party plugins.</p>
<a name="fluent-gem"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#fluent-gem">fluent-gem</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#if-using-td-agent,-use-/usr/sbin/td-agent-gem">If Using td-agent, Use /usr/sbin/td-agent-gem</a></li>
<li class="sub-toc-item"><a href="#gem-and-native-extension">Gem and native extension</a></li>
</ul>
<li class="toc-item"><a href="#%E2%80%9C-p%E2%80%9D-option">“-p” option</a></li>
<li class="toc-item"><a href="#add-a-plugin-via-/etc/fluent/plugin">Add a Plugin Via /etc/fluent/plugin</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#if-using-td-agent,-use-/etc/td-agent/plugin">If Using td-agent, Use /etc/td-agent/plugin</a></li>
</ul>
<li class="toc-item"><a href="#plugin-version-management">Plugin version management</a></li>
<li class="toc-item"><a href="#%E2%80%9C%E2%80%93gemfile%E2%80%9D-option">“–gemfile” option</a></li>
</ul>
</section>
<h2>fluent-gem</h2>
<p>The <code>fluent-gem</code> command is used to install Fluentd plugins. This is a wrapper around the <code>gem</code> command.</p>
<pre class="CodeRay"><span class="string">fluent-gem install fluent-plugin-grep
</span></pre>
<table class="note">
<td class="icon"></td>
<td class="content">Ruby doesn't guarantee C extension API compatibility between its major versions. If you update Fluentd's Ruby version, you should re-install the plugins that depend on C extension.</td>
</table>
<a name="if-using-td-agent,-use-/usr/sbin/td-agent-gem"></a><h3>If Using td-agent, Use /usr/sbin/td-agent-gem</h3>
<p>If you are using td-agent, please make sure to use td-agent’s <code>td-agent-gem</code> command. Otherwise (e.g. you use the command belonging to system, rvm, etc.), you won’t be able to find your “installed” plugins.</p>
<p>Please see <a href="/articles/faq#i-installed-td-agent-and-want-to-add-custom-plugins-how-do-i-do-it">this FAQ</a> for more information.</p>
<a name="gem-and-native-extension"></a><h3>Gem and native extension</h3>
<p>Some plugins depend on natvie extension library. It means you need to install development packages to build it, e.g. gcc, make, autoconf and etc.
If you see logs like below, install development packages before plugin installation.</p>
<pre class="CodeRay"><span class="string">Building native extensions.  This could take a while...
</span><span class="string">ERROR:  Error installing fluent-plugin-twitter:
</span><span class="string">        ERROR: Failed to build gem native extension.
</span><span class="string">
</span><span class="string">    /opt/td-agent/embedded/bin/ruby extconf.rb
</span><span class="string">
</span><span class="string">checking for rb_str_scrub()... yes
</span><span class="string">creating Makefile
</span><span class="string">
</span><span class="string">make "DESTDIR = " clean
</span><span class="string">sh: 1: make: not found
</span><span class="string">
</span><span class="string">make "DESTDIR = "
</span><span class="string">sh: 1: make: not found
</span><span class="string">
</span><span class="string">make failed, exit code 127
</span><span class="string">
</span><span class="string">Gem files will remain installed in /opt/td-agent/embedded/lib/ruby/gems/2.1.0/gems/string-scrub-0.0.3 for inspection.
</span><span class="string">Results logged to /opt/td-agent/embedded/lib/ruby/gems/2.1.0/extensions/x86_64-linux/2.1.0/string-scrub-0.0.3/gem_make.out
</span></pre>
<a name="%E2%80%9C-p%E2%80%9D-option"></a><h2>“-p” option</h2>
<p>Fluentd’s <code>-p</code> option is used to add an extra plugin directory to the load path. For example,
if you put the <code>out_foo.rb</code> plugin into <code>/path/to/plugin</code>, you can load the <code>out_foo.rb</code> plugin by specifying the <code>-p</code> option as shown below.</p>
<pre class="CodeRay"><span class="string">fluentd -p /path/to/plugin
</span></pre>
<p>You can specify the <code>-p</code> option more than once.</p>
<a name="add-a-plugin-via-/etc/fluent/plugin"></a><h2>Add a Plugin Via /etc/fluent/plugin</h2>
<p>Fluentd adds the <code>/etc/fluent/plugin</code> directory to its load path by default. Thus, any additional plugins that are placed in <code>/etc/fluent/plugin</code> will be loaded automatically.</p>
<p>For example, if <code>/etc/fluent/plugin/out_foo.rb</code> exists, you can use <code>@type foo</code> in <code>&lt;match&gt;</code>.</p>
<a name="if-using-td-agent,-use-/etc/td-agent/plugin"></a><h3>If Using td-agent, Use /etc/td-agent/plugin</h3>
<p>If you are using td-agent, Fluentd uses the <code>/etc/td-agent/plugin</code> directory instead of <code>/etc/fluent/plugin</code>. Please put your plugins here instead.</p>
<a name="plugin-version-management"></a><h2>Plugin version management</h2>
<p>Fluentd and plugins are evolving, so you may hit unexpected error with latest version, e.g. regression by new feature, removed deprecated parameter,, change library dependency, etc.
Avoiding these problems, we recommend to fix fluentd and plugin version on production. If you want to update fluentd or plugins, check the behaviour first on your test environment.
For example, td-agent fixes fluentd and plugins version in each release.</p>
<p>Fluentd plugins are rubygems and rubygems installs latest version by default. So we don’t recommend to execute following commands on production:</p>
<ul>
<li><code>gem install fluentd</code></li>
<li><code>gem install fluent-plugin-elasticsearch</code></li>
<li><code>gem update # This is very dangerous. Update all existing gems</code></li>
</ul>
<p>Another problem: if you install the plugin which depends on fluentd v0.14, <code>gem</code> installs fluentd v0.14 together even if you installed fluentd v0.12.
This is unexpected result for fluentd v0.12 users.</p>
<p>You should specify target version with <code>-v</code> option.</p>
<ul>
<li><code>gem install fluentd -v 0.12.43</code></li>
<li><code>gem install fluent-plugin-elasticsearch -v 1.9.3</code></li>
</ul>
<p><code>/usr/sbin/td-agent-gem</code> is also same because <code>/usr/sbin/td-agent-gem</code> uses <code>gem</code> command internally.</p>
<a name="%E2%80%9C%E2%80%93gemfile%E2%80%9D-option"></a><h2>“–gemfile” option</h2>
<p>A Ruby application manages gem dependencies using Gemfile and <a href="http://bundler.io/">Bundler</a>. Fluentd’s <code>--gemfile</code> option takes the same approach, and is useful for managing plugin versions separated from shared gems.</p>
<p>For example, if you have following Gemfile at /etc/fluent/Gemfile:</p>
<pre class="CodeRay">source 'https://rubygems.org'

gem 'fluentd', '0.12.43'
gem 'fluent-plugin-elasticsearch', '1.9.3'
</pre>
<p>You can pass this Gemfile to Fluentd via the <code>--gemfile</code> option.</p>
<pre class="CodeRay"><span class="string">fluentd --gemfile /etc/fluent/Gemfile
</span></pre>
<p>When specifying the <code>--gemfile</code> option, Fluentd will try to install the listed gems using Bundler.
Fluentd will only load listed gems separated from shared gems, and will also prevent unexpected plugin updates.</p>
<p>In addition, if you update Fluentd’s Ruby version, Bundler will re-install the listed gems for the new Ruby version.
This allows you to avoid the C extension API compatibility problem.</p>
<div style="text-align:right">
  Last updated: 2017-04-17 12:58:47 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/plugin-management">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>