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
      hms = "sudo darwin-rebuild switch --flake ~/dotfiles";
      hmsoff = "sudo darwin-rebuild switch --flake ~/dotfiles --offline --option substitute false";

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
      podmanbash = "podman run --tty --interactive --entrypoint='/bin/bash'";

      # kubectl
      k = "kubectl";
      kc = "kube_context";
      kn = "kube_namespace";
      kshell = "kube_shell_into_pod";

      # gcloud
      gcp = "gcloud_change_project";
      gc = "gcloud";
      gcs = "gcloud storage";

      # others
      "cd.." = "cd ..";
      vim = "nvim";
      cat = "bat";
      imgcat = "wezterm imgcat";
      grep = "grep --color=auto";
      df = "df --human-readable";
      # free = "free -mt";
      wget = "wget -c";
      userlist = "cut -d: -f1 /etc/passwd";
      cal = "cal -y";
    };

    functions = {
      fish_user_key_bindings = ''
        fish_vi_key_bindings
        # bind -M insert -m default ` force-repaint
      '';

      fish_greeting = "";

      beepin = ''
        set sleep_time 0
        if test (count $argv) -ge 1
            set sleep_time $argv[1]
        end

        sleep $sleep_time

        for i in (seq 1 3)
            echo -e "\a"
            sleep 0.1
        end
      '';

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
    };
  };
}
