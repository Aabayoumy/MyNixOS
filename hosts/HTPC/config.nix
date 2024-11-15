# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  pkgs,
  host,
  username,
  options,
  ...
}: let
  inherit (import ./variables.nix) keyboardLayout;
in {
  imports = [
    ./hardware.nix
    ./users.nix
    ./servies.nix
    #    ../../modules/amd-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  zramSwap.enable = true;
  # enable qemu-guest-agentfor proxmox
  services.qemuGuest.enable = true;

  system.autoUpgrade.enable = true;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = host;
  networking.networkmanager.enable = true;

  # disable ipv6
  networking.enableIPv6 = false;

  # Newtwork firwall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22];

  environment.shells = with pkgs; [zsh];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  fonts.fontDir.enable = true;

  services.openssh = {
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
  services.timesyncd.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Timezone and locale
  time.timeZone = "Africa/Cairo"; # time zone
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  vm.guest-services.enable = true;
  local.hardware-clock.enable = false;
  environment.systemPackages = with pkgs; [
    nfs-utils
    zsh
    fd
    starship
    gcal
    micro
    fastfetch
    btop
    cryptsetup
    home-manager
    xdg-user-dirs
    coreutils
    curl
    eza
    thefuck
    findutils
    fzf
    git
    gnumake
    gnutar
    htop
    iproute2
    jq
    killall
    less
    libuuid
    linuxHeaders
    mkpasswd
    netcat
    nettools
    nmap
    openssl
    python3
    python3Packages.pip
    ripgrep
    rsync
    spice-vdagent
    ssh-import-id
    strace
    sysstat
    tealdeer
    tree
    tzdata
    unzip
    util-linux
    wget
    aria2
    yq
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  systemd.tmpfiles.rules = [
    "d /media 0755 root root 10d"
    "d /media/data 0755 abayoumy abayoumy 10d"
    "d /media/MediaHDD 0755 abayoumy abayoumy 10d"
  ];

  fileSystems."/media/data" = {
    device = "10.0.0.15:/media/data";
    fsType = "nfs";
  };
  fileSystems."/media/MediaHDD" = {
    device = "10.0.0.15:/media/MediaHDD";
    fsType = "nfs";
  };
  # nfs services
  services.rpcbind.enable = true;
  services.nfs.server.enable = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}
