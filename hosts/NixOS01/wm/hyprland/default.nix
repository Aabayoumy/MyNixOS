{
  config,
  pkgs,
  ...
}: {
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
