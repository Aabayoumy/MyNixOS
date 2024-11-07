{
  config,
  pkgs,
  ...
}: let
  inherit (import ../../variables.nix) keyboardLayout;
in {
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    xwayland
    wl-clipboard
    waypaper
    hyprpicker
    swww
    swaynotificationcenter
  ];
}
