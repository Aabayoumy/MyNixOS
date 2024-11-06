{
  config,
  pkgs,
  ...
}: let
  # Thanks: https://github.com/DanielFGray/dotfiles/blob/master/tmux.remote.conf
  remoteConf = builtins.toFile "tmux.remote.conf" ''
    unbind C-q
    unbind q
    set-option -g prefix C-a
    bind s send-prefix
    bind C-a last-window
    set-option -g status-position bottom
    set -sg escape-time 50
  '';
in {
  # imports = [
  # ];

  programs.tmux = {
    enable = true;
    shortcut = "a";
    escapeTime = 10;
    baseIndex = 1;
    # keyMode = "vi";
    terminal = "tmux-256color";
    historyLimit = 50000;

    extraConfig = with config.theme;
    with pkgs.tmuxPlugins; ''
      # Plugins
      run-shell '${copycat}/share/tmux-plugins/copycat/copycat.tmux'
      run-shell '${sensible}/share/tmux-plugins/sensible/sensible.tmux'
      run-shell '${urlview}/share/tmux-plugins/urlview/urlview.tmux'
      run-shell 'git clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux'

      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_number_position "right"

      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W "

      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W "

      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator ""
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"

      set -g @catppuccin_directory_text "#{pane_current_path}"
      set -g status-left ""
      set -g  status-right "#{E:@catppuccin_status_directory}"
      # set -ag status-right "#{E:@catppuccin_status_user}"
      set -ag status-right "#{E:@catppuccin_status_host}"
      # set -ag status-right "#{E:@catppuccin_status_session}"

      run-shell ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux
      bind-key R run-shell ' \
        tmux source-file /etc/tmux.conf > /dev/null; \
        tmux display-message "sourced /etc/tmux.conf"'

      if -F "$SSH_CONNECTION" "source-file '${remoteConf}'"


      # Be faster switching windows
      bind -n C-Left  previous-window
      bind -n C-Right next-window

      # Send the bracketed paste mode when pasting
      bind ] paste-buffer -p

      set-option -g set-titles on

      bind C-y run-shell ' \
        ${pkgs.tmux}/bin/tmux show-buffer > /dev/null 2>&1 \
        && ${pkgs.tmux}/bin/tmux show-buffer | ${pkgs.xsel}/bin/xsel -ib'

      # Force true colors
      set-option -ga terminal-overrides ",*:Tc"

      set-option -g mouse on
      set-option -g focus-events off

      # Stay in same directory when split
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      # Scrolling shortcuts
      bind -T copy-mode-vi C-u send-keys -X half-page-up
      bind -T copy-mode-vi C-d send-keys -X half-page-down
    '';
  };
}
