# Install `calyptia-fluentd` by .msi Installer \(Windows\)

## What is `calyptia-fluentd`?

`calyptia-fluentd` is the alternative distribution of Fluentd.

* Includes Ruby and other library dependencies \(since most Windows box are not installed\).
* Includes a set of frequently-used 3rd party plugins such as `out_elasticsearch` and `in_windows_eventlog2`.
* This alternative agent is developed by [Chronosphere](https://chronosphere.io) after its acuisition of Calyptia.

Currently, calyptia-fluentd is on v1 only.

* `calyptia-fluentd` v1 packages Fluentd 1.12.x \(or later\).

## How to install `calyptia-fluentd` v1

### Step 1: Install `calyptia-fluentd`

Download the latest MSI installer from [the download page](https://calyptia-fluentd.s3.us-east-2.amazonaws.com/index.html?prefix=1/windows/). Run the installer and follow the wizard.

![calyptia-fluentd installation wizard](../.gitbook/assets/calyptia-fluentd1-wizard.png)

**Note:** Calyptia-Fluentd is a drop-in-replacement agent of other Fluentd stable distribution. Currently, we use the same Windows Service name which is `fluentdwinsvc`. This is because when you already installed other agent which register Windows Service as `fluentdwinsvc`, you must uninstall already installed Windows Service which uses `fluentdwinsvc` as service name.

### Step 2: Set up `calyptia-fluentd.conf`

Open `C:/opt/calyptia-fluentd/etc/calyptia-fluentd/calyptia-fluentd.conf` with a text editor. Replace the configuration with the following content:

```text
<source>
  @type windows_eventlog2
  @id windows_eventlog2
  channels application
  read_existing_events false
  tag winevt.raw
  rate_limit 200
  <storage>
    @type local
    persistent true
    path C:\opt\td-agent\winlog.json
  </storage>
</source>

<match winevt.raw>
  @type stdout
</match>
```

### Step 3: Launch Calyptia-Fluentd Command Prompt

Open Windows Start menu, and search `Calyptia-fluentd Command Prompt`. In most environments, the program will be found right under the "Recently Added" section.

`Calyptia-fluentd Command Prompt` is basically `cmd.exe`, with a few PATH tweaks for `calyptia-fluentd` programs. Use this program whenever you need to interact with `calyptia-fluentd`.

### Step 4: Run `calyptia-fluentd`

Type the following command into `Calyptia-fluentd Command Prompt`:

```text
C:\opt\calyptia-fluentd> calyptia-fluentd
```

Now `calyptia-fluentd` starts listening to Windows Eventlog, and will print records to stdout after consuming Windows EventLog Events on Application channel.

### Step 5: Run `calyptia-fluentd` as Windows service

As of first released version, `calyptia-fluentd` will register as a Windows service as `fluentdwinsvc` by the msi installer. Also, You can manage `calyptia-fluentd` service manually.

#### Using GUI

Please guide yourself to `Control Panel -> System and Security -> Administrative Tools -> Services`, and you'll see `Fluentd Windows Service` is listed.

Please double click `Fluentd Window Service`, and click `Start` button. Then the process will be executed as Windows Service.

#### Using `net.exe`

```text
> net start fluentdwinsvc
The Fluentd Windows Service service is starting..
The Fluentd Windows Service service was started successfully.
```

#### Using Powershell Cmdlet

```text
PS> Start-Service fluentdwinsvc
```

Note that using `fluentdwinsvc` is needed to start Fluentd service from the command-line. `fluentdwinsvc` is the service name and it should be passed to `net.exe` or `Start-Service` Cmdlet.

The log file will be located at `C:/opt/calyptia-fluentd/calyptia-fleuntd.log` as we specified in Step 3.

### Step 6: Install Plugins

Open `Calyptia-fluentd Command Prompt` and use `calyptia-fluentd-gem` command as Administrator:

```text
C:\opt\calyptia-fluentd> calyptia-fluentd-gem install fluent-plugin-xyz --version=1.2.3
```

## Next Steps

You are now ready to collect real logs with Fluentd. Refer to the following tutorials on how to collect data from various sources:

* Basic Configuration
  * [Config File](../configuration/config-file.md)
* Application Logs
  * [Ruby](../language-bindings/ruby.md)
  * [Java](../language-bindings/java.md)
  * [Python](../language-bindings/python.md)
  * [PHP](../language-bindings/php.md)
  * [Perl](../language-bindings/perl.md)
  * [Node.js](../language-bindings/nodejs.md)
  * [Scala](../language-bindings/scala.md)
* Examples
  * [Store Apache Log into Amazon S3](../how-to-guides/apache-to-s3.md)
  * [Store Apache Log into MongoDB](../how-to-guides/apache-to-mongodb.md)
  * [Data Collection into HDFS](../how-to-guides/http-to-hdfs.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under the Apache 2 License.
