#  defaults.sh — ds

> **Convert user defaults (plist) into shell script with ease!**

[![asciicast ds demo](https://asciinema.org/a/gql2Lhn0grvlgjw4RzaS1NOPV.svg)](https://asciinema.org/a/gql2Lhn0grvlgjw4RzaS1NOPV)

## 🌟 Overview
> <br>
> A while ago, I started to build dotfiles up. Soon found out there is no robust way to convert preferences (plists) into shell scripts. So, decided to create a such script to automate the processes. This script has been just only for myself though, I'm releasing it to the public 🎉<br>
> To make a such time into constructive one, at least a part of it. This might be a good chance to review or reconstruct your dotfiles. It'll be a fun with `defaults.sh`.<br>
> <br>
> Stay Safe — Instead, Unleash the Power of `defaults`!<br>
> <br>

- **Based on Bash**
    - All the parsing are done with the shell's string manipulation
- Originally written on `macOS Mojave`, thus it should works on the OS too
    - Although not sure with the older macOSes, it should also work

<br>

## ⏬ Installation

> **Homebrew**

```sh
brew tap aerobounce/defaults.sh "https://github.com/aerobounce/defaults.sh" && brew install ds
```

> **Portable**

```sh
# Download 'ds' onto ~/Desktop & make it executable
ds=~/Desktop/ds; curl "https://raw.githubusercontent.com/aerobounce/defaults.sh/master/ds" >| "$ds" && chmod -vv $(sh -c 'printf "%04o" $((0777 - $(umask)))') "$ds"
```

<br>

## ✏️ Usage
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

<br>

## ❓ "Convert" user defaults?

**When you build dotfiles, aren't they inconvenient format?**

> **NeXTStep Format**

```sh
$ defaults read com.apple.dock
```

```sh
{
    autohide = 1;
    "autohide-delay" = 0;
    "autohide-time-modifier" = 0;
...
```

> **XML Property Lists**

```sh
$ defaults export com.apple.dock -
```

```xml
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

**With `ds`, you'll get this:**

> **Shell Script**

```sh
$ ds -d com.apple.dock
```

```sh
#!/usr/bin/env bash

defaults write com.apple.dock "autohide" -boolean true
defaults write com.apple.dock "autohide-delay" -float 0.0
defaults write com.apple.dock "autohide-time-modifier" -float 0.0
...
```

<br>

## ✨ Examples

> **See the preferences of `Dock.app` on the fly:**

```sh
$ ds -d com.apple.dock
#!/usr/bin/env bash

defaults write com.apple.dock "autohide" -boolean true
defaults write com.apple.dock "autohide-delay" -float 0.0
defaults write com.apple.dock "autohide-time-modifier" -float 0.0
defaults write com.apple.dock "enable-spring-load-actions-on-all-items" -boolean true
defaults write com.apple.dock "expose-group-apps" -boolean true
defaults write com.apple.dock "launchanim" -boolean true
defaults write com.apple.dock "magnification" -boolean false
...
```

> **Pipe the result into any command you like:**

```sh
$ ds -d com.apple.dock | <subl | less...>
```

> **Export all the user defaults as shell script:**

```sh
$ ds save

$ ls ~/Desktop
ds 2020.04.11 14.54.06/

$ ls -1 'ds 2020.04.11 14.54.06'
ContextStoreAgent.sh*
MobileMeAccounts.sh*
NSGlobalDomain.currentHost.sh*
NSGlobalDomain.sh*
com.apple.AMPDevicesAgent.sh*
com.apple.AMPLibraryAgent.sh*
...
```

> **Regular expression filtering:**

```sh
# Case Insensitive
$ ds -e '(?i)show' -d "com.apple.finder"
defaults write com.apple.finder "AppleShowAllFiles" -boolean true
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -boolean false
defaults write com.apple.finder "ShowPathbar" -boolean true
...
```

```sh
# Ignore specific keys
$ ds -e '^(SUEnableAutomaticChecks|(?!SU|NSWindow|NSSplitView|MSApp|NSToolbar).)*$' -d "com.flexibits.fantastical2.mac"
#
# With this example, it skips the keys that start with:
# "SU", "NSWindow", "NSSplitView", "MSApp", "NSToolbar"
# However, "SUEnableAutomaticChecks" is the exception and will not be skipped.
#
```

> If you come up with other useful expressions, please let me know at [Discussions](https://github.com/aerobounce/defaults.sh/discussions).

<br>

> **Script that resets preferences of an app while preserving your settings:**

```sh
#!/usr/bin/env bash

trap 'killall Finder ; open -a Finder >/dev/null 2>&1' EXIT

defaults remove com.apple.finder

defaults write com.apple.finder "AppleShowAllFiles" -boolean true
defaults write com.apple.finder "DisableAllAnimations" -boolean true
defaults write com.apple.finder "FK_AppCentricShowSidebar" -boolean true
defaults write com.apple.finder "FXAddSearchToSidebar" -boolean false
defaults write com.apple.finder "FXArrangeGroupViewBy" -string 'Kind'
defaults write com.apple.finder "FXDefaultSearchScope" -string 'SCcf'
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -boolean false
...
```
