# PATH
# ---------------------------------------------------------------------
# fish_add_path --prepend "~/.bin"
# fish_add_path --prepend "~/.local/bin"
# fish_add_path --prepend "~/.emacs.d/bin"
# fish_add_path --prepend "~/.poetry/bin"
# fish_add_path --prepend "~/.local/share/coursier/bin"
# # ---------------------------------------------------------------------

# # Environment Variables
# # ---------------------------------------------------------------------
# set VISUAL "emacsclient -c -a ''"
# set EDITOR "emacsclient -t -a ''"
# set SSH_ENV "$HOME/.ssh/agent-environment"

# # Aliases
# # ---------------------------------------------------------------------
# ## List - using exa as a replacement for ls 
alias ls="lsd --long --color=always --group-dirs=first --date '+%Y-%m-%d %H:%M'"
alias lsa="lsd --long --almost-all --group-dirs=first --date '+%Y-%m-%d %H:%M'"
alias lst="lsd --long --tree --depth=2 --color=always --date '+%Y-%m-%d %H:%M'"
# ## pbcopy pbpaste alias
# alias pbcopy="xclip -selection clipboard"
# alias pbpaste="xclip -selection clipboard -o"
# neovim
alias vim="nvim"
# ## a better cat
alias cat="bat"
# ## I always miss the space
alias cd..="cd .."
# ## Colorize the grep command output 
alias grep='grep --color=auto'
# ## File system space info in readable format
alias df='df --human-readable'
# ## Memory info 
alias free="free -mt"
# ## Continue download
alias wget="wget -c"
# ## Userlist
alias userlist="cut -d: -f1 /etc/passwd"
# ## Aliases for software managment
# ### Pacman
# alias pacman='sudo pacman --color auto'
# alias update='sudo pacman -Syyu'
# ### Cleanup orphaned packages
# alias cleanup='sudo pacman -Rns (pacman -Qtdq)'
# ### Yay as aur helper - updates everything
# alias yayupdate="yay -Syu"
# ### Mirror updates
alias mirrors="sudo reflector --latest 50 --sort rate --save /etc/pacman.d/mirrorlist"
# ## Calendar show full year
# alias cal="cal -y -m"
# # ---------------------------------------------------------------------

# # Functions
# # ---------------------------------------------------------------------

# # Startup greeter
# function fish_greeting
#     ""
# end

# # Use vim as default key bindings
function fish_user_key_bindings
  fish_vi_key_bindings
end

# # Function for creating a backup file
# # ex: backup file.txt
# # result: copies file as file.txt.bak
# function backup --argument filename
#     cp $filename $filename.bak
# end

# # Function to extract a variety of archives
# # usage: extract <file>
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

function pesel
  pass pesel | pbcopy
end

function weather
  ~/.config/fish/scripts/weather.sh
end

function webcam
  ~/.config/fish/scripts/webcam.sh
end
# # ---------------------------------------------------------------------


# # Fish colors
# # ---------------------------------------------------------------------
set fish_color_normal white
set fish_color_command blue
set fish_color_keyword yellow
set fish_color_quote green
set fish_color_error red
set fish_color_param purple
# # fish_color_redirection
# # fish_color_end
# # fish_color_comment
set fish_color_selection black
# # fish_color_operator
# # fish_color_escape
set fish_color_autosuggestion "4c566a"
# # fish_color_cwd
# # fish_color_user
# # fish_color_host
# # fish_color_host_remote
# # fish_color_cancel
# # fish_color_search_match
# # ---------------------------------------------------------------------


# # PATH
# # TODO fix this
# # function start_agent {
# #     echo "Initialising new SSH agent..."
# #     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
# #     echo succeeded
# #     chmod 600 "${SSH_ENV}"
# #     . "${SSH_ENV}" > /dev/null
# #     /usr/bin/ssh-add;
# # }

# # # Source SSH settings, if applicable

# # if [ -f "${SSH_ENV}" ]; then
# #     . "${SSH_ENV}" > /dev/null
# #     #ps ${SSH_AGENT_PID} doesn't work under cywgin
# #     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
# #         start_agent;
# #     }
# # else
# #     start_agent;
# # fi

# PROMPT (starship https://github.com/starship/starship)
starship init fish | source
