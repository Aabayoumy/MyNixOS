{pkgs, ...}: {
  programs.dconf.enable = true;

  services = {
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [pkgs.dconf];
    };

    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    displayManager.defaultSession = "none+xmonad";

    xserver = {
      enable = true;

      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime"     "0"
      '';

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };
  };

  systemd.services.upower.enable = true;
}