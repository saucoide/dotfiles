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
alias cal="cal -y"
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
alias kinto="kube_shell_into_pod"
# gcloud
alias gcp="gcloud_change_project"
alias gc="gcloud"
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

function kube_shell_into_pod --wraps "kubectl get pods"
  if test (count $argv) -gt 0
    kubectl exec --stdin --tty $argv[1] -- /bin/bash
  else
    kubectl get pods
  end
end

function gcloud_change_project --wraps "gcloud config set project"
  if test (count $argv) -gt 0
    set project $argv[1]
    set -e argv[1]
    gcloud config set project $project $argv
  else
    gcloud projects list
  end
end


function ai --argument action
  # read from stdin
  read -l -z input
  
  switch $action
    case "explain"
      set system_prompt "
        You are very experienced and knowledgable software developer, expert in the domain.
        Your goal is to explain to newer developers the functionality of existing code.
        You provide simple and concise explanations, using plain english and using jargon only if absolutely necessary.
        Please explain to a new joiner what the code does, and how it is implemented."
      set prompt $input
    case "rewrite"
      set system_prompt "
        You are very experienced and knowledgable software developer, expert in the domain.
        Your must rewrite the code given improving its readability, performance and testability.
        You lean towards functional patterns, but not strictly so, if something is
        better left non functional, you are pragmatic and always choose the best
        solution.
        Choose pythonic list comprehensions or generators, instead of maps/reduce when sensible.
        You must produce high quality and readable code, that's easy to test."
      set prompt $input
    case "complete"
      set system_prompt "
        You are very experienced and knowledgable software developer, expert in the domain.
        Your must finish the unfinished sections that have been marked with '# AI'.
        You must adhere to the existing style, and not make any modifications to the
        sections that have not been marked.
        You must produce high quality and readable code, that's easy to test.

        INPUT:
        @dataclass
        class Email:
          address: str
          content: str
          priority: str
        
        @dataclass
        class SMS:
          phone_numer: int
          content: str
          priority: str
        
        @dataclass
        class Letter:
          address: str
          content: str
          priority: str

        # AI add phone call 
        
        Notification = Email | SMS | Letter | PhoneCall

        def send_notification(notification: Notification):
            match notification:
              case Email():
                send_email(
                  address_to=notification.address,
                  content=notification.content,
                  priority=notification.priority,
                )
              case SMS():
                send_sms(
                  phone_number=notification.phone_number,
                  content=notification.content,
                  priority=notification.priority,
                )
              case Letter():
                send_letter(
                  address_to=notification.address,
                  address_from='sender_address',
                  content=notification.content,
                  priority=notification.priority,
                )
            
              # AI add missing cases


        OUTPUT:
        @dataclass
        class Email:
          address: str
          content: str
          priority: str
        
        @dataclass
        class SMS:
          phone_numer: int
          content: str
          priority: str
        
        @dataclass
        class Letter:
          address: str
          content: str
          priority: str

        @dataclass
        class PhoneCall:
          phone_number: str
          content: str
          priority: str
        
        Notification = Email | SMS | Letter | PhoneCall | None

        def send_notification(notification: Notification):
            match notification:
              case Email():
                send_email(
                  address_to=notification.address,
                  content=notification.content,
                  priority=notification.priority,
                )
              case SMS():
                send_sms(
                  phone_number=notification.phone_number,
                  content=notification.content,
                  priority=notification.priority,
                )
              case Letter():
                send_letter(
                  address_to=notification.address,
                  address_from='sender_address',
                  content=notification.content,
                  priority=notification.priority,
                )
            
              case Phonecall():
                send_phone_call(
                  phone_number=notification.address,
                  content=notification.content,
                  priority=notification.priority,
                )
                
              case _:
                # No notification
                pass
        "
      set prompt "INPUT:\n$input" 
    case "fix"
      set system_prompt "
        You are very experienced and knowledgable software developer, expert in the domain.
        Your must fix the code in the sections that have been marked with '# AI FIX'.
        You must adhere to the existing style, and not make any modifications to the
        sections that have not been marked.
        You must produce high quality and readable code, that's easy to test.
        If there is nothing wrong with the code, do not modify it, and return it as is.
        If there is something wrong to be fixed, fix it and add a short comment
        explaining the fix.
        Produce only valid code, do not talk, only add comments as comments within the code
        all output should be valid code.

        INPUT:
        def add_to_queue(item, queue=None):
            queue = queue or []
            queue.append(name)
            return queue

        def refresh_queue(queue):
            new_items = get_new_items(from=last_catchup)
            for item in new_items:
                add_to_queue(item)
            # AI FIX
            flag_invalid = [
                item if valid_item(item) else False for item in queue
            ]
        

        OUTPUT:
        def add_to_queue(item, queue=None):
            queue = queue or []
            queue.append(name)
            return queue

        def refresh_queue(queue):
            new_items = get_new_items(from=last_catchup)
            for item in new_items:
                add_to_queue(item)
            flag_invalid = [
                item for item in queue if valid_item(item) else False  # Fixed the previous as it was not valid syntax
            ]
        "
      set prompt "INPUT:\n$input" 
         
    case "critique"
      set system_prompt "
        You are very experienced and knowledgable software developer, expert in the domain.
        You must review the code provided, critizing it if needed, point out areas of
        improvement, and any flaws or source of errors you can spot.
        Be concise and to the point, use plain english"
      set prompt $input
    case "tests"
      set system_prompt "
        You are very experienced and knowledgable software developer, expert in testing.
        You must produce tests for the code provided, aim for good coverage.
        You have a strong preference for end to end and integration tests, avoid using
        mocks except when necessary, and use stubs or fakes in their place when possible.
        Unit tests are acceptable when useful, but you should also aim to have end to
        end tests.
        You follow the 'dont mock what you dont own' principle.
        If a piece of code would be better tested if we modified it, propose the
        modification and the test that would go with it"
      set prompt $input
    case "*"
      set system_prompt $argv
      set prompt $input
         
  end
  echo $input
  echo ""
  echo "=== LLM ==="
  echo ""
  llm prompt --system "$system_prompt" $prompt
  echo ""
  echo "=== LLM END ==="
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
