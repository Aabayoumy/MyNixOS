{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  services = {
    # Network shares
    samba = {
      package = pkgs.samba4Full;
      # ^^ `samba4Full` is compiled with avahi, ldap, AD etc support (compared to the default package, `samba`
      # Required for samba to register mDNS records for auto discovery
      # See https://github.com/NixOS/nixpkgs/blob/592047fc9e4f7b74a4dc85d1b9f5243dfe4899e3/pkgs/top-level/all-packages.nix#L27268
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "abayoumytech";
          "server string" = "abayoumypc";
          "netbios name" = "abayoumypc";
          # "interfaces" = "br0 enp5s0 lo";
          # "bind interfaces only" = "yes";
        };
        data = {
          path = "/tank/data";
          writable = "true";
          comment = "zfs data";
        };
      };
    };
    avahi = {
      publish.enable = true;
      publish.userServices = true;
      # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
      nssmdns4 = true;
      # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
      enable = true;
      openFirewall = true;
    };
    samba-wsdd = {
      # This enables autodiscovery on windows since SMB1 (and thus netbios) support was discontinued
      enable = true;
      openFirewall = true;
    };
    nfs.server.enable = true;
    nfs.server.exports = ''
      /tank/data (rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)
      /tank/MediaHDD (rw,all_squash,insecure,async,no_subtree_check,anonuid=1000,anongid=1000)
    '';
  };
  networking.firewall.allowedTCPPorts = [2049];
}
