{
  pkgs,
  lib,
  host,
  config,
  ...
}: let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  inherit (import ../../../../hosts/${host}/variables.nix) clock24h;
in
  with lib; {
    # Configure & Theme Waybar
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = [
        {
          layer = "top";
          position = "top";
          modules-center = ["hyprland/window"];
          modules-left = [
            "group/power"
            "hyprland/workspaces"
          ];
          modules-right = [
            "custom/hyprbindings"
            "cpu"
            "memory"
            "idle_inhibitor"
            "custom/notification"
            "pulseaudio"
            "hyprland/language"
            "tray"
            "clock"
          ];

          "hyprland/workspaces" = {
            format = "{name}";
            format-icons = {
              default = " ";
              active = " ";
              urgent = " ";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          "clock" = {
            format =
              if clock24h == true
              then '' {:L%H:%M %e %b}''
              else '' {:L%I:%M %p %e %b}'';
            tooltip = true;
            # tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "month";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
            };
            actions = {
              on-click-right = "mode";
              on-scroll-up = "shift_up";
              on-scroll-down = "shift_down";
            };
          };
          "hyprland/window" = {
            max-length = 22;
            separate-outputs = true;
            icon = true;
            rewrite = {
              "" = " 🙈 No Windows? ";
            };
          };
          "memory" = {
            interval = 5;
            format = " {}%";
            tooltip = true;
          };
          "cpu" = {
            interval = 5;
            format = " {usage:2}%";
            tooltip = true;
          };
          "disk" = {
            format = " {free}";
            tooltip = true;
          };
          "network" = {
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-ethernet = " {bandwidthDownOctets}";
            format-wifi = "{icon} {signalStrength}%";
            format-disconnected = "󰤮";
            tooltip = false;
          };
          "tray" = {
            spacing = 12;
          };
          "hyprland/language" = {
            format = "{short}";
            on-click = "hyprctl switchxkblayout at-translated-set-2-keyboard next";
          };
          "pulseaudio" = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "sleep 0.1 && pavucontrol";
          };
          "custom/exit" = {
            tooltip = false;
            format = "";
            on-click = "sleep 0.1 && wlogout";
          };
          "group/power" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 500;
              "children-class" = "not-power";
              "transition-left-to-right" = true;
            };
            "modules" = [
              "custom/startmenu"
              "custom/lock"
              "custom/quit"
              "custom/power"
              "custom/reboot"
            ];
          };
          "custom/startmenu" = {
            tooltip = false;
            format = "";
            # exec = "rofi -show drun";
            on-click = "sleep 0.1 && rofi-launcher";
          };
          "custom/quit" = {
            "format" = "󰍃";
            "tooltip" = false;
            "on-click" = "hyprctl dispatch exit";
          };
          "custom/lock" = {
            "format" = "󰍁";
            "tooltip" = false;
            "on-click" = "loginctl lock-session";
          };
          "custom/reboot" = {
            "format" = "󰜉";
            "tooltip" = false;
            "on-click" = "reboot";
          };
          "custom/power" = {
            "format" = "󰐥";
            "tooltip" = false;
            "on-click" = "shutdown now";
          };
          "custom/hyprbindings" = {
            tooltip = false;
            format = "󱕴";
            on-click = "sleep 0.1 && list-hypr-bindings";
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
            tooltip = "true";
          };
          "custom/notification" = {
            tooltip = false;
            format = "{icon} {}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "sleep 0.1 && task-waybar";
            escape = true;
          };
          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󱘖 {capacity}%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            on-click = "";
            tooltip = false;
          };
        }
      ];
      style = concatStrings [
        ''
          * {
            font-family: JetBrainsMono Nerd Font Mono;
            font-size: 16px;
            border-radius: 0px;
            border: none;
            min-height: 0px;
            padding: 0;
            margin: 0;
          }
          window#waybar {
            background: rgba(0,0,0,0);
          }
          #workspaces {
            color: #${config.stylix.base16Scheme.base00};
            background: #${config.stylix.base16Scheme.base01};
            margin: 10px 0px;
            margin-left: 0px;
            margin-right: 7px;
            padding: 5px 5px;
            border-radius: 0px 16px 16px 0px;
          }
          #workspaces button {
            font-weight: bold;
            padding: 0px 5px;
            margin: 0px 3px;
            border-radius: 16px;
            color: #${config.stylix.base16Scheme.base00};
            background: linear-gradient(45deg, #${config.stylix.base16Scheme.base08}, #${config.stylix.base16Scheme.base0D});
            opacity: 0.5;
            transition: ${betterTransition};
          }
          #workspaces button.active {
            font-weight: bold;
            padding: 0px 5px;
            margin: 0px 3px;
            border-radius: 16px;
            color: #${config.stylix.base16Scheme.base00};
            background: linear-gradient(45deg, #${config.stylix.base16Scheme.base08}, #${config.stylix.base16Scheme.base0D});
            transition: ${betterTransition};
            opacity: 1.0;
            min-width: 40px;
          }
          #workspaces button:hover {
            font-weight: bold;
            border-radius: 16px;
            color: #${config.stylix.base16Scheme.base00};
            background: linear-gradient(45deg, #${config.stylix.base16Scheme.base08}, #${config.stylix.base16Scheme.base0D});
            opacity: 0.8;
            transition: ${betterTransition};
          }
          tooltip {
            background: #${config.stylix.base16Scheme.base01};
            border: 1px solid #${config.stylix.base16Scheme.base08};
            border-radius: 12px;
          }
          tooltip label {
            color: #${config.stylix.base16Scheme.base0B};
          }
          #window {
            font-weight: bold;
            margin: 10px 0px;
            margin-left: 7px;
            padding: 5px 5px;
            background: #${config.stylix.base16Scheme.base01};
            color: #${config.stylix.base16Scheme.base05};
            border-radius: 16px 16px 16px 16px;
          }
            #custom-hyprbindings {
            font-weight: bold;
            margin: 10px 0px;
            margin-left: 7px;
            padding: 5px 15px;
            background: #${config.stylix.base16Scheme.base01};
            color: #${config.stylix.base16Scheme.base05};
            border-radius: 16px 0px 0px 16px;
          }
            #pulseaudio, #cpu, #memory, #idle_inhibitor,
            #network, #battery, #language,
            #custom-notification {
            font-weight: bold;
            margin: 10px 0px;
            margin-left: 0px;
            padding: 0px 10px;
            background: #${config.stylix.base16Scheme.base01};
            color: #${config.stylix.base16Scheme.base05};
            border-radius: 0px 0px 0px 0px;
          }
            #tray, #custom-exit {
            font-weight: bold;
            margin: 10px 0px;
            margin-left: 0px;
            margin-right: 10px;
            padding: 5px 5px;
            background: #${config.stylix.base16Scheme.base01};
            color: #${config.stylix.base16Scheme.base05};
            border-radius: 0px 16px 16px 0px;
          }


          #custom-startmenu {
            color: #${config.stylix.base16Scheme.base0B};
            background: #${config.stylix.base16Scheme.base02};
            font-size: 28px;
            margin: 10px 0px;
            margin-left: 10px;
            padding: 0px 10px;
            border-radius: 16px 0px 0px 16px;
          }
            #custom-quit, #custom-lock,#custom-reboot,#custom-power{
            font-weight: bold;
            margin: 10px 0px;
            margin-left: 0px;
            padding: 0px 10px;
            font-size: 20px;
            background: #${config.stylix.base16Scheme.base02};
            color: #${config.stylix.base16Scheme.base0B};
            border-radius: 0px 0px 0px 0px;
          }

          #clock {
            font-weight: bold;
            color: #0D0E15;
            background: linear-gradient(90deg, #${config.stylix.base16Scheme.base0E}, #${config.stylix.base16Scheme.base0C});
            font-weight: bold;
            margin: 10px 0px;
            margin-left: 7px;
            margin-right: 10px;
            padding: 5px 15px;
            border-radius: 16px 16px 16px 16px;
          }
        ''
      ];
    };
  }
