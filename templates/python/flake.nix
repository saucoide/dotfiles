{
  description = "Python Devshell Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    let

      systems = [
        "aarch64-darwin"
        # "x86_64-darwin"
        # "aarch64-linux"
        "x86_64-linux"
      ];
      # forAllSystems is a function that takes a function as param, and returns
      # that functions return value undear each key in "systems"
      # Example:
      #      devShells = forAllSystems (pkgs: { default = pkgs.mkShell { stuff } } )
      # Turns into:
      #     devShells = {
      #         x86_64-linux.default = pkgs.mkShell { stuff }
      #         aarch64-darwin.default = pkgs.mkShell { stuff }
      #     };
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      # define custom scripts
      customScripts = pkgs: {
        do-something = pkgs.writeShellScriptBin "do-something" ''echo "doing stuff" '';
        serve = pkgs.writeShellScriptBin "serve" "uvicorn main.app:app --host=0.0.0.0 --port=8080 --reload ";
      };

    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          # Packages
          packages = [
            pkgs.python313Packages.python
            pkgs.just
          ]
          ++ (builtins.attrValues (customScripts pkgs)); # append scripts to the package list

          # Environment Variables
          env =
            let
              PROJECT_ROOT = builtins.getEnv "PWD";
            in
            {
              VIRTUAL_ENV = PROJECT_ROOT + "/.venv";
              PYTHONPATH = PROJECT_ROOT;
              MYPYPATH = PROJECT_ROOT;
            };

          inputsFrom = [ ];
          shellHook = ''
            export MAH_PASSWORD="$(pass mah/password)"
          '';
        };
      });
    };
}
