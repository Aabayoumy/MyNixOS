{
  pkgs,
  lib,
  config,
  host,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
  inherit
    (import ../../hosts/${host}/variables.nix)
    terminal
    ;
in
  with lib; {
    options = {
      programs.pyprland = {
        enable = mkEnableOption "pyprland";
        package = mkOption {
          type = types.package;
          default = pkgs.pyprland;
          defaultText = literalExpression "pkgs.pyprland";
          description = "The package to use for pyprland.";
        };
        config = mkOption {
          type = tomlFormat.type;
          description = "Extra configuration options for pyprland";
          default = {};
          defaultText = "{ }";
        };
      };
    };
    config = {
      home.packages = [
        (mkIf config.programs.pyprland.enable config.programs.pyprland.package)
      ];
      xdg.configFile."hypr/pyprland.toml" = {
        enable = config.programs.pyprland.enable;
        source = tomlFormat.generate "pyprland.toml" config.programs.pyprland.config;
      };
      # wayland.windowManager.hyprland.settings.exec-once = [
      #   "${config.programs.pyprland.package}/bin/pypr"
      # ];

      home.file.".config/hypr/pyprland.toml".text = ''
        [pyprland]
        plugins = [
         "expose",
         "fetch_client_menu",
         "lost_windows",
         "magnify",
         "scratchpads",
         "shift_monitors",
         "toggle_special",
         "workspaces_follow_focus",
        ]

        # using variables for demonstration purposes (not needed)
        [pyprland.variables]
        term_classed = "${terminal} --class"

        [scratchpads.term]
        animation = "fromTop"
        command = "[term_classed] main-dropterm"
        class = "main-dropterm"
        unfocus = "hide"
        margin = 50
        lazy = true

        [scratchpads.volume]
        command = "pavucontrol"
        animation = "fromRight"
        lazy = true
        size = "40% 40%"
        unfocus = "hide"
      '';
      home.file.".config/hypr/scratchpads.conf".text =
        ''
          $pyprland = ''
        + config.programs.pyprland.package
        + ''          /bin/pypr
                              exec-once = $pyprland --debug /tmp/pypr.log
                              bind = SUPER,SPACE, exec, $pyprland toggle term                  # toggles the "term" scratchpad visibility
                              bind = SUPER CTRL, V, exec, $pyprland toggle volume && hyprctl dispatch bringactivetotop

                              $scratchpadsize = size 80% 85%
                              $scratchpad = class:^(main-dropterm)$
                              windowrulev2 = float,$scratchpad
                              windowrulev2 = $scratchpadsize.$scratchpad
                              windowrulev2 = workspace special silent,$scratchpad
                              windowrulev2 = center,$scratchpad

                              windowrulev2 = float,class:^(org.pulseaudio.pavucontrol)$
                              # windowrulev2 = workspace special silent,class:^(pavucontrol)$

                              # bind = SUPER,SPACE,exec, if hyprctl clients | grep scratch_term; then echo "scratch_term respawn not needed" ; else ${terminal} --class scratch_term; fi
                              # bind = SUPER,SPACE,togglespecialworkspace,scratch_term


                              $scratch_term = class:^(scratch_term)$
                              windowrulev2 = float,$scratch_term
                              windowrulev2 = $scratchpadsize,$scratch_term
                              windowrulev2 = workspace special:scratch_term ,$scratch_term
                              windowrulev2 = center,$scratch_term

        '';
    };
  }
