# Configuration

Personal configuration files for the development environment.

## Repository Structure

```
lazygit/          # lazygit configuration
nvim/             # AstroNvim (Neovim) configuration
oh-my-posh/       # Oh My Posh prompt theme
pwsh/             # PowerShell profile
```

## Requirements

### AstroNvim

This configuration is built on [AstroNvim](https://docs.astronvim.com/#-requirements), which requires:

- [Neovim v0.11+](https://github.com/neovim/neovim/releases/tag/stable) (not including nightly)
- [Nerd Fonts](https://www.nerdfonts.com/font-downloads) - set the terminal's font face to a Nerd Font (optional, but icons won't render correctly without it)
- [Tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md) (will be auto-installed via Mason if not present)
- A C compiler available in the `PATH` (see [https://docs.rs/cc/latest/cc/#compile-time-requirements](https://docs.rs/cc/latest/cc/#compile-time-requirements))
- A [clipboard tool](https://neovim.io/doc/user/provider.html#clipboard-tool) for system clipboard integration
- A terminal emulator with true color support

### Additional tools

- [ripgrep](https://github.com/BurntSushi/ripgrep) - live grep file search
- [fzf](https://github.com/junegunn/fzf) - fuzzy finder used by the PowerShell profile
- [Oh My Posh](https://ohmyposh.dev/) - prompt theming engine, configured via [oh-my-posh/theme.omp.json](oh-my-posh/theme.omp.json)
- [lazygit](https://github.com/jesseduffield/lazygit) - configured via [lazygit/config.yml](lazygit/config.yml)
- [PowerShell 7+](https://github.com/PowerShell/PowerShell) - for [pwsh/profile.ps1](pwsh/profile.ps1)
- [Node.js](https://nodejs.org/en/) - required by many LSPs and the Node REPL toggle terminal

## Setup

1. Install the requirements above for your platform.
2. Symlink or copy each folder to its expected location, e.g.:
   - `nvim/` → `~/.config/nvim`
   - `lazygit/config.yml` → lazygit's config directory
   - `oh-my-posh/theme.omp.json` → referenced from your shell profile / `$env:OMP_CONFIG_FILE`
   - `pwsh/profile.ps1` → your PowerShell `$PROFILE`
3. Launch Neovim to let AstroNvim/Lazy install plugins automatically.
