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
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  # qt = {
  #   enable = true;
  #   style.name = "adwaita-dark";
  #   platformTheme.name = "adwaita";
  # };
}
