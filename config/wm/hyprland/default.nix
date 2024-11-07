{
  pkgs,
  host,
  ...
}: let
  inherit (import ../../../hosts/${host}/variables.nix) hyprlandbar bartheme;
in {
  imports = [
    ./emoji.nix
    ./hyprland.nix
    ./pyprland.nix
    ./rofi/rofi.nix
    ./rofi/config-emoji.nix
    ./rofi/config-long.nix
    ./swaync.nix
    ./${hyprlandbar}.${bartheme}/default.nix
    ./wlogout.nix
  ];

  home.file.".config/hyprland/wlogout/icons" = {
    source = ./wlogout;
    recursive = true;
  };
}
