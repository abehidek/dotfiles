{ lib, config, pkgs, ... }: {
  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/abe/songs";
      user = "abe";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
  };
  systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR =
      "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
  };
}
