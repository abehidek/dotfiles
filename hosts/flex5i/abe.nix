# Home-Manager config for flex5i abe user

{ lib, config, pkgs, unstable, user, ... }: {
  # home.stateVersion = "21.11";
  home.username = user;
  home.homeDirectory = "/home/${user}";
  imports = [
    ../../secrets


    ../../modules/editors/neovim/home.nix
    ../../modules/editors/vim/home.nix

    ../../modules/dev/home.nix

    ../../modules/shell/home.nix
    ../../modules/shell/zsh/home.nix
    ../../modules/shell/kitty/home.nix

    ../../modules/desktop/sway/home.nix
    ../../modules/desktop/services/waybar/home.nix
    ../../modules/desktop/services/rofi/home.nix
    ../../modules/desktop/utils/swaylock/home.nix

    ../../modules/themes/gtk/home.nix
  ];
  # nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # GUI Applications
    exodus
    signal-desktop
    vlc
    libreoffice
    # brave
    # unstable.tetrio-desktop
    google-chrome
    obsidian
    # unstable.spacevim
    # unstable.neovim
  ];
  programs.firefox = { enable = true; };
  home.file = {
    # ".config/ulauncher/user-themes/dark_trans".source = ulauncher-theme;
    # ".local/share/applications".source = ../modules/applications;
    # ".icons".source = ../../modules/icons;
  };

  services.dropbox.enable = true;
}
