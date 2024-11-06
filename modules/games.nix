{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    protonup
    lutris
    wine
  ];
  programs.lutris.enable = true;

  # environment.sessionVariables = {
  #   STEAM_EXTRA_COMPAT_TOOLS_PATHS =
  #     ”\${HOME}/.steam/root/compatibilitytools.d”;
  # };
}
