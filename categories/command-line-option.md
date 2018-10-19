<article>
<div style="text-align:right">
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/command-line-option">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<hgroup>
<h1>Fluentd command line option</h1>
</hgroup>
<p>This article describes built-in commands and its options</p>
<a name="fluentd"></a>
<section id="table-of-contents"><h3>Table of Contents</h3>
<ul id="toc">
<li class="toc-item"><a href="#fluentd">fluentd</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#important-options">Important options</a></li>
<li class="sub-toc-item"><a href="#set-via-configuration-file">Set via configuration file</a></li>
</ul>
<li class="toc-item"><a href="#fluent-cat">fluent-cat</a></li>
<ul class="sub-toc">
<li class="sub-toc-item"><a href="#example">example</a></li>
</ul>
</ul>
</section>
<h2>fluentd</h2>
<p>Invoke fluentd. Here is supported options:</p>
<pre class="CodeRay">Usage: fluentd [options]
    -s, --setup [DIR=/etc/fluent]    install sample configuration file to the directory`
    -c, --config PATH                config file path (default: /etc/fluent/fluent.conf)
        --dry-run                    Check fluentd setup is correct or not
    -p, --plugin DIR                 add plugin directory
    -I PATH                          add library path
    -r NAME                          load library
    -d, --daemon PIDFILE             daemonize fluent process
        --no-supervisor              run without fluent supervisor
        --user USER                  change user
        --group GROUP                change group
    -o, --log PATH                   log file path
    -i CONFIG_STRING,                inline config which is appended to the config file on-fly
        --inline-config
        --emit-error-log-interval SECONDS
                                     suppress interval seconds of emit error logs
        --suppress-repeated-stacktrace [VALUE]
                                     suppress repeated stacktrace
        --without-source             invoke a fluentd without input plugins
        --use-v1-config              Use v1 configuration format (default)
        --use-v0-config              Use v0 configuration format
    -v, --verbose                    increase verbose level (-v: debug, -vv: trace)
    -q, --quiet                      decrease verbose level (-q: warn, -qq: error)
        --suppress-config-dump       suppress config dumping when fluentd starts
    -g, --gemfile GEMFILE            Gemfile path
    -G, --gem-path GEM_INSTALL_PATH  Gemfile install path (default: $(dirname $gemfile)/vendor/bundle)
</pre>
<a name="important-options"></a><h3>Important options</h3>
<h4>–suppress-config-dump</h4>
<p>Fluentd starts without configuration dump. If you don’t want to show configuration in fluentd logs,
e.g. don’t show private keys, this options is useful.</p>
<h4>–suppress-repeated-stacktrace</h4>
<p>If set true, suppress stacktrace in fluentd logs. Since v0.12, this option is true by default.</p>
<h4>–without-source</h4>
<p>Fluentd starts without input plugins. This option is useful for flushing buffers with no new incoming events.</p>
<h4>-i, –inline-config</h4>
<p>If you use fluentd on XaaS which doesn’t support persistent disks, this option is useful.</p>
<h4>–no-supervisor</h4>
<p>If you want to use your supervisor tools, this option avoids double supervisor.</p>
<a name="set-via-configuration-file"></a><h3>Set via configuration file</h3>
<p>Several options could be set via <code>&lt;system&gt;</code> directive configuration file.
See <a href="/articles/config-file#4-set-system-wide-configuration-the-ldquosystemrdquo-directive">configuration file article</a>.</p>
<a name="fluent-cat"></a><h2>fluent-cat</h2>
<p>Send event to fluentd’s <code>in_forward</code>/<code>in_unix</code> plugin. This is useful for testing.</p>
<pre class="CodeRay">Usage: fluent-cat [options] &lt;tag&gt;
    -p, --port PORT                  fluent tcp port (default: 24224)
    -h, --host HOST                  fluent host (default: 127.0.0.1)
    -u, --unix                       use unix socket instead of tcp
    -s, --socket PATH                unix socket path (default: /var/run/fluent/fluent.sock)
    -f, --format FORMAT              input format (default: json)
        --json                       same as: -f json
        --msgpack                    same as: -f msgpack
        --none                       same as: -f none
        --message-key KEY            key field for none format (default: message)
</pre>
<a name="example"></a><h3>example</h3>
<p>Send json message with <code>debug.log</code> tag to local fluentd:</p>
<pre class="CodeRay">% echo '{"message":"hello"}' | fluent-cat debug.log
</pre>
<p>Send to other machine:</p>
<pre class="CodeRay">% echo '{"message":"hello"}' | fluent-cat debug.log --host testserver --port 24225
</pre>
<div style="text-align:right">
  Last updated: 2017-01-25 02:58:15 UTC
  </div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<div style="text-align:right">
Versions 
  
    
    | <a href="/v1.0/articles/command-line-option">v1.0 (td-agent3)</a>
    
  

  

  
    
    | <b><i>v0.12</i> (td-agent2)<b>
</b></b>
</div>
<hr size="1" style="margin-top: 10px; margin-bottom: 10px; color: rgba(0, 0, 0, .15);"/>
<p>
    If this article is incorrect or outdated, or omits critical information, please <a href="https://github.com/fluent/fluentd-docs/issues?state=open">let us know</a>. <a href="http://www.fluentd.org/">Fluentd</a> is a  open source project under <a href="https://cncf.io/">Cloud Native Computing Foundation (CNCF)</a>. All components are available under the Apache 2 License.
  </p>
</article>