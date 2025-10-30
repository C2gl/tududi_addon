# Tududi Home Assistant Add-on Repository

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

This repository contains the following add-on:

### [Tududi](./tududi)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]

A self-hosted task management application with Telegram integration, scheduling, and file upload capabilities.

## Support

If you have issues with the add-on, please [open an issue on GitHub](https://github.com/C2gl/tududi_addon/issues).

For issues with Tududi itself, please visit the [upstream repository](https://github.com/chrisvel/tududi).

## Credits

This add-on packages the excellent [Tududi](https://github.com/chrisvel/tududi) project created by [@chrisvel](https://github.com/chrisvel).

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg