# PATH
# ---------------------------------------------------------------------
fish_add_path --prepend "$HOME/bin"
fish_add_path --prepend "$HOME/.local/bin"
fish_add_path --prepend "$HOME/.emacs.d/bin"
fish_add_path --prepend "$HOME/.poetry/bin"
fish_add_path --prepend "/usr/bin/"
fish_add_path --prepend "/usr/local/bin"
fish_add_path --prepend "/Users/saucon/Library/Application Support/Coursier/bin"
fish_add_path --prepend "$HOME/scripts"


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/saucon/google-cloud-sdk/path.fish.inc' ]; . '/Users/saucon/google-cloud-sdk/path.fish.inc'; end
# ---------------------------------------------------------------------


# Environment Variables
# ---------------------------------------------------------------------
set VISUAL "emacsclient -c -a ''"
set EDITOR "emacsclient -t -a ''"
set SSH_ENV "$HOME/.ssh/agent-environment"
set JAVA_HOME "/Users/saucon/Library/Caches/Coursier/arc/https/github.com/adoptium/temurin8-binaries/releases/download/jdk8u345-b01/OpenJDK8U-jdk_x64_mac_hotspot_8u345b01.tar.gz/jdk8u345-b01/Contents/Home"
set USE_GKE_GCLOUD_AUTH_PLUGIN True

# Set vim as Manpager
set --export MANPAGER '/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'
# ---------------------------------------------------------------------


# Aliases
# ---------------------------------------------------------------------
## List - using exa as a replacement for ls 
alias ls="lsd --long --group-dirs=first --date '+%Y-%m-%d %H:%M'"
alias lsa="lsd --long --group-dirs=first --almost-all --date '+%Y-%m-%d %H:%M'"
alias lst="lsd --long --group-dirs=first --tree --depth=2 --date '+%Y-%m-%d %H:%M'"
## I always miss the space
alias cd..="cd .."
## bat is better than cat
alias cat="bat"
## Colorize the grep command output 
alias grep='grep --color=auto'
## File system space info in readable format
alias df='df --human-readable'
## Memory info 
alias free="free -mt"
## Continue download
alias wget="wget -c"
## Userlist
alias userlist="cut -d: -f1 /etc/passwd"
## Calendar show full year
alias cal="cal -y -m"
## neovim
alias vim="nvim"
## yabai toggle
alias stopyabai="brew services stop yabai"
alias startyabai="brew services start yabai"
# ---------------------------------------------------------------------


# Functions
# ---------------------------------------------------------------------

# Startup greeter
function fish_greeting
    # neofetch --ascii_distro Arcolinux_small --disable gpu de kernel packages
    # neofetch --disable gpu term de wm kernel packages model distro shell resolution cols --memory_percent on 
    neofetch --cpu_temp on  --disable gpu term de wm kernel packages model distro shell resolution cols cpu --memory_percent on --off
end

# Use vim as default key bindings
function fish_user_key_bindings
  fish_vi_key_bindings
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Function to extract a variety of archives
# usage: extract <file>
function extract
  for arg in $argv
    if test -f $arg
      switch $arg
        case "*tar.bz2" "*.tbz2"
             tar xjf $arg
        case "*tar.gz" "*.tgz"
             tar xzf $arg
        case "*.bz2"
             bunzip2 $arg
        case "*rar"
             unrar x $arg
        case "*.gz"
             gunzip $arg
        case "*.tar"
             tar xf $arg
        case "*.zip"
             unzip $arg
        case "*.Z"
             uncompress $arg
        case "*7z"
             7z x $arg
        case "*.deb"
             ar x $arg
        case "*tar.xz"
             tar xz $arg
        case "*tar.zst"
             tar unzstd $arg
        case "*"
          set_color red
          echo "I don't know how to extract this type of archive: `$arg`"
          set_color normal
      end
    else
        set_color red
        echo "Not a valid file: `$arg`"
        set_color normal
    end
  end
end
# ---------------------------------------------------------------------


# Fish colors
# ---------------------------------------------------------------------
set fish_color_normal white
set fish_color_command blue
set fish_color_keyword yellow
set fish_color_quote green
set fish_color_error red
set fish_color_param purple
# fish_color_redirection
# fish_color_end
# fish_color_comment
set fish_color_selection black
# fish_color_operator
# fish_color_escape
set fish_color_autosuggestion "4c566a"
# fish_color_cwd
# fish_color_user
# fish_color_host
# fish_color_host_remote
# fish_color_cancel
# fish_color_search_match
# ---------------------------------------------------------------------


# PATH
# TODO fix this
# function start_agent {
#     echo "Initialising new SSH agent..."
#     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
#     echo succeeded
#     chmod 600 "${SSH_ENV}"
#     . "${SSH_ENV}" > /dev/null
#     /usr/bin/ssh-add;
# }

# # Source SSH settings, if applicable

# if [ -f "${SSH_ENV}" ]; then
#     . "${SSH_ENV}" > /dev/null
#     #ps ${SSH_AGENT_PID} doesn't work under cywgin
#     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
#         start_agent;
#     }
# else
#     start_agent;
# fi

# PROMPT (starship https://github.com/starship/starship)

# pyenv setup
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - | source
eval "$(pyenv virtualenv-init -)"

# startship
starship init fish | source
