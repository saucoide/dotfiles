# Get most envvars from profile (requires oh-my-fish & fenv installed)
fenv source "$HOME/.profile"

# PATH
# ---------------------------------------------------------------------
fish_add_path --prepend "$HOME/bin"
fish_add_path --prepend "$HOME/.local/bin"
fish_add_path --prepend "$HOME/.emacs.d/bin"
fish_add_path --prepend "$HOME/.poetry/bin"
fish_add_path --prepend "/usr/bin/"
fish_add_path --prepend "/usr/local/bin"
fish_add_path --prepend "$HOME/scripts"
fish_add_path --prepend "$HOME/.nix-profile/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.fish.inc' ]; . '$HOME/google-cloud-sdk/path.fish.inc'; end
# ---------------------------------------------------------------------

# Environment Variables
# ---------------------------------------------------------------------
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
## docker/podman
alias docker="podman"
alias docker-compose="podman-compose"
alias podman-into-bash='podman run --tty --interactive --entrypoint="/bin/bash"'
alias podman-into-shell='podman run --tty --interactive --entrypoint="/bin/sh"'
## kubectl
alias k="kubectl"
alias kn="kube_namespace"
alias kc="kube_context"
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

# Kubernetes utility functions
function kube_namespace --wraps "kubectl get namespaces"
  if test (count $argv) -gt 0
    set namespace $argv[1]
    set -e argv[1]
    kubectl config set-context --current --namespace=$namespace $argv
  else
    kubectl get namespaces
  end
end

function kube_context --wraps "kubectl config use-context"
  if test (count $argv) -gt 0
    set context $argv[1]
    set -e argv[1]
    kubectl config use-context $context $argv
  else
    kubectl config get-contexts
  end
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


function vterm_printf;
    if begin; [  -n "$TMUX" ]  ; and  string match -q -r "screen|tmux" "$TERM"; end 
        # tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$argv"
    else if string match -q -- "screen*" "$TERM"
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$argv"
    else
        printf "\e]%s\e\\" "$argv"
    end
end

function vterm_prompt_end;
    vterm_printf '51;A'(whoami)'@'(hostname)':'(pwd)
end

functions --copy fish_prompt vterm_old_fish_prompt

function fish_prompt --description 'Write out the prompt; do not replace this. Instead, put this at end of your file.'
    # Remove the trailing newline from the original prompt. This is done
    # using the string builtin from fish, but to make sure any escape codes
    # are correctly interpreted, use %b for printf.
    printf "%b" (string join "\n" (vterm_old_fish_prompt))
    vterm_prompt_end
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

# pyenv setup
# set -Ux PYENV_ROOT $HOME/.pyenv
# fish_add_path $PYENV_ROOT/bin
# pyenv init - | source
# eval "$(pyenv virtualenv-init -)"

# direnv setup
direnv hook fish | source

# startship
starship init fish | source
