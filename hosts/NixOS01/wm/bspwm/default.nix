{
  config,
  pkgs,
  ...
}: {
  services.xserver.displayManager.defaultSession = "none+bspwm";
  services.xserver.windowManager.bspwm.enable = true;

  environment.systemPackages = with pkgs; [
    polybar
    picom
    networkmanagerapplet
    numlockx
    volumeicon
    nitrogen
  ];
}
