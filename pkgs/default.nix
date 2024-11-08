{pkgs, ...}: {
  # Define your custom packages here
  # wezterm-nightly = pkgs.callPackage ./wezterm-nightly {};
  # update-input = pkgs.callPackage ./update-input {};
  tiling-shell = pkgs.callPackage ./tiling-shell {};
}
