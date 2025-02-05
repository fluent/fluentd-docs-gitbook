# fluent-package v5 vs td-agent v4

Fluentd is written in Ruby for flexibility, with performance-sensitive parts in C. However, some users may have difficulty installing and operating a Ruby daemon.

That is why [Fluentd Project](https://www.fluentd.org/) provides **the stable distribution of Fluentd**, called `fluent-package` (formerly known as `td-agent`). The differences between Fluentd and `fluent-package` can be found [here](https://www.fluentd.org/faqs).

This article explains the difference between `fluent-package` v5 and `td-agent` v4.

{% hint style='danger' %}
The series of td-agent had already reached End of Life (EOL). td-agent should not be newly installed because of no support, no new release and no security updates anymore.
Use fluent-package instead!
{% endhint %}

## Supported Platforms

| Platform | v4\(x86\_64\) | v4\(Arm64\) | v5\(x86\_64\) | v5\(Arm64\) |
| :--- | :---: | :---: | :---: | :---: |
| RedHat/CentOS 7 | ✔ | ✔ | - (\*1) | - (\*1) |
| RedHat/CentOS 8 | ✔ | ✔ | ✔ | ✔ |
| RedHat/CentOS 9 | ✔ | ✔ | ✔ | ✔ |
| Amazon Linux 2 |  ✔ | ✔ | ✔ | ✔ |
| Amazon Linux 2023 | - | - |  ✔ | ✔ |
| Ubuntu Focal | ✔ | ✔ | ✔ | ✔ |
| Ubuntu Jammy | ✔ | ✔ | ✔ | ✔ |
| Ubuntu Noble | - | - | ✔ | ✔ |
| Debian Buster | ✔ | ✔ | - | - |
| Debian Bullseye | ✔ | ✔ | ✔ | ✔ |
| Debian Bookworm | - | - | ✔ | ✔ |
| macOS | ✔ | - | - | - |
| Windows | ✔ | - | ✔ |  - |

\*1: Since v5.0.4, RHEL 7 / CentOS 7 is not supported anymore because CentOS 7 has reached EOL (June, 2024).

## Features

### `fluent-package` v5

New stable. Major feature updates to `fluent-package` v5 are as follows:

* Ruby 3.2
* Fluentd v1.16.2 ~
* Added support for Amazon Linux 2023
* Added support for Debian Bookworm
* Added support for Ubuntu Noble (since v5.0.4)
* Shipped through 2 channels. See [Scheduled support lifecycle announcement about Fluent Package](https://www.fluentd.org/blog/fluent-package-scheduled-lifecycle) for details.
  * Normal release
  * Long Term Support (LTS)
* Added new features:
  * Zero-downtime restart / update
    * [fluent-package v5.2.0 has been released](https://www.fluentd.org/blog/fluent-package-v5.2.0-has-been-released)
    * [Zero-downtime restart](../deployment/zero-downtime-restart.md)
* Fixed some serious bugs:
  * Fixed [in_tail](../input/tail.md) wrongly stopping tailing the current target file and causing handle leaks
    * See [Fluentd v1.16.3 and v1.16.2 have been released](https://www.fluentd.org/blog/fluentd-v1.16.2-v1.16.3-have-been-released) for details.
  * Fixed emit error when handling large data exceeding chunk size limit
    * See [Fluentd v1.16.4 has been released](https://www.fluentd.org/blog/fluentd-v1.16.4-have-been-released) for details.
* Many other improvements and fixes:
    * [Fluent Package v5 CHANGELOG](https://github.com/fluent/fluent-package-builder/blob/master/CHANGELOG.md#fluent-package-5-changelog)
    * [Fluentd CHANGELOG](https://github.com/fluent/fluentd/blob/master/CHANGELOG.md)

See also [Changes from Treasure Agent 4](https://github.com/fluent/fluent-package-builder/blob/master/CHANGELOG.md#release-v500---20230728)

### `td-agent` v4

Old stable. Major feature updates to `td-agent` v4 are as follows:

* Ruby 2.7
* Fluentd v1
* Arm64 Support

See also [Changes from Treasure Agent 3](https://github.com/fluent-plugins-nursery/td-agent-builder#changes-from-treasure-agent-3)

## Conclusion: Use `fluent-package` v5 instead of `td-agent` v4

Please use `fluent-package` v5 instead of `td-agent` v4 because:

* `fluent-package` is the successor to `td-agent` and keeps backward compatibility.
* The series of td-agent had already reached End of Life (EOL).
* Some of the components embedded into td-agent, including Ruby, had already reached EOL.
* td-agent v4 has several known bugs, such as the [in_tail](../input/tail.md) bug.
* `fluent-package` provides the Long Term Support (LTS) channel, making subsequent updates easier.

How to install `fluent-package`:

* [Ubuntu/Debian](../installation/install-fluent-package/install-by-deb-fluent-package.md)
* [RedHat/CentOS](../installation/install-fluent-package/install-by-rpm-fluent-package.md)
* [Windows](../installation/install-fluent-package/install-by-msi-fluent-package.md)
* [RubyGems](../installation/install-by-gem.md)

How to upgrade to `fluent-package`:

* [Upgrade to fluent-package v5](https://www.fluentd.org/blog/upgrade-td-agent-v4-to-v5).

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under under [the Apache License 2.0.](https://www.apache.org/licenses/LICENSE-2.0)

