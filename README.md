# 🚀 Hub

**Stop remembering launch commands.** One entry in your Omarchy app launcher, every project one pick away.

```
Super+Space → "Hub" → pick a tool → Launch
```

## What it does

- 📋 **One menu** listing all your tools, each with a one-line description
- ▶️ **Launch** in a visible terminal, and the browser opens itself once the server is up
- ⏹️ **Stop / Restart** running web tools (it knows by port)
- 📂 **Open folder** in a terminal or jump to the **GitHub** repo
- 📦 Asks before running `npm install` when deps are missing

## Install

```bash
git clone <this repo> ~/Documents/Code/hub
~/Documents/Code/hub/install.sh
```

Needs Omarchy (uses `omarchy-menu-select`) and expects your projects as sibling folders of `hub/`.

## Add a tool

One line in `tools.conf`:

```
name | description | folder | command | port (- if none) | github repo | install cmd (optional)
```

Web tools get a **fixed port** so Hub can tell if they're running and stop them.

## Uninstall

```bash
./uninstall.sh   # removes ~/.local/share/applications/hub.desktop
```

Then delete the folder. That's it, nothing else is touched.

## How it works

~50 lines of bash: `tools.conf` → `omarchy-menu-select` → `xdg-terminal-exec`. No daemon, no deps.
