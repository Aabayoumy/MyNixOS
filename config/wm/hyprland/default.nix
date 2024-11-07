{
  pkgs,
  host,
  ...
}: let
  inherit (import ../../../hosts/${host}/variables.nix) hyprlandbar bartheme;
in {
  imports = [
    ./hyprland.nix
    ./pyprland.nix
    ./swaync.nix
    ./${hyprlandbar}.${bartheme}/default.nix
    ./wlogout.nix
  ];

  home.file.".config/hyprland/wlogout/icons" = {
    source = ./wlogout;
    recursive = true;
  };
}
