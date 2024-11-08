{
  config,
  pkgs,
  ...
}: {
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
  ];
  environment.systemPackages = with pkgs; [
    kdePackages.kaccounts-integration
    kdePackages.kaccounts-providers
    kdePackages.packagekit-qt
    kdePackages.kde-gtk-config
    kdePackages.qtstyleplugin-kvantum
    libportal-qt6
    polonium
  ];
  services.desktopManager.plasma6.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
}
