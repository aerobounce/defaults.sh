#  defaults.sh — ds

> **Convert user defaults (plist) into shell script with ease!**

[![asciicast ds demo](https://asciinema.org/a/gql2Lhn0grvlgjw4RzaS1NOPV.svg)](https://asciinema.org/a/gql2Lhn0grvlgjw4RzaS1NOPV)

<br>

## 🌟 Overview
A while ago, I started to build **dotfiles** up. Soon found out there is no robust way to convert **preferences (plists)** into **shell scripts**. So, decided to create a such script to **automate the processes**.<br>

This script has been just only for myself though, today, *I'm releasing it to the public* 🎉<br>
**To, make a such time into constructive one, at least a part of it.** Take it from a different perspective, this might be a good chance to review or reconstruct your dotfiles. It'll be a fun with `defaults.sh`.<br>

**Stay Home, Stay Safe. Instead, Unleash the Power of `defaults`!**<br>
<br>

## ❓ What do you mean by "Convert" user defaults?

- **When you build dotfiles, aren't they inconvenient format?**

    **NeXTStep Format**
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

    **XML Property Lists**
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

- **With `ds`, you'll get this:**

    **Shell Script Format**
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

## 🖋 Technical Details
- **Based on Bash**
    - `GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin19)` shipped with `macOS Catalina`
    - Originally written on `macOS Mojave`, thus it works on `macOS Mojave`
    - Although not sure with the older macOSes, it should work
- **Dependencies are only**
    - `chmod` `date` `defaults` `mkdir` `sleep` `wc`
    - Which are shipped with macOS by default
- **All the parsing are done with the shell's string manipulation**

<br>

## ⏬ Installation

- **Homebrew**

```sh
brew install localbrew/core/ds
```

- **Portable**

```sh
# Download onto ~/Desktop & make it executable
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
    ds (-s | save)

DESCRIPTION
    [no command]
            Shows this help.

    (-d | domain) <(domain | plist-path)>
            Prints parsed user defaults of specified domain or .plist file.
            Both of the following commands are valid:
                $ ds -d com.apple.dock
                $ ds -d ~/Library/Preferences/com.apple.dock.plist

    (-s | save)
            Exports all the defaults to ~/Desktop as executable .sh files.
            Domains are:
                'defaults -currentHost domains' + NSGlobalDomain
                'defaults domains' + NSGlobalDomain
```

<br>

## ✨ Examples

- **If you want to see the preferences of `Dock.app` on the fly:**

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

- **Or pipe it into any command you like:**

    ```sh
    $ ds -d com.apple.dock | <subl | less...>
    ```

- **Export all the user defaults as shell script:**

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

    - **Now you can integrate them into your dotfiles (You'll need to remove needles keys though)**


- **Script that resets preferences of an app while preserving your settings:**

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
