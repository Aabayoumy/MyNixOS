{
  pkgs,
  host,
  inputs,
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
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
