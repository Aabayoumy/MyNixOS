# source https://haseebmajid.dev/posts/2024-01-05-part-4-wezterm-terminal-as-part-of-your-development-workflow/
{
  input,
  config,
  lib,
  pkgs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    package = pkgs.wezterm;
    extraConfig = builtins.readFile ./config.lua;
  };
}
