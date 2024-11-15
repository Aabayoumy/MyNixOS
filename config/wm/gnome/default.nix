{
  config,
  pkgs,
  lib,
  ...
}: {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org.gnome.desktop.peripherals.keyboard".numlock-state = "true";
      "org.gnome.desktop.wm.keybindings".switch-input-source = "['<Shift>Alt_L']"; 

      "org/gnome/shell" = {
        favorite-apps = ["librewolf.desktop" "code.desktop" "kitty.desktop" "org.gnome.Nautilus.desktop" "org.gnome.tweaks.desktop"];
        disable-user-extensions = false; # enables user extensions
        # enabled-extensions = [
        #   # Put UUIDs of extensions that you want to enable here.
        #   # If the extension you want to enable is packaged in nixpkgs,
        #   # you can easily get its UUID by accessing its extensionUuid
        #   # field (look at the following example).
        #   "pkgs.gnomeExtensions.gsconnect.extensionUuid"
        #   # "dash-to-panel@jderose9.github.com"
        #   # Alternatively, you can manually pass UUID as a string.
        #   # "blur-my-shell@aunetx"
        #   # ...
        # ];
      };

      # Configure individual extensions
      # "org/gnome/shell/extensions/blur-my-shell" = {
      #   brightness = 0.90;
      #   noise-amount = 0;
      # };
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    # theme = {
    #   name = "adw-gtk3-dark";
    #   package = pkgs.adw-gtk3;
    # };
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
