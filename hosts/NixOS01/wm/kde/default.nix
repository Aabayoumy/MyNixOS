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
    kdePackages.qt6ct
    libportal-qt6
    kde-gtk-config
    polonium
    utterly-nord-plasma
  ];
  nixpkgs.config.qt5 = {
    enable = true;
    platformTheme = "qt5ct";
    style = {
      package = pkgs.utterly-nord-plasma;
      name = "Utterly Nord Plasma";
    };
  };
  services.desktopManager.plasma6.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
}
