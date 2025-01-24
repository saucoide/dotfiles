{
  inputs,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    generateCompletions = true;

    interactiveShellInit = ''
      # Get most envvars from .profile (requires oh-my-fish & fenv)
      # fenv source $HOME/.profile   # TODO .profile
      source $HOME/dotfiles/.private_envvars
    '';
    shellAliases = {
      # nix
      hms = "darwin-rebuild switch --flake ~/dotfiles";

      # vim
      v = "nvim";

      # lsd
      ls = "lsd --long --group-dirs=first --date '+%Y-%m-%d %H:%M'";
      lsa = "lsd --long --group-dirs=first --almost-all --date '+%Y-%m-%d %H:%M'";
      lst = "lsd --long --group-dirs=first --tree --depth=2 --date '+%Y-%m-%d %H:%M'";

      # podman
      docker = "podman";
      docker-compose = "podman-compose";
      podmansh = "podman run --tty --interactive --entrypoint='/bin/sh'";

      # kubectl
      k = "kubectl";
      kc = "kube_context";
      kn = "kube_namespace";
      kinto = "kube_shell_into_pod";

      # gcloud
      gcp = "gcloud_change_project";
      gc = "gcloud";

      # others
      "cd.." = "cd ..";
      vim = "nvim";
      cat = "bat";
      grep = "grep --color=auto";
      df = "df -H";
      # free = "free -mt";
      wget = "wget -c";
      userlist = "cut -d: -f1 /etc/passwd";
      cal = "cal -y";
    };

    # TODO bring all my fish functions
    functions = {
      fish_user_key_bindings = ''
        fish_vi_key_bindings
      '';

      fish_greeting = "";

      kube_namespace = {
        wraps = "kubectl get namespace";
        body = ''
          if test (count $argv) -gt 0
            set namespace $argv[1]
            set -e argv[1]
            kubectl config set-context --current --namespace=$namespace $argv
          else
            kubectl get namespaces
          end
        '';
      };

      kube_context = {
        wraps = "kubectl config use-context";
        body = ''
          if test (count $argv) -gt 0
            set context $argv[1]
            set -e argv[1]
            kubectl config use-context $context $argv
          else
            kubectl config get-contexts
          end
        '';
      };

      kube_shell_into_pod = {
        wraps = "kubectl get pods";
        body = ''
          if test (count $argv) -gt 0
            kubectl exec --stdin --tty $argv[1] -- /bin/bash
          else
            kubectl get pods
          end
        '';
      };

      gcloud_change_project = {
        wraps = "gcloud config set project";
        body = ''
          if test (count $argv) -gt 0
            set project $argv[1]
            set -e argv[1]
            gcloud config set project $project $argv
          else
            gcloud projects list
          end
        '';
      };

      extract = ''
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
      '';
      ai = {
        argumentNames = "action";
        body = ''
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
        '';
      };
    };
  };
}
