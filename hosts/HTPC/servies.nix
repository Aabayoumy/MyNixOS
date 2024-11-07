{
  config,
  pkgs,
  username,
  host,
  ...
}: {
  services.plex = {
    enable = true;
    openFirewall = true;
    user = "${username}";
    group = "users";
    dataDir = "/media/MediaHDD/HTPC/plex";
  };
  services.sonarr = {
    enable = true;
    openFirewall = true;
    user = "${username}";
    group = "users";
    dataDir = "/media/MediaHDD/HTPC/sonarr";
  };
  services.radarr = {
    enable = true;
    openFirewall = true;
    user = "${username}";
    group = "users";
    dataDir = "/media/MediaHDD/HTPC/radarr";
  };
}
