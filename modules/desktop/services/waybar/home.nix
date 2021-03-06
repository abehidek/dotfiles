{ lib, config, pkgs, ... }:
let colorscheme = import ../../../themes/colorscheme;
in {
  home.packages = with pkgs; [ wlogout ];
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [{
      height = 30;
      margin-bottom = 2;
      margin-top = 0;
      margin-left = 0;
      margin-right = 0;
      modules-left = [
        "sway/workspaces"
        "sway/mode"
        # "custom/media"
        "sway/window"
      ];
      #modules-center = [ "clock" ];
      modules-right = [
        # "mpd" 
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "battery"
        "battery#bat2"
        "tray"
        "clock"
      ];
      modules = {
        "sway/workspaces" = {
          all-outputs = true;
          disable-scroll = true;
          format = "  {icon}  ";
          format-icons = {
            # "1" = "壱";
            # "2" = "弐";
            # "3" = "参";
            # "4" = "肆";
            # "5" = "伍";
            # "6" = "陸";
            # "7" = "漆";
            # "8" = "捌";
            # "9" = "玖";
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            focused = "";
            urgent = "";
            default = "";
          };
        };
        "sway/mode" = { format = ''<span style="italic">{}</span>''; };
        "sway/window" = {
          format = " {}";
          max-length = 35;
          tooltip = false;
        };
        # "custom/media" = {
        #   format = "{icon} {}";
        #   return-type = "json";
        #   max-length = 40;
        #   format-icons = {
        #     spotify = "";
        #   };
        #   escape = true;
        # };
        # CENTER MODULES
        clock = {
          format = "{:%H:%M - %d/%m/%Y}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        # RIGHT MODULES
        pulseaudio = {
          scroll-step = 1;
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "pavucontrol";
        };
        network = {
          interface = "wlp0s20f3";
          interval = "5";
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "Ethernet ";
          format-linked = "Ethernet (No IP) ";
          format-disconnected = "Disconnected ";
          format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
          # on-click-middle = "nm-connection-editor";
        };
        cpu = { format = "{usage}% "; };
        memory = { format = "{}% "; };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon} ";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        "battery#bat2" = { bat = "BAT2"; };
        # "custom/power" = {
        #   format = "{icon}";
        #   format-icons = "";
        #   on-click = "${pkgs.wlogout}/bin/wlogout";
        #   escape = true;
        #   tooltip = false;
        # };
      };
    }];
    # background-color: ${colorscheme.base06};
    # color: ${colorscheme.base00};
    style = ''
      ${builtins.readFile ./style.css}
      .modules-left {
        background-color: transparent;
        color: #ffffff;
      }
      .modules-right {
        background-color: transparent;
      }
      window#waybar {
        background-color: ${colorscheme.base00};
        color: #ffffff;
      }
      #workspaces button {
        background-color: transparent;
        color: #ffffff;
      }
      #workspaces button:hover {
      }
      #workspaces button.focused {
          color: ${colorscheme.base0F};
      }
      #workspaces button.urgent {
          background-color: ${colorscheme.base08};
      }
      #mode {
        background-color: transparent;
        color: ${colorscheme.base0F};
      }
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #network,
      #pulseaudio,
      #custom-media,
      #tray,
      #mpd {
          color: ${colorscheme.base06};
      }
      #clock,
      #memory,
      #network {
        background-color: ${colorscheme.base01};
      }

      #network.disconnected {
          background-color: ${colorscheme.base0B};
      }        

      #battery,
      #cpu,
      #pulseaudio {
        background-color: ${colorscheme.base03};
      }

      #battery.charging, #battery.plugged {
          color: ${colorscheme.base06};
          background-color: ${colorscheme.base0E};
      }
      @keyframes blink {
          to {
              background-color: ${colorscheme.base03};
              color: ${colorscheme.base06};
          }
      }
      #battery.critical:not(.charging) {
          background-color: ${colorscheme.base0F};
          color: ${colorscheme.base06};
      }

      #pulseaudio.muted {
          background-color: ${colorscheme.base0D};
          color: ${colorscheme.base01};
      }
      #tray {
          background-color: ${colorscheme.base07};
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: ${colorscheme.base08};
      }
    '';
  };
}
