{
  config,
  pkgs,
  ...
}: {
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us,ara";
        # variant = "digits";
        options = "alt_shift_toggle,caps:escape";
      };
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    xserver.desktopManager.gnome.enable = true;

    gnome = {
      sushi.enable = true;
      gnome-keyring.enable = true;
      gnome-browser-connector.enable = true;
    };
    udev.packages = [pkgs.gnome-settings-daemon];
  };
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gnome-console
      gnome-maps
    ])
    ++ (with pkgs; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnome-tweaks
    orchis-theme
    # arc-theme
    papirus-icon-theme
    numix-cursor-theme
    adw-gtk3
  ];
}
