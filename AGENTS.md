# .dotfiles agent notes

This is a public dotfiles repository. Do not add secrets, tokens, auth files, session files, machine-specific caches, private keys, logs, or application state.

Before committing or pushing, check staged files for obvious secrets.

`install.conf.yaml` is the Dotbot source of truth.

Prefer tracking small, intentional config files over whole application state directories.

Do not track:
- Pi auth/session/cache files
- KDE wallet/session/cache files
- Browser, Discord, Slack, or app cache/state directories
- Machine-specific monitor layouts unless explicitly requested

Project-specific `AGENTS.md` files belong in their own project repos, not in the Pi config directory.

Keyboard layering intent:
- KDE/window-manager uses Meta/Super.
- Herdr uses plain Alt inside terminals.
- Ctrl/Ctrl+Shift should generally remain for shell, terminal, and apps.
