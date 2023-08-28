# fluent-package v5 vs td-agent v4

## Supported Platforms

[Fluentd Project](https://www.fluentd.org) maintains stable packages for Fluentd and canonical plugins as Fluent Package \(the package is called `fluent-package`\)
which is formerly known as `td-agent`.

| Platform | v4\(x86\_64\) | v4\(Arm64\) | v5\(x86\_64\) | v5\(Arm64\) |
| :--- | :---: | :---: | :---: | :---: |
| RedHat/CentOS 7 | ✔ | ✔ | ✔ | ✔ |
| RedHat/CentOS 8 | ✔ | ✔ | ✔ | ✔ |
| RedHat/CentOS 9 | ✔ | ✔ | ✔ | ✔ |
| Amazon Linux 2 |  ✔ | ✔ | ✔ | ✔ |
| Amazon Linux 2023 | - | - |  ✔ | ✔ |
| Ubuntu Focal | ✔ | ✔ | ✔ | ✔ |
| Ubuntu Jammy | ✔ | ✔ | ✔ | ✔ |
| Debian Buster | ✔ | ✔ | - | - |
| Debian Bullseye | ✔ | ✔ | ✔ | ✔ |
| Debian Bookworm | - | - | ✔ | ✔ |
| macOS | ✔ | - | ✔ | - |
| Windows | ✔ | - | ✔ |  - |

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

* [Ubuntu/Debian](../installation/install-by-deb.md)
* [RedHat/CentOS](../installation/install-by-rpm.md)
* [Windows](../installation/install-by-msi.md)
* [macOS](../installation/install-by-dmg.md)
* [RubyGems](../installation/install-by-gem.md)

If this article is incorrect or outdated, or omits critical information, please [let us know](https://github.com/fluent/fluentd-docs-gitbook/issues?state=open). [Fluentd](http://www.fluentd.org/) is an open-source project under [Cloud Native Computing Foundation \(CNCF\)](https://cncf.io/). All components are available under under [the Apache License 2.0.](https://www.apache.org/licenses/LICENSE-2.0)

