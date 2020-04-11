#  defaults.sh

> Convert your `defaults` or any `plist` into Shell Scripts with ease!

[![Demo](https://asciinema.org/a/wUXTRimoyZDaizGfzX2XiJfYU.svg)](https://asciinema.org/a/wUXTRimoyZDaizGfzX2XiJfYU)

## ★ Overview
A while ago, I started to build **dotfiles** up. Soon found out there is no robust way to convert **preferences (plists)** into **shell scripts**. So, decided to create a such script to **automate the processes**.<br>

This script has been just only for myself though, today, *I'm releasing it to the public* 🎉 <br>
**To, make a such time into constructive one, at least a part of it.** Take it from a different perspective, this might be a good chance to review or reconstruct your dotfiles. It'll be a fun with `defaults.sh`.<br>

**Stay Home, Stay Safe. Instead, Unleash the Power of `defaults`!**<br>

<br>

## ✑ Technical Details
- **Based on Bash**
    - `GNU bash, version 3.2.57(1)-release (x86_64-apple-darwin19)` (`macOS Catalina`)
    - Originally written on Mojave, so it works on Mojave.
    - Not sure with the older macOSes
- **Dependencies are only**
    - `chmod` `date` `defaults` `mkdir` `sleep` `wc`
    - Which are shipped with macOS by default
- **All the parsing are done with the shell's string manipulation**

<br>

## ⇣ Installation

### Homebrew
```sh
brew install localbrew/core/ds
```

### Portable
```sh
# Download onto ~/Desktop
ds=~/Desktop/ds; curl "https://raw.githubusercontent.com/aerobounce/defaults.sh/master/ds" >| "$ds" && chmod -vv $(sh -c 'printf "%04o" $((0777 - $(umask)))') "$ds"
```

<br>

## ✎ Usage
```sh
NAME
    defaults.sh -- Convert and save your defaults as shell script.

USAGE
    rd
    rd (domain | -d) <(Domain | Plist-path)>
    rd (save | -s)

DESCRIPTION
    [no command]
            Shows this help.

    (domain | -d) <(Domain | Plist-path)>
            Prints parsed defauls of specified domain or plist file.
            Both of the following commands are valid:
            $ ds -d com.apple.dock
            $ ds -d ~/Library/Preferences/com.apple.dock.plist

    (save | -s)
            Exports all the defaults to ~/Desktop as executable .sh files.
            Domains are:
                'defaults -currentHost domains' + NSGlobalDomain
                'defaults domains' + NSGlobalDomain
```
<br>

## ✦ Exmaples

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
    rd 2020.04.11 14.54.06/

    $ ls -1 'rd 2020.04.11 14.54.06'
    ContextStoreAgent.sh*
    MobileMeAccounts.sh*
    NSGlobalDomain.currentHost.sh*
    NSGlobalDomain.sh*
    com.apple.AMPDevicesAgent.sh*
    com.apple.AMPLibraryAgent.sh*
    ...
    # Now you can integrate them into your dotfiles
    # You need to remove needles keys though
    ```

- **Make a script that resets preferences of an app while preserving your settings**

    ```sh
    # Let's say we want to reset Finder.
    # Make com.apple.finder.sh script such as following:

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
