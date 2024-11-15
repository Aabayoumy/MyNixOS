{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    extraConfig = builtins.readFile ./kitty.conf;
  };
  stylix.targets.kitty.enable = true;
}
