#  ds

### User Defaults Plist → Shell Script converter.

[![](https://img.shields.io/badge/Platform-macOS%20Mojave+-blue.svg)]()
[![](https://img.shields.io/github/v/tag/aerobounce/defaults.sh?display_name=tag)]()

- Made for dotfiles
- Written in Bash
- Tested on Mojave, Catalina and Big Sur (Although not tested, it should work with older OSes)

<br>

[![asciicast ds demo](https://asciinema.org/a/gql2Lhn0grvlgjw4RzaS1NOPV.svg)](https://asciinema.org/a/gql2Lhn0grvlgjw4RzaS1NOPV)


# Installation

**Homebrew**

```sh
brew install "aerobounce/tap/ds"
```


# Usage

```sh
ds (-d | domain) <(domain | plist-path)>
ds (-c | currentHost) <domain>
ds (-s | save)

ds (-e | --regex) <pattern> (-d | domain) <(domain | plist-path)>
ds (-e | --regex) <pattern> (-c | currentHost) <domain>
ds (-e | --regex) <pattern> (-s | save)
```


# Examples

**Regular expression filtering:**

```sh

### Case Insensitive
$ ds -e '(?i)show' -d "com.apple.finder"

defaults write com.apple.finder "AppleShowAllFiles" -boolean true
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -boolean false
defaults write com.apple.finder "ShowPathbar" -boolean true
...

### Ignore specific keys with an exception
$ ds -e '^(SUEnableAutomaticChecks|(?!SU|NSWindow|NSSplitView|MSApp|NSToolbar).)*$' \
     -d "com.flexibits.fantastical2.mac"

# With this example above, ds skips any keys that start with:
# "SU", "NSWindow", "NSSplitView", "MSApp", "NSToolbar".
# However, "SUEnableAutomaticChecks" is the exception and will not be skipped.

```

> If you came up with other useful expressions, please let me know.

**See the preferences of `Dock.app` on the fly:**

```sh
$ ds -d com.apple.dock
```

**See the preferences of `Music.app` on the fly:**

```sh
$ ds -d com.apple.music

# Dump CurrentHost plist (Note that you just replace `-d` with `-c`, not `-c -d ...`)
$ ds -c com.apple.music
```

**Pipe the result into any command you like:**

```sh
$ ds -d com.apple.dock | <subl | less | ...>
```

**Export all the user defaults as shell script:**

```sh
$ ds save
```

**Script that resets preferences of an app while preserving your settings:**

```sh
#!/usr/bin/env bash

trap 'killall Finder ; open -a Finder >/dev/null 2>&1' EXIT

defaults remove com.apple.finder

defaults write com.apple.finder "AppleShowAllFiles" -boolean true
defaults write com.apple.finder "DisableAllAnimations" -boolean true
...
```


# "Convert" User Defaults?

With `defaults`, you get either of these:

**NeXTStep Format**

```sh
$ defaults read com.apple.dock

{
    autohide = 1;
    "autohide-delay" = 0;
...
```

**XML Property Lists**

```sh
$ defaults export com.apple.dock -

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>autohide</key>
    <true/>
    <key>autohide-delay</key>
    <real>0.0</real>
...
```

With `ds`, you'll get this:

**Shell Script**

```sh
$ ds -d com.apple.dock

#!/usr/bin/env bash

defaults write com.apple.dock "autohide" -boolean true
defaults write com.apple.dock "autohide-delay" -float 0.0
...
```
