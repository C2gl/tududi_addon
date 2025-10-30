# Home Assistant Add-on: Tududi

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]

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
2. Find "Tududi" in the add-on store and click Install
3. Configure the add-on (see Configuration section below)
4. Start the add-on
5. Access the web UI through the Home Assistant interface or at port 3002

## Configuration

### Basic Configuration

```yaml
port: 3002
tududi_user_email: "your-email@example.com"
tududi_user_password: "your-secure-password"
tududi_session_secret: "your-random-secret-string"
disable_telegram: false
disable_scheduler: false
upload_path: "/app/backend/uploads"
db_file: "/app/backend/db/production.sqlite3"
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
| `upload_path` | No | `/app/backend/uploads` | Path for file uploads |
| `db_file` | No | `/app/backend/db/production.sqlite3` | SQLite database file location |

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

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
