# Installing Fluentd using .msi Installer (Windows)

This article explains how to install td-agent, the stable Fluentd
distribution package maintained by [Treasure Data, Inc](http://www.treasuredata.com/), on Windows.


## What is td-agent?

Fluentd is written in Ruby for flexibility, with performance sensitive
parts written in C. However, casual users may have difficulty installing
and operating a Ruby daemon.

That's why [Treasure Data, Inc](http://www.treasuredata.com/) is
providing **the stable distribution of Fluentd**, called `td-agent`. The
differences between Fluentd and td-agent can be found
[here](http://www.fluentd.org/faqs).

For Windows, we're using the OS native .msi Installer to distribute
td-agent.

* [Td Agent 4 (fluentd 1.11.x)](#td-agent-4)
* [Td Agent 3 (fluentd 1.10.x)](#td-agent-3)

## Td Agent 4

### Step 1: Install td-agent

Please download the `.msi` file from here, and install the software.

-   [Download](https://td-agent-package-browser.herokuapp.com/4/windows)


### Step 2: Run td-agent from Command Prompt

First, please prepare your config file located at
`C:/opt/td-agent/etc/td-agent/td-agent.conf`. The config below is the
simplest example to output any incoming records to td-agent's log file.

```
<source>
  @type forward
</source>
<match test.**>
  @type stdout
</match>
```

After you've installed .msi package, you'll see the program called
`Td-agent Command Prompt` installed. Please double click this icon in
the Windows menu (below is how it looks like on Windows Server 2012).

![](/images/msi-td-agent-command-prompt.png)

In the prompt, please execute the command below to launch td-agent
process.

```
> fluentd -c etc\td-agent\td-agent.conf
```

Then, please launch another `Td-agent Command Prompt` and type the
command below. This will send a record to td-agent process.

```
> echo {"message":"hello"} | fluent-cat test.event
```

It's working properly if td-agent process outputs the message
`test.event: {"k", "v"}`.

[![](/images/td-agent-windows-prompt.png)](/images/td-agent-windows-prompt.png)


### Step 3: Run td-agent as Windows service

Since version 4.0.0, Td-agent is registered as Windows service
permanently by msi installer.
You can start Td-agent service by manually.

#### Using GUI

Please guide yourself to
`Control Panel -> System and Security -> Administrative Tools -> Services`,
and you'll see `Fluentd Windows Service` is listed.

Please double click `Fluentd Window Service`, and click `Start` button.
Then the process will be executed as Windows Service.

#### Using net.exe

```
> net start fluentdwinsvc
The Fluentd Windows Service service is starting..
The Fluentd Windows Service service was started successfully.
```

#### Using Powershell Cmdlet

```
PS> Start-Service fluentdwinsvc
```

Note that using `fluentdwinsvc` is needed to start Fluentd service in commandline.
Because `fluentdwinsvc` is service name and it should be passed in `net.exe` or `Start-Service` Cmdlet.

The log file will be located at `C:/opt/td-agent/td-agent.log` as we
specified in Step 3.


### Step 4: Install Plugins

Open `Td-agent Command Prompt` and use `fluent-gem` command.

```
> fluent-gem install fluent-plugin-xyz --version=1.2.3
```

## Td Agent 3


### Step 1: Install td-agent

Please download the `.msi` file from here, and install the software.

-   [Download](https://td-agent-package-browser.herokuapp.com/3/windows)


### Step 2: Run td-agent from Command Prompt

First, please prepare your config file located at
`C:/opt/td-agent/etc/td-agent/td-agent.conf`. The config below is the
simplest example to output any incoming records to td-agent's log file.

```
<source>
  @type forward
</source>
<match test.**>
  @type stdout
</match>
```

After you've installed .msi package, you'll see the program called
`Td-agent Command Prompt` installed. Please double click this icon in
the Windows menu (below is how it looks like on Windows Server 2012).

![](/images/msi-td-agent-command-prompt.png)

In the prompt, please execute the command below to launch td-agent
process.

```
> fluentd -c etc\td-agent\td-agent.conf
```

Then, please launch another `Td-agent Command Prompt` and type the
command below. This will send a record to td-agent process.

```
> echo {"message":"hello"} | fluent-cat test.event
```

It's working properly if td-agent process outputs the message
`test.event: {"k", "v"}`.

[![](/images/td-agent-windows-prompt.png)](/images/td-agent-windows-prompt.png)

### Step 3: Register td-agent to Windows service

Next, let's register td-agent to Windows service to permanently run as a
server process. Please execute `Td-agent Command Prompt` again but with
administrative privilege, and type the two commands below.

```
> fluentd --reg-winsvc i
> fluentd --reg-winsvc-fluentdopt '-c C:/opt/td-agent/etc/td-agent/td-agent.conf -o C:/opt/td-agent/td-agent.log'
```

**NOTE**: Making td-agent service start automatically requires additional
commandline parameters:

```
> fluentd --reg-winsvc i --reg-winsvc-auto-start --reg-winsvc-delay-start
> fluentd --reg-winsvc-fluentdopt '-c C:/opt/td-agent/etc/td-agent/td-agent.conf -o C:/opt/td-agent/td-agent.log'
```

### Step 4: Run td-agent as Windows service

#### Using GUI

Please guide yourself to
`Control Panel -> System and Security -> Administrative Tools -> Services`,
and you'll see `Fluentd Windows Service` is listed.

Please double click `Fluentd Window Service`, and click `Start` button.
Then the process will be executed as Windows Service.

#### Using net.exe

```
> net start fluentdwinsvc
The Fluentd Windows Service service is starting..
The Fluentd Windows Service service was started successfully.
```

#### Using Powershell Cmdlet

```
PS> Start-Service fluentdwinsvc
```

Note that using `fluentdwinsvc` is needed to start Fluentd service in commandline.
Because `fluentdwinsvc` is service name and it should be passed in `net.exe` or `Start-Service` Cmdlet.

The log file will be located at `C:/opt/td-agent/td-agent.log` as we
specified in Step 3.

### Step 4: Install Plugins

Open `Td-agent Command Prompt` and use `fluent-gem` command.

```
> fluent-gem install fluent-plugin-xyz --version=1.2.3
```

## Next Steps

You're now ready to collect your real logs using Fluentd. Please see the
following tutorials to learn how to collect your data from various data
sources.

-   Basic Configuration
    -   [Config File](/configuration/config-file.md)
-   Application Logs
    -   [Ruby](/language/ruby.md), [Java](/language/java.md), [Python](/language/python.md), [PHP](/language/php.md),
        [Perl](/language/perl.md), [Node.js](/language/nodejs.md), [Scala](/language/scala.md)
-   Examples
    -   [Store Apache Log into Amazon S3](/guides/apache-to-s3.md)
    -   [Store Apache Log into MongoDB](/guides/apache-to-mongodb.md)
    -   [Data Collection into HDFS](/guides/http-to-hdfs.md)

Please refer to the resources below for further steps.

-   [ChangeLog of td-agent](http://docs.treasuredata.com/articles/td-agent-changelog)
-   [Chef Cookbook](https://github.com/treasure-data/chef-td-agent/)


------------------------------------------------------------------------

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open).
[Fluentd](http://www.fluentd.org/) is a open source project under [Cloud Native Computing Foundation (CNCF)](https://cncf.io/). All components are available under the Apache 2 License.
