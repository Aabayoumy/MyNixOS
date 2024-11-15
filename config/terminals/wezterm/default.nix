# source https://haseebmajid.dev/posts/2024-01-05-part-4-wezterm-terminal-as-part-of-your-development-workflow/
{
  input,
  pkgs,
  ...
}: {
  programs.wezterm = {
    enable = true;
    package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig = builtins.readFile ./config.lua;
  };
  stylix.targets.wezterm.enable = true;
}
