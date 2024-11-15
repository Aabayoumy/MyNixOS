{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./git.nix
    ./fzf.nix
    ./fastfetch
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraOptions = ["-l" "--icons" "--git" "-a"];
  };

  programs.bat = {enable = true;};

  home.packages = with pkgs; [
    coreutils
    fd
    htop
    httpie
    jq
    procs
    ripgrep
    tldr
    zip
    unzip
  ];

  home.file.".config" = {
    source = ./config;
    recursive = true;
  };
}
