[![GitHub Tag](https://img.shields.io/github/v/tag/c2gl/tududi_addon?style=flat&logo=github&label=version)](https://github.com/c2gl/tududi_addon/pkgs/container/tududi-addon)
[![GHCR](https://img.shields.io/badge/ghcr.io-c2gl%2Ftududi--addon-blue?style=flat&logo=docker)](https://github.com/c2gl/tududi_addon/pkgs/container/tududi-addon)
[![GitHub issues](https://img.shields.io/github/issues/c2gl/tududi_addon.svg)](https://github.com/c2gl/tududi_addon/issues)
[![GitHub pull requests](https://img.shields.io/github/issues-pr/c2gl/tududi_addon.svg)](https://github.com/c2gl/tududi_addon/pulls)

# Tududi Home Assistant Add-on Repository

> [!CAUTION]
> **⚠️ DO NOT USE IN PRODUCTION - UNDER ACTIVE DEVELOPMENT ⚠️**
> 
> This add-on is currently in early development and is **NOT READY FOR USE**.
> 
> **Known Issues:**
> - May cause Home Assistant to crash
> - Configuration is unstable and incomplete
> - Critical bugs are expected
> - Data loss may/will occur
> 
> **DO NOT install this add-on unless you are actively developing it.**
> 
> This warning will be removed once the add-on reaches a stable state.

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FC2gl%2Ftududi_addon)

## About

This repository provides a Home Assistant add-on for [Tududi](https://github.com/chrisvel/tududi), a self-hosted task management application.

Related projects:
- [Tududi](https://github.com/chrisvel/tududi) - The upstream Tududi project
- [Tududi Integration](https://github.com/c2gl/tududi_integration) - Home Assistant integration for Tududi

## Installation

1. Click the button above or manually add this repository to your Home Assistant instance:
   - Go to **Settings** → **Add-ons** → **Add-on Store** → **⋮** (three dots menu) → **Repositories**
   - Add: `https://github.com/C2gl/tududi_addon`
2. Find "Tududi" in the add-on store
3. Click **Install**
4. Configure the add-on with your credentials
5. Start the add-on

## Add-ons

This repository contains the following add-ons:

### [Tududi](./tududi)

![Supports amd64 Architecture][amd64-shield]
![Supports aarch64 Architecture][aarch64-shield]

A self-hosted task management application with Telegram integration, scheduling, and file upload capabilities.

**Stable version** - Recommended for production use.

### [Tududi (Development)](./tududi-dev)

![Supports amd64 Architecture][amd64-shield]
![Supports aarch64 Architecture][aarch64-shield]

Development version of Tududi with the latest features and bug fixes.

**⚠️ Development version** - May be unstable, for testing only!

## Support

If you have issues with the add-on, please [open an issue on GitHub](https://github.com/C2gl/tududi_addon/issues).

For issues with Tududi itself, please visit the [upstream repository](https://github.com/chrisvel/tududi).

### Contributing Translations

Want to help translate this add-on to your language? Here's how:

1. Navigate to the `translations` folder in `tududi-addon`
2. Copy the `en.yaml` file and rename it to your language code (e.g., `de.yaml` for German, `es.yaml` for Spanish)
3. Translate the text values in your new file (keep the keys unchanged)
4. Submit a pull request with the `translation` label

Your contributions help make this add-on accessible to more users!

## Credits

This add-on packages the excellent [Tududi](https://github.com/chrisvel/tududi) project created by [@chrisvel](https://github.com/chrisvel).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

This add-on packages [Tududi](https://github.com/chrisvel/tududi), which is also licensed under the MIT License. See [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md) for the complete Tududi license and attribution.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg