{
  config,
  pkgs,
  lib,
  host,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) gitUsername gitEmail;
in {
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
    extraConfig = {
      init.defaultBranch = "main";
      # safe.directory = [
      #   ("/home/" + userSettings.username + "/.dotfiles")
      #   ("/home/" + userSettings.username + "/.dotfiles/.git")
      # ];
    };
    aliases = {
      acp = "add -A && commit -m '$@' && push";
    };
  };
}
