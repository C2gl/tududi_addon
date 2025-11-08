# Tududi Add-on Installation Guide

This guide will walk you through installing and setting up the Tududi Home Assistant Add-on.

## Prerequisites

Before installing, ensure you have:

- **Home Assistant OS**, **Home Assistant Supervised**, or **Home Assistant Container**
- **Administrator access** to Home Assistant
- **Add-on store access** (not available in Home Assistant Core)
- **Basic familiarity** with Home Assistant add-ons

## Step 1: Add the Repository

1. **Open Home Assistant** in your web browser
2. **Navigate to Settings** → **Add-ons** → **Add-on Store**
3. **Click the menu button** (⋮) in the top-right corner
4. **Select "Repositories"**
5. **Add the repository URL**:
   ```
   https://github.com/C2gl/tududi_addon
   ```
6. **Click "Add"** and wait for the repository to load

## Step 2: Choose Your Version

### Stable Version (Recommended for Production)

**For most users, choose the stable version:**
This version is the most straight forward version. If you are doubting what version you need, it probably means you should be choosing this one.

1. **Find "Tududi"** in the add-on store
2. **Click on it** to view details
3. **Click "Install"**
4. **Wait for installation** to complete

### Development Version (For Testing)

**Only install if you want to test the latest features:**
And also expect very broken releases. If you do install this version *-Kudos to you-*, but do not expect something stable nor functional.

1. **Find "Tududi (Development)"** in the add-on store
2. **Click on it** to view details
3. **Read the warning** about instability
4. **Click "Install"** if you still want to proceed

> ⚠️ **Warning**: The development version will be unstable and is intended for testing only.

## Step 3: Initial Configuration

**IMPORTANT**: You must configure the add-on before starting it for the first time.

### Required Settings

1. **Click on the installed add-on**
2. **Go to the "Configuration" tab**
3. **Fill in the required fields**:

```yaml
tududi_user_email: "your-email@example.com"
tududi_user_password: "your-secure-password"
tududi_session_secret: "your-32-character-random-string"
```

### Generate a Session Secret

The session secret should be a random 32-character string. You can generate one using:

**Option 1: Online Generator**
- Visit a random string generator website
- Generate a 32-character alphanumeric string

**Option 2: Command Line** (if available)
```bash
openssl rand -hex 32
```

**Option 3: Manual Creation (not recomended)**
- Create a random mix of letters and numbers, 32 characters long
- Example: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`

### Optional Settings

You can also configure these optional settings:
> **NOTE:** If you do not fully know what they are for, leaving them on default is the best practice.
```yaml
port: 3002                              # Web interface port (default: 3002)
disable_telegram: false                 # Set to true to disable Telegram integration
disable_scheduler: false                # Set to true to disable task scheduler
upload_path: "/data/uploads"            # File upload directory
db_file: "/data/production.sqlite3"     # Database file location
```

## Step 4: Save and Start

1. **Click "Save"** to save your configuration
2. **Go to the "Info" tab**
3. **Click "Start"** to start the add-on
4. **Monitor the logs** to ensure it starts successfully
### example functional logs

```yaml
s6-rc: info: service s6rc-oneshot-runner: starting
s6-rc: info: service s6rc-oneshot-runner successfully started
s6-rc: info: service fix-attrs: starting
s6-rc: info: service fix-attrs successfully started
s6-rc: info: service legacy-cont-init: starting
s6-rc: info: service legacy-cont-init successfully started
s6-rc: info: service legacy-services: starting
s6-rc: info: service legacy-services successfully started
[22:03:52] INFO: Starting Tududi add-on...
[22:03:52] INFO: Tududi will run on port 3002
[22:03:52] INFO: TUDUDI_USER_EMAIL configured
[22:03:52] INFO: TUDUDI_USER_PASSWORD configured
[22:03:52] INFO: TUDUDI_SESSION_SECRET configured
[22:03:52] INFO: Upload path set to /data/uploads
[22:03:52] INFO: Database file set to /data/production.sqlite3
[22:03:52] INFO: Creating necessary directories...
[22:03:52] INFO: Running database migrations...
Sequelize CLI [Node: 20.15.1, CLI: 6.6.3, ORM: 6.37.7]
Using database file '/data/production.sqlite3'
Loaded configuration file "config/database.js".
Using environment "production".
No migrations were executed, database schema was already up to date.
[22:03:53] INFO: Migrations completed successfully
[22:03:53] INFO: Looking for Tududi executable...
[22:03:53] INFO: Using upstream start script: /app/backend/cmd/start.sh
Database backed up to /data/db-backup-20251105220353.sqlite3
Checking database connection...
Using database file '/data/production.sqlite3'
🔍 Checking database status...
📂 Database Configuration:
   Storage: /data/production.sqlite3
   Dialect: sqlite
   Environment: production
   File size: 276.00 KB
   Last modified: 2025-11-05T21:03:14.972Z
🔌 Testing database connection...
✅ Database connection successful
📊 Table Statistics:
   Users: 1 records
   Areas: 3 records
   Projects: 4 records
   Tasks: 9 records
   Notes: 0 records
   Tags: 4 records
   Inbox Items: 0 records
✅ Database status check completed
Running database migrations...
Sequelize CLI [Node: 20.15.1, CLI: 6.6.3, ORM: 6.37.7]
Using database file '/data/production.sqlite3'
Loaded configuration file "config/database.js".
Using environment "production".
No migrations were executed, database schema was already up to date.
Migrations completed successfully
Using database file '/data/production.sqlite3'
Creating user with email: [Your_Conficured_User_Email]
User exists, password updated
Email: [Your_Conficured_User_Email]
User ID: 1
Created: Wed Nov 05 2025 10:45:16 GMT+0100 (Central European Standard Time)
Admin: yes
Using database file '/data/production.sqlite3'
Server running on port 3002
Server listening on http://localhost:3002
```

## Step 5: First Access

### Using Home Assistant Interface (Recommended)

1. **On the add-on page**, click **"Open Web UI"**, or use the **Sidebar** if you enabeled it for the add-on
2. **Log in** using the credentials you configured:
   - **Email**: The `tududi_user_email` you set
   - **Password**: The `tududi_user_password` you set

### Using Direct Access (Alternative)

If you prefer direct access:
1. **Navigate to** `http://YOUR_HA_IP:3002`
2. **Log in** with your configured credentials

## Step 6: Initial Setup

After first login:

1. **Explore the interface** to familiarize yourself
2. **Create your first task** to test functionality
3. **Configure additional settings** as needed (Telegram, etc.)
4. **Set up any integrations** you want to use