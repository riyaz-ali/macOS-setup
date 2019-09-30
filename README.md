# macOS setup script

A shell script and several of `dotfiles` to set up a macOS laptop for web and mobile development.

## Installation

First, download the script

```shell
curl -O https://raw.githubusercontent.com/riyaz-ali/macOS-setup/master/mac.sh
```

Review the script (avoid running scripts you haven't read!)

```shell
less mac
```

Execute the downloaded script

```shell
sh mac.sh 2>&1 | tee ~/install.log
```

Optionally, review the log

```shell
less ~/install.log
```

## What's in it?

- First class [**`zsh`**](http://zsh.sourceforge.net/) support
- Install and set up [**`homebrew`**](https://brew.sh/)
- Installs the following [`brew` formulae](https://formulae.brew.sh)

|             | Description
| ----------- | :----------:
| automake    | Tool for generating GNU Standards-compliant Makefiles
| binutils    | GNU binary tools for native development
| cmake       | Cross-platform make
| coreutils   | GNU File, Shell, and Text utilities
| curl        | HTTP request tool
| fzf         | Command-line fuzzy finder written in Go
| findutils   | Collection of GNU find, xargs, and locate
| git         | Distributed revision control system
| gnupg2      | GNU Pretty Good Privacy (PGP) package
| gnu-sed     | GNU implementation of the famous stream editor
| jq          | Lightweight and flexible command-line JSON processor
| libyaml     | YAML Parser
| mkcert      | Simple tool to make locally trusted development certificates
| moreutils   | Collection of tools that nobody wrote when UNIX was young
| openssl     | SSL/TLS cryptography library
| openssh     | OpenBSD freely-licensed SSH connectivity tools
| reattach-to-user-namespace` | Reattach process (e.g., tmux) to background
| telnet      | User interface to the TELNET protocol (built from macOS Sierra sources)
| tmux        | Terminal multiplexer
| vim         | Vi 'workalike' with many additional features
| watchman    | Watch files and take action when they change
| yarn        | JavaScript package manager

- Also installs the following [`cask`s](https://github.com/Homebrew/homebrew-cask)

|               | Description
|---------------|:-----------:
| alacritty     | A cross-platform, GPU-accelerated terminal emulator
| balenaetcher  | Flash OS images to SD cards & USB drives, safely and easily.
| postgres      | Full-featured postgres pckaged as a Mac app
| motrix        | Clean and easy to use download manager
| vlc           | Free and open-source media player
| visual-studio-code | Source-code editor sby Microsoft
| google-chrome | Cross-platform web browser by Google
| google-backup-and-sync | Drive backup and sync tool by Google

- Installs [oh-my-zsh](https://ohmyz.sh/)
- Adds [`tmux` configuration](https://github.com/gpakosz/.tmux)
- Configures language environments for [Ruby](https://www.ruby-lang.org/en/), [Node.js](https://nodejs.org/en/) and [Java](https://www.java.com/en/) using version managers for the respective languages

## References

Following is a list of sources that I used to gather bits and pieces for this project -

- [ThoughtBot's Laptop](https://github.com/thoughtbot/laptop)
- [ThoughtBot's Dotfiles](https://github.com/thoughtbot/dotfiles)
- [Mathias Bynens' Dotfiles](https://github.com/mathiasbynens/dotfiles)
