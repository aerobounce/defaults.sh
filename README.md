#  defaults.sh — ds

### User Defaults Plist → Shell Script converter.

[![](https://img.shields.io/badge/Platform-macOS%20Mojave+-blue.svg)]()
[![](https://img.shields.io/github/v/tag/aerobounce/defaults.sh?display_name=tag)]()

- Made for dotfiles
- Written in Bash
    - All the parsing are done with the shell's string manipulation
- Tested on Mojave, Catalina and Big Sur
    - Although not tested with the older macOSes, it should work

<br>

[![asciicast ds demo](https://asciinema.org/a/gql2Lhn0grvlgjw4RzaS1NOPV.svg)](https://asciinema.org/a/gql2Lhn0grvlgjw4RzaS1NOPV)


# Installation

**Homebrew**

```sh
brew tap aerobounce/defaults.sh "https://github.com/aerobounce/defaults.sh" && brew install ds
```

**Portable**

```sh
# Download 'ds' onto ~/Desktop & make it executable
ds=~/Desktop/ds; curl "https://raw.githubusercontent.com/aerobounce/defaults.sh/master/ds" >| "$ds" && chmod -vv $(sh -c 'printf "%04o" $((0777 - $(umask)))') "$ds"
```


# Usage

```sh
NAME
    defaults.sh -- Convert user defaults (plist) into shell script

USAGE
    ds

    ds (-d | domain) <(domain | plist-path)>
    ds (-c | currentHost) <domain>
    ds (-s | save)

    ds (-e | --regex) <pattern> (-d | domain) <(domain | plist-path)>
    ds (-e | --regex) <pattern> (-c | currentHost) <domain>
    ds (-e | --regex) <pattern> (-s | save)

DESCRIPTION
    [no command]
            Shows this help.

    (-e | --regex) <pattern>
            Specify a pattern to filter keys.

    (-d | domain) <(domain | plist-path)>
            Prints parsed user defaults of specified domain or .plist file.
            Both of the following commands are valid:
                $ ds -d com.apple.dock
                $ ds -d ~/Library/Preferences/com.apple.dock.plist

    (-c | currentHost) <domain>
            Same as (-d | domain), except operation will be restricted
            to the host the user is currently logged in on.

    (-s | save)
            Exports all the defaults as executable .sh files.
            (To '~/Desktop/ds +%Y.%m.%d %H.%M.%S/')

            Domains are:
                'defaults -currentHost domains' + NSGlobalDomain
                'defaults domains' + NSGlobalDomain
```


# "Convert" user defaults?

With `defaults`, you get either of these:

**NeXTStep Format**

```sh
$ defaults read com.apple.dock

{
    autohide = 1;
    "autohide-delay" = 0;
    "autohide-time-modifier" = 0;
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
    <key>autohide-time-modifier</key>
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
defaults write com.apple.dock "autohide-time-modifier" -float 0.0
...
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

> If you came up with other useful expressions, please let me know at [Discussions](https://github.com/aerobounce/defaults.sh/discussions).

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
