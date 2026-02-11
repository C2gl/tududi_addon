## Troubleshooting Installation

### Common Issues

#### Add-on Won't Start
- **Check logs** for error messages
- **Verify configuration** is complete and correct
- **Ensure all required fields** are filled

#### Can't Access Web Interface
- **Check add-on status** - ensure it's running
- **Try the "Open Web UI" button** instead of direct IP access
- **Check Home Assistant logs** for any network issues

#### Login Issues
- **Double-check credentials** in configuration
- **Ensure no extra spaces** in email/password fields
- **Try clearing browser cache** or use incognito mode

#### "exec /init: exec format error"
- **Use version 0.1.1 or later** (this issue has been fixed)
- **Ensure you're on AMD64 architecture** (ARM64 temporarily unsupported)

### Getting Help

If you encounter issues:

1. **Check the logs** in the add-on interface
2. **Review this documentation** thoroughly
3. **Search existing issues** on [GitHub](https://github.com/C2gl/tududi_addon/issues)
4. **Create a new issue** if your problem isn't covered


## System Requirements

### Supported Architectures
- ✅ **AMD64** (Intel/AMD 64-bit)
- ❌ **ARM64** (temporarily disabled due to build issues)

### Home Assistant Versions
- Compatible with all current Home Assistant versions
- Requires Home Assistant OS, Supervised, or Container
- Not compatible with Home Assistant Core (no add-on support)

### Resource Requirements
- **RAM**: Minimum 512MB available
- **Storage**: ~500MB for installation + data storage
- **CPU**: Any modern processor (tested on Intel N100)

---

**Need more help?** Check our [Documentation Index](README.md) or visit the [GitHub Issues](https://github.com/C2gl/tududi_addon/issues) page.