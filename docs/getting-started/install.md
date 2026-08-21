---
title: "Install Pageworks"
description: "Get Pageworks installed as an agent skill, CLI binary, or plugin in under two minutes."
section: getting-started
type: tutorial
status: stable
owner: "@platform-core"
last_reviewed: 2026-08-22
updated: 2026-08-22
---

# Install Pageworks

This guide walks you through installing Pageworks on macOS or Linux.

## Prerequisites

Verify your shell environment has `bash`, `curl`, and `git` installed:

```bash
bash --version
curl --version
git --version
```

## Installation Methods

### 1. Install CLI Only (Recommended for shell users)

Download and install the `pageworks` binary to `~/.local/bin/pageworks`:

```bash
curl -fsSL https://raw.githubusercontent.com/alexsmedile/pageworks/main/cli/install.sh | bash
```

Verify the CLI installation:

```bash
pageworks --version
```

```
pageworks 0.2.0
```

### 2. Install as a Claude Code Plugin

Symlink into your local project or user configuration:

```bash
ln -s /path/to/pageworks ~/.claude/plugins/pageworks
```

### 3. Install as a Codex / Antigravity Skill

Search the marketplace for `pageworks` or add the repository directly to your agent skill path.

## Next

- [Quickstart Tutorial](quickstart.md) — Scaffold and export your first documentation site.
