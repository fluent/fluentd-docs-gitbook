# fluent-package v5 vs td-agent v4

{% hint style='danger' %}
The series of td-agent had already reached End of Life (EOL). td-agent should not be newly installed because of no support, no new release and no security updates anymore.
Use fluent-package instead!
{% endhint %}

## Supported Platforms

[Fluentd Project](https://www.fluentd.org) maintains stable packages for Fluentd and canonical plugins as Fluent Package \(the package is called `fluent-package`\)
which is formerly known as `td-agent`.

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
* Fluentd v1.16.2
* Added support for Amazon Linux 2023
* Added support for Debian Bookworm
* Shipped through 2 channels. See [Scheduled support lifecycle announcement about Fluent Package](https://www.fluentd.org/blog/fluent-package-scheduled-lifecycle) for details.
  * Normal release
  * Long Term Support (LTS)

See also [Changes from Treasure Agent 4](https://github.com/fluent/fluent-package-builder/blob/master/CHANGELOG.md#release-v500---20230728)

### `td-agent` v4

Old stable. Major feature updates to `td-agent` v4 are as follows:

* Ruby 2.7
* Fluentd v1
* Arm64 Support

See also [Changes from Treasure Agent 3](https://github.com/fluent-plugins-nursery/td-agent-builder#changes-from-treasure-agent-3)

## How to Install

* [Ubuntu/Debian](../installation/install-fluent-package/install-by-deb-fluent-package.md)
* [RedHat/CentOS](../installation/install-fluent-package/install-by-rpm-fluent-package.md)
* [Windows](../installation/install-fluent-package/install-by-msi-fluent-package.md)
* [macOS](../installation/install-fluent-package/install-by-dmg-fluent-package.md)
* [RubyGems](../installation/install-by-gem.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under under [the Apache License 2.0.](https://www.apache.org/licenses/LICENSE-2.0)

