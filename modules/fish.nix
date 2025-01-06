{ inputs, pkgs,  ...} : {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Get most envvars from .profile (requires oh-my-fish & fenv)
      # fenv source $HOME/.profile   # TODO .profile
      source $HOME/dotfiles/.private_envvars
    '';
    shellAliases = {
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

    functions = {
      fish_greeting = ''
        neofetch --cpu_temp on --disable gpu term de wm kernel packages distro shell resolution cols cpu --memory_percent on --off
      '';
    };

    generateCompletions = true;
  };
}
