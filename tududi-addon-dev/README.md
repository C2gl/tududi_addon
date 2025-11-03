# Home Assistant Add-on: Tududi (Development)

![Supports amd64 Architecture][amd64-shield]
![Supports aarch64 Architecture][aarch64-shield]

> [!WARNING]
> **⚠️ DEVELOPMENT VERSION - USE AT YOUR OWN RISK ⚠️**
> 
> This is the development version of Tududi with the latest features and bug fixes.
> It may be unstable and is intended for testing purposes only.
> 
> For production use, install the stable "Tududi" add-on instead.

## About

This add-on packages the [Tududi](https://github.com/chrisvel/tududi) task management application as a Home Assistant add-on.

Tududi is a self-hosted task management application with features like:
- Task creation and management
- Telegram bot integration
- Scheduling capabilities
- File uploads
- SQLite database

## Installation

1. Add this repository to your Home Assistant add-on store:
   ```
   https://github.com/C2gl/tududi_addon
   ```
2. Find "Tududi (Development)" in the add-on store and click Install
3. **IMPORTANT:** Configure the add-on before starting (see Configuration section below)
   - You must set `tududi_user_email`, `tududi_user_password`, and `tududi_session_secret`
4. Start the add-on manually after configuration is complete
5. Access the web UI through the Home Assistant interface or at port 3002

**Note:** Start on boot is disabled by default. Only enable it after you've verified the add-on works with your configuration.

## Configuration

### Basic Configuration

```yaml
port: 3002
tududi_user_email: "your-email@example.com"
tududi_user_password: "your-secure-password"
tududi_session_secret: "your-random-secret-string"
disable_telegram: false
disable_scheduler: false
upload_path: "/data/uploads"
db_file: "/data/production.sqlite3"
```

### Configuration Options

| Option | Required | Default | Description |
|--------|----------|---------|-------------|
| `port` | No | `3002` | Port for the web interface |
| `tududi_user_email` | Yes* | - | Email for the default admin user |
| `tududi_user_password` | Yes* | - | Password for the default admin user |
| `tududi_session_secret` | Yes* | - | Secret key for session encryption |
| `disable_telegram` | No | `false` | Disable Telegram integration |
| `disable_scheduler` | No | `false` | Disable the task scheduler |
| `upload_path` | No | `/data/uploads` | Path for file uploads |
| `db_file` | No | `/data/production.sqlite3` | SQLite database file location |

*Required for first-time setup

### Generating a Session Secret

You can generate a secure session secret using:
```bash
openssl rand -hex 32
```

## Support

For issues with this add-on, please open an issue on the [GitHub repository](https://github.com/C2gl/tududi_addon).

For issues with Tududi itself, please refer to the [upstream project](https://github.com/chrisvel/tududi).

## Credits

This add-on packages the excellent [Tududi](https://github.com/chrisvel/tududi) project by [@chrisvel](https://github.com/chrisvel).

## License

This add-on is licensed under the MIT License - see the [LICENSE](../LICENSE) file in the repository root.

This add-on packages [Tududi](https://github.com/chrisvel/tududi), which is also licensed under the MIT License. See [THIRD_PARTY_LICENSES.md](../THIRD_PARTY_LICENSES.md) for the complete Tududi license and attribution.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
