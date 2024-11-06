{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    extraConfig = builtins.readFile ./kitty.conf;
    # settings = {
    #   copy_on_select = "clipboard";
    #   scrollback_lines = 2000;
    #   wheel_scroll_min_lines = 1;
    #   window_padding_width = 4;
    #   confirm_os_window_close = 0;
    #   cursor_shape = "beam";
    #   cursor_beam_thickness = 10.0;
    #   cursor_blink_interval = -1;
    #   mouse_hide_wait = 2.0;

    #   tab_bar_min_tabs = 1;
    #   tab_bar_edge = "bottom";
    #   tab_bar_style = "powerline";
    #   tab_powerline_style = "slanted";
    #   tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    # };
    # extraConfig = ''
    #   tab_bar_style fade
    #   tab_fade 1
    #   active_tab_font_style   bold
    #   inactive_tab_font_style bold
    #   map ctrl+a>c  new_tab_with_cwd
    #   map ctrl+a>x  close_tab
    #   map ctrl+a>r  set_tab_title
    #   map ctrl+a>ctrl+a previous_tab
    #   map ctrl+a>1  goto_tab 1
    #   map ctrl+a>2  goto_tab 2
    #   map ctrl+f5   load_config_file

    #   map ctrl+shift+page_up scroll_page_up
    #   map cmd+page_up scroll_page_up

    #   map ctrl+shift+page_down scroll_page_down
    #   map cmd+page_down scroll_page_down
    # '';
  };
}
