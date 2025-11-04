# Contributing to Tududi Add-on

Thank you for your interest in contributing to the Tududi Home Assistant Add-on! This document outlines how to contribute to this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Repository Structure](#repository-structure)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Version Management](#version-management)
- [Release Process](#release-process)

## Code of Conduct

This project follows a simple code of conduct:
- Be respectful and inclusive
- Focus on constructive feedback
- Help maintain a welcoming environment for all contributors

## Getting Started

### Prerequisites

- Git
- Docker (for local testing)
- Home Assistant instance for testing
- Basic knowledge of Home Assistant add-ons

### Fork and Clone

1. Fork this repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/tududi_addon.git
   cd tududi_addon
   ```

### Repository Structure

```
tududi_addon/
├── tududi-addon/          # Stable addon
│   ├── config.yaml        # Addon configuration
│   ├── Dockerfile         # Container definition
│   ├── README.md          # Addon documentation
│   ├── CHANGELOG.md       # Version history
│   └── ...
├── tududi-addon-dev/      # Development addon
│   ├── config.yaml        # Dev addon configuration
│   ├── Dockerfile         # Dev container definition
│   └── ...
├── .github/workflows/     # CI/CD automation
└── repository.yaml        # Repository metadata
```

## Development Workflow

### Branching Strategy

- `main` - Stable releases and production-ready code
- `dev` - Development versions and testing
- `feature/xxx` - Feature development branches
- `bugfix/xxx` - Bug fix branches

### Making Changes

1. **Create a branch** from the appropriate base:
   ```bash
   # For stable addon changes
   git checkout main
   git checkout -b feature/your-feature-name
   
   # For dev addon changes
   git checkout dev
   git checkout -b feature/your-dev-feature
   ```

2. **Make your changes** following these guidelines:
   - Stable addon: `tududi-addon/` directory
   - Development addon: `tududi-addon-dev/` directory
   - Keep changes focused and atomic

3. **Update documentation**:
   - Update `README.md` if user-facing features change
   - Update `CHANGELOG.md` with your changes

### File-Specific Guidelines

#### `config.yaml`
- Follow Home Assistant addon configuration standards
- Document new configuration options in README.md

#### `Dockerfile`
- Use multi-stage builds when possible
- Minimize image size
- Include security best practices

#### `README.md`
- Keep user documentation clear and up-to-date
- Include configuration examples
- Document any breaking changes

#### `CHANGELOG.md`
- Follow [Keep a Changelog](https://keepachangelog.com/) format
- Group changes by type: Added, Changed, Deprecated, Removed, Fixed, Security
- Include version number and date

## Testing

### Local Testing

1. **Build the addon locally**:
   ```bash
   docker build -t local/tududi-test tududi-addon/
   ```

2. **Test in Home Assistant**:
   - Add your local repository to HA
   - Install and test the addon
   - Verify all functionality works

### CI/CD Testing

- All pushes trigger automated builds
- Pull requests are automatically tested
- Both stable and dev versions are built when appropriate

## Submitting Changes

### Pull Request Process

1. **Push your branch** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create a Pull Request** with:
   - **Use the PR template**: GitHub will automatically populate the PR description with our template - please fill it out completely
   - Clear title describing the change
   - Detailed description of what was changed and why
   - Reference any related issues
   - Mark if it affects stable or dev addon
   - Check all relevant boxes in the template checklist

3. **PR Requirements**:
   - [ ] Code builds successfully
   - [ ] Tests pass (if applicable)
   - [ ] Documentation updated
   - [ ] Changelog updated

### PR Review Process

- Maintainers will review your PR
- Address any feedback promptly
- Be prepared to make changes if requested
- Once approved, maintainers will merge

## Version Management

### Stable Addon (`tududi-addon`)
- Uses semantic versioning: `X.Y.Z`
- Only updated for stable releases
- Follows upstream Tududi releases when possible

### Development Addon (`tududi-addon-dev`)
- Uses format: `X.Y.Z-dev.NN` (e.g., `0.0.11-dev.01`)
- Updated frequently for testing
- May include experimental features

### Version Update Guidelines

1. **Patch** (`0.0.X`): Bug fixes, minor improvements
2. **Minor** (`0.X.0`): New features, non-breaking changes
3. **Major** (`X.0.0`): Breaking changes, major rewrites

#### for the dev versions
follow the version guideline but add `-dev.0X` at the end of the version that will be released once your dev version works

## Release Process

### Development Releases
1. Update version in `tududi-addon-dev/config.yaml`
2. Update `tududi-addon-dev/CHANGELOG.md`
3. Merge to `dev` branch
4. Trigger build via GitHub Actions

### Stable Releases
1. Update version in `tududi-addon/config.yaml`
2. Update `tududi-addon/CHANGELOG.md`
3. Merge to `main` branch
4. Create GitHub release with tag
5. Trigger build via GitHub Actions

## Getting Help

- **Issues**: Open an issue for bugs or feature requests
- **Discussions**: Use GitHub Discussions for questions
- **Documentation**: Check README.md files for guidance

## Recognition

Contributors will be acknowledged in:
- GitHub contributors list
- Release notes (for significant contributions)
- Repository README (for ongoing contributors)

## License

By contributing, you agree that your contributions will be licensed under the same license as this project (MIT License).

---

Thank you for contributing to the Tududi Add-on project! 🎉
