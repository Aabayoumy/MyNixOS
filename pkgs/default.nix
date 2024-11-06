{pkgs, ...}: {
  # Define your custom packages here
  wezterm-nightly = pkgs.callPackage ./wezterm-nightly {};
}
