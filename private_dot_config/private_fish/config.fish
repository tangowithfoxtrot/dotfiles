fish_add_path /opt/homebrew/bin
fish_add_path "$HOME/.cargo/bin"
set PATH "$PATH:$HOME/git/scripts"

# Personal; Prod
set -gx BWS_ACCESS_TOKEN (security find-generic-password -w -s 'testpass' -a "$USER")
if status is-interactive
    # ask for input to see if we should fetch data
    printf '%s\n' 'Fetch data? [Y/n]'
    read -l response
    if test "$response" != n
        printf '%s\n' 'Fetching data...'
        . ($HOME/.config/fish/scripts/bws_secrets --shell fish get | psub)
    end
end

set -gx ANDROID_SDK_ROOT /$HOME/Library/Android/sdk
set -gx ANDROID_NDK_HOME /opt/homebrew/share/android-ndk
set -gx JAVA_HOME (/usr/libexec/java_home)

set -gx HOST $hostname
set -gx CRON_SCHEDULE "0 0 1 * *"
set -gx PHONE "192.168.1.10"

set -gx JC_COLORS "blue,brightblack,magenta,green"
set -gx NATIVEFIER_APPS_DIR /Applications/

set -gx TELEMETRY_ENABLED false # infisical
set -gx TUNNEL_ORIGIN_CERT "/$HOME/.cloudflared/cert.pem"
set -gx BW_SERVE_URL "http://127.0.0.1:2929"

#set BW_RESPONSE "true" # https://github.com/bitwarden/clients/blob/80f5a883e088e941c415f224d1fa7af3dc2b6cd7/apps/cli/src/services/console-log.service.spec.ts#L20
set -gx BW_PRETTY true

switch (uname)
    case Darwin
        set -gx CONFIG "$HOME/Library/Application Support/"
    case Linux
        set -gx CONFIG "$HOME/.config/"
    case '*'
        printf "%s" "Uh-oh! Stinky Windows!"
end

### EXPORT ###
set -gx fish_greeting # Supresses fish's intro message
set -gx TERM xterm-256color # Sets the terminal type
#set EDITOR "emacsclient -t -a ''"                 # $EDITOR use Emacs in terminal

set -gx EDITOR "/usr/bin/env nano"

set -gx VISUAL code #"emacsclient -c -a emacs"              # $VISUAL use Emacs in GUI mode

set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
set -gx TELEMETRY_ENABLED false
### Nix Stuff
#if fish_command_not_found; nix-shell -p $argv;
#  else; echo "command not found";
#end

function fish_command_not_found
    #  whatprovides $argv
    #  nix-shell -p $argv[1] --run "$argv"
    #  nix-shell -p wmctrl --run "wmctrl -lG"
end

### SET MANPAGER
### Uncomment only one of these!

### "bat" as manpager
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p --theme Dracula'"

### "moar" as manpager and pager
# set -gx MANPAGER "moar -no-clear-on-exit -no-statusbar -style dracula"
set -gx PAGER "moar -no-clear-on-exit -no-statusbar -style dracula"

### "vim" as manpager
# set -gx MANPAGER '/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa <CR >\" </dev/tty <(col -b)"'

### "nvim" as manpager
# set -gx MANPAGER "nvim -c 'set ft=man' -"

function fish_user_key_bindings
    fish_default_key_bindings
end

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set -gx fish_color_normal brcyan
set -gx fish_color_autosuggestion '#7d7d7d'
set -gx fish_color_command brcyan
set -gx fish_color_error '#ff6c6b'
set -gx fish_color_param brcyan

### FUNCTIONS ###
function commits
    git log --author="$argv" --format=format:%ad --date=short | uniq -c | awk '{print $1}' | spark | lolcat
end

# Functions needed for !! and !$
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end
# The bindings for !! and !$
if [ $fish_key_bindings = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Function for copying files and directories, even recursively.
# ex: copy DIRNAME LOCATIONS
# result: copies the directory and all of its contents.
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

### END OF FUNCTIONS ###

### ALIASES ###

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# pacman and yay
alias pacsyu='sudo pacman -Syyu' # update only standard pkgs
alias yaysua='yay -Sua --noconfirm' # update only AUR pkgs (yay)
alias yaysyu='yay -Syu --noconfirm' # update standard pkgs and AUR pkgs (yay)
alias parsua='paru -Sua --noconfirm' # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm' # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck' # remove pacman lock
alias cleanup='sudo pacman -Rns (pacman -Qtdq)' # remove orphaned packages

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# adding flags
alias df='df -h' # human-readable sizes
alias free='free -m' # show sizes in MB
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'
alias vifm='./.config/vifm/scripts/vifmrun'
alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'
alias mocp='mocp -M "$XDG_CONFIG_HOME"/moc -O MOCDir="$XDG_CONFIG_HOME"/moc'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# youtube-dl
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-m4a="yt-dlp --extract-audio --audio-format m4a "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias yta-opus="yt-dlp --extract-audio --audio-format opus "
alias yta-vorbis="yt-dlp --extract-audio --audio-format vorbis "
alias yta-wav="yt-dlp --extract-audio --audio-format wav "
alias ytv-best="yt-dlp -f bestvideo+bestaudio "

alias bashly='docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly'
# Start X at login
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end

### SETTING THE STARSHIP PROMPT ###
starship init fish | source

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/$HOME/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

source ~/.config/fish/completions/*
