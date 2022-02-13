{ config, lib, pkgs, ... }:

let
  buildScript = import ../buildScript.nix;
  wallpaper = /home/abe/Imagens/nordic-wallpapers/wallpapers/nixos.png ;
  lockScript = buildScript "lock" ../swaylock/lock {
    bg = wallpaper;
    lock = ../swaylock/lock.svg;
    swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  };
  import-gsettingsScript = buildScript "import-gsettings" ../import-gsettings {
    gsettings = "${pkgs.glib}/bin/gsettings";
  };
  theme = pkgs.nordic;
  iconTheme = pkgs.papirus-icon-theme;
in
{
  #qt.enable = true;
  #qt.platformTheme = "gnome";
  #qt.style.package = pkgs.adwaita-qt;
  #qt.style.name = "adwaita";
  gtk.enable = true;
  gtk.theme.package = theme;
  gtk.theme.name = "Nordic";
  gtk.iconTheme.package = iconTheme;
  gtk.iconTheme.name = "Papirus";

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      # startup programs and scripts
      startup = [
        { command = "${pkgs.autotiling}/bin/autotiling";}
        { command = "${import-gsettingsScript}/bin/import-gsettings"; always = true; }
        { command = "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"; }
        { command = "swayidle -w before-sleep '${pkgs.swaylock-fancy}/bin/swaylock-fancy'"; }

      ];
      menu = "${pkgs.wofi}/bin/wofi --show run swaymsg exec --";
      terminal = "${pkgs.alacritty}/bin/alacritty";

      # screens
      output."eDP-1" = {
        pos = "0 1080";
        resolution = "--custom 1600x900";
      };
      output."HDMI-A-1" = {
        pos = "0 0";
        res = "1920x1080";
      };

      # input and keybinds
      modifier = "Mod4";
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
        audio = "exec ${pkgs.pulseaudio-ctl}/bin/pulseaudio-ctl";
        light = "exec ${pkgs.brightnessctl}/bin/brightnessctl";
      in lib.mkOptionDefault {
        XF86AudioRaiseVolume = "${audio} up 5";
        XF86AudioLowerVolume = "${audio} down 5";
        XF86AudioMute = "${audio} mute";
        XF86AudioMicMute = "${audio} mute-input";
        XF86MonBrightnessDown = "${light} set 5%-";
        XF86MonBrightnessUp = "${light} set +5%";
        "${mod}+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";
      };
      input."type:keyboard" = {
        xkb_layout = "br";
        xkb_model = "abnt2";
      };
      input."type:touchpad" = {
        tap = "enabled";
        natural_scroll = "enabled";
        scroll_method = "two_finger";
      };

      # theming
      output."*" = { bg = "${wallpaper} fill"; };
      gaps.outer = 5;
      gaps.inner = 5;
      #client.focused #eb52eb #eb52eb #eb52eb #eb52eb;
      bars = [{ command = "waybar"; }];      
    };
    extraConfig = ''
    client.focused #eb52eb #eb52eb #eb52eb #eb52eb
    '';
    
    extraSessionCommands = ''
      export GTK_USE_PORTAL=1 
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      export MOZ_ENABLE_WAYLAND=1
      export CLUTTER_BACKEND=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_QPA_PLATFORM=wayland-egl
      export ECORE_EVAS_ENGINE=wayland-egl
      export ELM_ENGINE=wayland_egl
      export SDL_VIDEODRIVER=wayland
      export _JAVA_AWT_WM_NONREPARENTING=1
      export NO_AT_BRIDGE=1
      export SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh
    '';
  };
}