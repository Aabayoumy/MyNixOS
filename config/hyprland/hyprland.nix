{
  lib,
  username,
  host,
  config,
  pkgs,
  ...
}: let
  inherit
    (import ../../hosts/${host}/variables.nix)
    browser
    terminal
    extraMonitorSettings
    keyboardLayout
    ;
in
  with lib; {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = pkgs.hyprland.override {wrapRuntimeDeps = false;};
      systemd = {
        enable = true;
        extraCommands = lib.mkBefore [
          "systemctl --user stop graphical-session.target"
          "systemctl --user start hyprland-session.target"
        ];
      };
      settings = {
        env = [
          "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
          "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
          "MOZ_WEBRENDER, 1" # for firefox to run on wayland
          "XDG_SESSION_TYPE, wayland"
          "WLR_NO_HARDWARE_CURSORS, 1"
          "WLR_RENDERER_ALLOW_SOFTWARE, 1"
          "QT_QPA_PLATFORM, wayland"
        ];
      };
      extraConfig = let
        modifier = "SUPER";
      in
        concatStrings [
          ''
            source = ~/.config/hypr/monitors.conf
            source = ~/.config/hypr/workspaces.conf
            source = ~/.config/hypr/input.conf
            # source = ~/.config/hypr/scratchpads.conf

            exec-once = systemctl --user import-environment &
            exec-once = hash dbus-update-activation-environment 2>/dev/null &
            exec-once = dbus-update-activation-environment --systemd &
            # exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
            exec-once = killall -q swww;sleep .5 && swww init
            exec-once = killall -q waybar;sleep .5 && waybar
            exec-once = killall -q swaync;sleep .5 && swaync
            exec-once = nm-applet --indicator
            exec-once = lxqt-policykit-agent
            exec-once = sleep 1.5 && waypaper --wallpaper ~/.wallpaper
            exec-once = hypridle
            # monitor=,preferred,auto,1
            # unscale XWayland
            xwayland {
              force_zero_scaling = true
            }
            general {
              allow_tearing = true
              gaps_in = 6
              gaps_out = 8
              border_size = 3
              layout = dwindle
              resize_on_border = true
              col.active_border = rgb(${config.stylix.base16Scheme.base08}) rgb(${config.stylix.base16Scheme.base0C}) 45deg
              col.inactive_border = rgb(${config.stylix.base16Scheme.base01})
            }
            # input {
            #   kb_layout = ${keyboardLayout}
            #   kb_options = grp:alt_shift_toggle
            #   kb_options = caps:super
            #   follow_mouse = 1
            #   touchpad {
            #     natural_scroll = true
            #     disable_while_typing = true
            #     scroll_factor = 0.8
            #   }
            #   sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
            #   accel_profile = flat
            # }

            $scratchpadsize = size 80% 85%
            $scratch_term = class:^(scratch_term)$
            windowrulev2 = float,$scratch_term
            windowrulev2 = $scratchpadsize,$scratch_term
            windowrulev2 = workspace special:scratch_term ,$scratch_term
            windowrulev2 = center,$scratch_term


            windowrule = noborder,^(wofi)$
            windowrule = center,^(wofi)$
            windowrule = center,^(steam)$
            windowrule = float, nm-connection-editor|blueman-manager
            windowrule = float, swayimg|vlc|Viewnior|pavucontrol
            windowrule = float, nwg-look|qt5ct|mpv
            windowrule = float, zoom
            windowrule = float, title:^(Bitwarden)$
            #windowrulev2 = float,class:^(org.wezfurlong.wezterm)$
            windowrulev2 = stayfocused, title:^()$,class:^(steam)$
            windowrulev2 = minsize 1 1, title:^()$,class:^(steam)$
            windowrulev2 = opacity 0.9 0.7, class:^(Brave)$
            windowrulev2 = opacity 0.9 0.7, class:^(thunar)$
            gestures {
              workspace_swipe = true
              workspace_swipe_fingers = 3
            }
            misc {
              initial_workspace_tracking = 0
              mouse_move_enables_dpms = true
              key_press_enables_dpms = false
            }
            animations {
              enabled = yes
              bezier = wind, 0.05, 0.9, 0.1, 1.05
              bezier = winIn, 0.1, 1.1, 0.1, 1.1
              bezier = winOut, 0.3, -0.3, 0, 1
              bezier = liner, 1, 1, 1, 1
              animation = windows, 1, 6, wind, slide
              animation = windowsIn, 1, 6, winIn, slide
              animation = windowsOut, 1, 5, winOut, slide
              animation = windowsMove, 1, 5, wind, slide
              animation = border, 1, 1, liner
              animation = fade, 1, 10, default
              animation = workspaces, 1, 5, wind
            }
            decoration {
              rounding = 0
              drop_shadow = true
              shadow_range = 4
              shadow_render_power = 3
              col.shadow = rgba(1a1a1aee)
              blur {
                  enabled = true
                  size = 5
                  passes = 3
                  new_optimizations = on
                  ignore_opacity = off
              }
            }
            plugin {
              hyprtrails {
              }
            }
            dwindle {
              pseudotile = true
              preserve_split = true
            }
            bind = ${modifier},Return,exec,${terminal}
            bind = ${modifier},SPACE,exec, if hyprctl clients | grep scratch_term; then echo "scratch_term respawn not needed" ; else ${terminal} --class scratch_term; fi
            bind = ${modifier},SPACE,togglespecialworkspace,scratch_term
            # [workspace special] ${terminal} --class scratch_term
            bind = ${modifier},Super_L,exec, killall rofi || rofi -show drun
            bind = ${modifier},W, exec, waypaper
            bind = ${modifier} SHIFT,W,exec,wallsetter
            bind = ${modifier} SHIFT,N,exec,swaync-client -rs
            bind = ${modifier},B,exec,${browser}
            bind = ${modifier} SHIFT,E,exec,emopicker9000
            bind = ${modifier},S,exec,screenshootin
            bind = ${modifier},D,exec,discord
            bind = ${modifier},O,exec,obs
            bind = ${modifier},C,exec,hyprpicker -a
            bind = ${modifier},G,exec,gimp
            bind = ${modifier} SHIFT,G,exec,godot4
            bind = ${modifier},E,exec,thunar
            bind = ${modifier},M,exec,spotify
            bind = ${modifier},Q,killactive,
            bind = ${modifier}, Escape, exec, killall waybar || ${pkgs.waybar}/bin/waybar # toggle waybar
            bind = ${modifier}, L, exec, hyprlock
            bind = ${modifier},P,pseudo,
            bind = ${modifier} SHIFT,I,togglesplit,
            bind = ${modifier},F,fullscreen,
            bind = ${modifier} SHIFT,F,togglefloating,
            bind = ${modifier} SHIFT,Q,exit,
            bind = ${modifier} SHIFT,left,movewindow,l
            bind = ${modifier} SHIFT,right,movewindow,r
            bind = ${modifier} SHIFT,up,movewindow,u
            bind = ${modifier} SHIFT,down,movewindow,d
            bind = ${modifier} SHIFT,h,movewindow,l
            bind = ${modifier} SHIFT,l,movewindow,r
            bind = ${modifier} SHIFT,k,movewindow,u
            bind = ${modifier} SHIFT,j,movewindow,d
            bind = ${modifier},left,movefocus,l
            bind = ${modifier},right,movefocus,r
            bind = ${modifier},up,movefocus,u
            bind = ${modifier},down,movefocus,d
            bind = ${modifier},h,movefocus,l
            bind = ${modifier},l,movefocus,r
            bind = ${modifier},k,movefocus,u
            bind = ${modifier},j,movefocus,d
            bind = ${modifier},1,workspace,1
            bind = ${modifier},2,workspace,2
            bind = ${modifier},3,workspace,3
            bind = ${modifier},4,workspace,4
            bind = ${modifier},5,workspace,5
            bind = ${modifier},6,workspace,6
            bind = ${modifier},7,workspace,7
            bind = ${modifier},8,workspace,8
            bind = ${modifier},9,workspace,9
            bind = ${modifier},0,workspace,10
            # bind = ${modifier} SHIFT,SPACE,movetoworkspace,special
            # bind = ${modifier},SPACE,togglespecialworkspace
            bind = ${modifier} SHIFT,1,movetoworkspace,1
            bind = ${modifier} SHIFT,2,movetoworkspace,2
            bind = ${modifier} SHIFT,3,movetoworkspace,3
            bind = ${modifier} SHIFT,4,movetoworkspace,4
            bind = ${modifier} SHIFT,5,movetoworkspace,5
            bind = ${modifier} SHIFT,6,movetoworkspace,6
            bind = ${modifier} SHIFT,7,movetoworkspace,7
            bind = ${modifier} SHIFT,8,movetoworkspace,8
            bind = ${modifier} SHIFT,9,movetoworkspace,9
            bind = ${modifier} SHIFT,0,movetoworkspace,10
            bind = ${modifier} CONTROL,right,workspace,e+1
            bind = ${modifier} CONTROL,left,workspace,e-1
            bind = ${modifier},mouse_down,workspace, e+1
            bind = ${modifier},mouse_up,workspace, e-1
            bindm = ${modifier},mouse:272,movewindow
            bindm = ${modifier},mouse:273,resizewindow
            # bind = ALT,SPACE, exec, hyprctl switchxkblayout all next
            bind = ALT,Tab,cyclenext
            bind = ALT,Tab,bringactivetotop
            bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
            bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
            binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
            bind = ,XF86AudioPlay, exec, playerctl play-pause
            bind = ,XF86AudioPause, exec, playerctl play-pause
            bind = ,XF86AudioNext, exec, playerctl next
            bind = ,XF86AudioPrev, exec, playerctl previous
            bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
            bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
            bind = ,XF86HomePage,exec,${browser}
            bind = ,XF86Calculator,exec,galculator
            bind = ,XF86Search,exec,web-search
          ''
        ];
    };

    home.file.".config/waypaper/config.ini".text = ''
      [Settings]
      language = en
      folder = ~/.wallpapers
      monitors = All
      wallpaper = ~/.wallpapers/planet-space-abstract-background-digital-art-4k-wallpaper-uhdpaper.com-234@0@g.jpg
      backend = swww
      fill = fill
      sort = name
      color = #ffffff
      subfolders = True
      show_hidden = True
      show_gifs_only = False
      post_command = cp $wallpaper ~/.wallpaper
      number_of_columns = 3
      swww_transition_type = any
      swww_transition_step = 90
      swww_transition_angle = 0
      swww_transition_duration = 2
      swww_transition_fps = 60
      use_xdg_state = False

    '';

    home.file.".config/hypr/monitors.conf".text = ''
      monitor=HDMI-A-1,1920x1080@74.97,0x0,1.0
      monitor=DP-1,2560x1440@120,1920x0,1.0
    '';

    home.file.".config/hypr/workspaces.conf".text = ''
      workspace=1,monitor:DP-1,default:true
      workspace=3,monitor:DP-1
      workspace=5,monitor:DP-1
      workspace=7,monitor:DP-1
      workspace=9,monitor:DP-1
      workspace=2,monitor:HDMI-A-1,default:true
      workspace=4,monitor:HDMI-A-1
      workspace=6,monitor:HDMI-A-1
      workspace=8,monitor:HDMI-A-1
    '';

    home.file.".config/hypr/input.conf".text = ''
      input {
        kb_layout=us,ara
        kb_variant=,digits
        kb_model=
        kb_options=grp:alt_shift_toggle,caps:escape
        kb_rules=
        repeat_rate=50
        repeat_delay=300
        numlock_by_default=1
        left_handed=0
        follow_mouse=1
        float_switch_override_focus=0
        # sensitivity = -0.5 to 0.5
      }
    '';
  }
