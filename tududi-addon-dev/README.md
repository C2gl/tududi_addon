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
tududi_trust_proxy: true
ff_enable_mcp: false
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
| `tududi_trust_proxy` | No | `true` | Trust `X-Forwarded-*` headers from the reverse proxy. Required for HA Ingress. Only disable for advanced non-ingress setups. |
| `ff_enable_mcp` | No | `false` | Enable the Tududi MCP server endpoints (`/api/mcp/*`). Requires an API token generated in the Tududi UI under Profile → API Keys. |
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

### About `tududi_trust_proxy`

Home Assistant Ingress acts as a reverse proxy in front of every addon. Tududi needs to trust the `X-Forwarded-*` headers it adds so that `req.secure` is honored on the request round-trip; without it the secure-flagged session cookie set on login is rejected on the next request and every `/api/*` call returns 401. The toggle defaults to `true` for this reason — only disable it in advanced non-ingress setups where the upstream proxy is not trusted.

### About `ff_enable_mcp`

Tududi ships an optional MCP (Model Context Protocol) server that exposes task and inbox tools over HTTP at `/api/mcp/*`. Because MCP calls are authenticated with a Bearer API token (not your session cookie), you must:

1. Enable `ff_enable_mcp: true` in the addon config.
2. Log into the Tududi web UI, open your profile, go to **API Keys**, and generate a token.
3. Point your MCP client at the ingress URL, passing the token as `Authorization: Bearer <token>`.

The flag matches the upstream `FF_ENABLE_MCP` environment variable and is off by default.

## Backup Support

This add-on supports Home Assistant's built-in backup functionality. The following backup features are enabled:

- **Hot Backup**: The add-on continues running during backups to ensure data consistency
- **Pre-backup Script**: Automatically ensures the database is properly synced before backup
- **Post-backup Script**: Performs cleanup operations after backup completion
- **Exclusions**: Temporary files, logs, and cache files are automatically excluded from backups

The following files/directories are excluded from backups:
- `*.log` files
- `/data/temp/*` directory
- `/data/cache/*` directory

Your Tududi data, including the SQLite database, uploaded files, and configuration, will be included in Home Assistant backups automatically.

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
