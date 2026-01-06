{
  inputs,
  pkgs,
  ...
}: {
  # Python development stuff
  home.sessionVariables = {
    PYTHONBREAKPOINT = "pdb.set_trace";
    PYTHONSTARTUP = "$HOME/.config/python/pythonrc.py";
  };

  home.packages = [
    pkgs.uv
    pkgs.ruff
    pkgs.ty
  ];

  home.file.".pdbrc.py" = {source = ./pdbrc.py;};
  # xdg.configFile."python/pythonrc.py" = {source = ./config/python/pythonrc.py;};
}
