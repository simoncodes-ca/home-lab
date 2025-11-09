# Zsh Configuration

This directory contains modular zsh configuration files that are automatically loaded by `~/.zshrc`.

## Directory Structure

```
~/.config/zsh/
├── aliases/
│   ├── git.zsh         # Git aliases and functions
│   ├── npm.zsh         # npm/Node.js aliases and functions
│   ├── python.zsh      # Python aliases and functions
│   ├── navigation.zsh  # Directory navigation aliases
│   └── frontend.zsh    # TypeScript/React/Angular aliases
├── functions/
│   └── utils.zsh       # Utility functions
└── README.md           # This file
```

## Available Aliases & Functions

### Git (`aliases/git.zsh`)
- `gs` - Git status with short format
- `gai` - Git add interactive
- `gundo` - Undo last commit (keep changes)
- `gpf` - Git push --force-with-lease (safe force push)
- `gbclean` - Delete all merged branches
- `gl` - Pretty git log with graph
- `glast` - Show files changed in last commit
- `gamend` - Amend commit without changing message
- `greb <N>` - Interactive rebase last N commits
- `gbda <branch>` - Delete branch locally AND remotely

**Note**: Oh-My-Zsh git plugin also provides many aliases like `gco`, `gp`, `gcb`, `gcam`, etc.

### npm/Node.js (`aliases/npm.zsh`)
- `ni` / `nid` / `nig` - npm install variants
- `nrs` / `nrd` / `nrb` / `nrt` - npm run scripts
- `nclean` - Remove node_modules and reinstall
- `nlg` - List global packages
- `nout` - Check outdated packages
- `nrun` - Interactive script selector with fzf
- `npkg [name]` - Open package on npmjs.com

### Python (`aliases/python.zsh`)
- `py` / `pip` - Python3 shortcuts
- `mkvenv [name]` - Create and activate virtual environment
- `freeze` / `pipr` - Manage requirements.txt
- `serve` - Start Python HTTP server
- `pyt` - Run pytest with coverage

### Navigation (`aliases/navigation.zsh`)
- `..` / `...` / `....` - Quick directory navigation
- `l` / `la` / `ll` / `lt` - List files (uses exa if available)
- `mkcd <dir>` - Create directory and cd into it
- `cdroot` - Jump to git repository root

### Frontend (`aliases/frontend.zsh`)
- `ng` / `ngs` / `ngb` - Angular CLI commands
- `cra` / `cra-ts` - Create React App
- `tsc` / `tsw` / `tsi` - TypeScript compiler
- `lint` / `lintfix` - ESLint commands
- `pf` - Prettier format all
- `clean` - Remove build artifacts
- `mkcomp <name> [dir]` - Create React component boilerplate

### Utilities (`functions/utils.zsh`)
- `killport <port>` - Find and kill process on port
- `extract <file>` - Extract any archive format
- `gclone <url>` - Git clone and cd into directory
- `backup <file>` - Create timestamped backup
- `duf` - Show disk usage sorted by size
- `myip` - Show public IP address
- `weather [city]` - Show weather forecast

## Customization

To add more aliases or functions:

1. Edit existing files in `aliases/` or `functions/`
2. Or create new `.zsh` files in those directories
3. Reload your shell: `source ~/.zshrc`

All `.zsh` files in `aliases/` and `functions/` are automatically loaded.

## Note on Oh-My-Zsh Conflicts

Some aliases may conflict with Oh-My-Zsh plugins. When there's a conflict:
- Aliases defined later override earlier ones
- Functions can coexist with aliases of the same name (function takes precedence)

Already provided by Oh-My-Zsh git plugin:
- `gcb` - git checkout -b
- `gcam` - git commit -am
- `gbd` - git branch --delete (local only)
- Many more: run `alias | grep git` to see all

## Performance

The modular structure keeps startup time fast while maintaining organization. Each file is sourced on shell startup, adding approximately 5-10ms total.
