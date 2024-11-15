{
  config,
  pkgs,
  host,
  lib,
  username,
  options,
  ...
}: let
  inherit (import ./variables.nix) keyboardLayout wm;
in {
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/amd-drivers.nix
    ../../modules/nvidia-drivers.nix
    ../../modules/libvirt.nix
    ../../modules/games.nix
    ../../modules/net-share.nix
    # ../../modules/nvidia-prime-drivers.nix
    # ../../modules/intel-drivers.nix
    # ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
    ./wm/${wm}
  ];

  zramSwap.enable = true;

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_zen;
    # This is for OBS Virtual Cam Support
    kernelModules = ["v4l2loopback"];
    extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = ["zfs"];
    zfs.forceImportRoot = false;
    zfs.extraPools = ["tank"];

    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };
  nixpkgs.config.allowBroken = true;
  # Styling Options
  stylix = {
    enable = true;
    image = ../../config/wallpapers/nix-wallpaper-stripes-logo.png;
    # image = config.lib.stylix.pixel "base0A";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-latte.yaml";
    ## Tokyodark
    base16Scheme = {
      base00 = "11121d";
      base01 = "212234";
      base02 = "212234";
      base03 = "353945";
      base04 = "4a5057";
      base05 = "a0a8cd";
      base06 = "abb2bf";
      base07 = "bcc2dc";
      base08 = "ee6d85";
      base09 = "f6955b";
      base0A = "d7a65f";
      base0B = "95c561";
      base0C = "9fbbf3";
      base0D = "7199ee";
      base0E = "a485dd";
      base0F = "773440";
    };

    opacity.terminal = 0.9;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  # Extra Module Options
  drivers.nvidia.enable = true;
  drivers.amdgpu.enable = true;
  local.hardware-clock.enable = false;

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = host;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    hostId = "4ef51e95";
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "1.1.1.3"
    ];
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "none";
    defaultGateway = "10.0.0.1";
    firewall.enable = false;
    firewall.allowPing = true;
    #syncThing
    firewall.allowedTCPPorts = [8384 22000];
    firewall.allowedUDPPorts = [22000 21027];
  };
  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  security.sudo.wheelNeedsPassword = false;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    firefox.enable = false;
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs; # only for NixOS 24.05
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = false;
    steam = {
      enable = false;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
  };

  environment.systemPackages = with pkgs; [
    gcal
    micro
    xsel
    # vscodium
    vscode
    wget
    killall
    eza
    git
    cmatrix
    lolcat
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    v4l-utils
    ydotool
    duf
    ncdu
    pciutils
    ffmpeg
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    meson
    ninja
    brightnessctl
    swappy
    appimage-run
    networkmanagerapplet
    yad
    inxi
    playerctl
    nh
    nixfmt-rfc-style
    discord
    grim
    slurp
    file-roller
    imv
    mpv
    wev
    galculator
    gimp
    pavucontrol
    tree
    spotify
    starship
    zip
    unzip
    rsync
    dtrx
    base16-schemes
    obsidian
    syncthing
    # kdePackages.sddm-kcm
    # elegant-sddm
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      # Commenting Symbola out to fix install this will need to be fixed or an alternative found.
      # symbola
      material-icons
    ];
  };

  environment.variables = {
    ZANEYOS_VERSION = "2.2";
    ZANEYOS = "true";
    NIXOS_OZONE_WL = "1";
    ROC_ENABLE_PRE_VEGA = "1";
    # Required to run the correct GBM backend for nvidia GPUs on wayland
    #GBM_BACKEND = "nvidia-drm";
    # Apparently, without this nouveau may attempt to be used instead
    # (despite it being blacklisted)
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # Hardware cursors are currently broken on nvidia
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
    config.hyprland = {
      default = [
        "wlr"
        "gtk"
      ];
    };
  };
  # Services to start

  services = {
    btrfs.autoScrub.enable = true;
    btrfs.autoScrub.interval = "weekly";
    zfs.autoScrub.enable = true;
    udisks2.enable = true;
    udisks2.mountOnMedia = true;
    xserver = {
      enable = false;
      videoDrivers = ["amdgpu"];
      xkb = {
        layout = "us,ara";
        # variant = "digits";
        options = "alt_shift_toggle,caps:escape";
      };
    };

    openssh = {
      enable = true;
      ports = [22];
      openFirewall = true;
      settings = {
        PasswordAuthentication = true;
        AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };
    syncthing = {
      enable = true;
      user = "${username}";
      dataDir = "/tank/data/syncthing";
      configDir = "/tank/data/syncthing/.config";
      overrideDevices = false; # overrides any devices added or deleted through the WebUI
      overrideFolders = false; # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "gb-abayoumy" = {id = "QMCXML2-VQNKDOY-XCWDUVX-PGO6P43-XRE4T3R-HS4IM4Z-MSJ5CTJ-WZIDTQJ";};
        };
        # folders = {
        #   "obsidian" = {
        #     # Name of folder in Syncthing, also the folder ID
        #     path = "/tank/data/syncthing/obsidian"; # Which folder to add to Syncthing
        #     devices = ["gb-abayoumy"]; # Which devices to share the folder with
        #   };
        # "Example" = {
        #   path = "/home/myusername/Example";
        #   devices = ["device1"];
        #   ignorePerms = false; # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
        # };
        # };
      };
    };

    # displayManager = {
    #   # defaultSession = "plasma";
    #   sddm = {
    #     enable = true;
    #     theme = "Elegant";
    #     autoNumlock = true;
    #     wayland = {
    #       enable = true;
    #       compositor = "kwin";
    #     };
    #   };
    # };

    smartd = {
      enable = false;
      autodetect = true;
    };
    timesyncd.enable = true;
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    devmon.enable = true;
    flatpak.enable = true;
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  systemd.services.zfs-mount.enable = true;
  systemd.services.flatpak-repo = {
    path = [pkgs.flatpak];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  hardware.sane = {
    enable = true;
    extraBackends = [pkgs.sane-airscan];
    disabledDefaultBackends = ["escl"];
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth Support
  hardware.bluetooth.enable = false;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.rocmPackages.clr
      pkgs.rocmPackages.rocm-smi
    ];
  };

  console.keyMap = "en";

  system.autoUpgrade.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}
