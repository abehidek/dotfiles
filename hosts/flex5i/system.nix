# Flex5i system config

{ lib, config, pkgs, unstable, ... }: {
  imports = [
    ./hardware.nix

    ../../rf-modules/hardware/audio.nix # Enables pipewire audio
    ../../rf-modules/desktop/sway # Enable sway on the system
    ../../rf-modules/dev
    ../../rf-modules/shell
    ../../rf-modules/shell/zsh
  ];

  nixpkgs.config.chromium.commandLineArgs =
    "---enable-features=UseOzonePlatform --ozone-platform=wayland -enable-features=VaapiVideoDecoder";

  boot = {
    cleanTmpDir = true;
    kernel.sysctl = { "fs.inotify.max_user_watches" = 524288; };
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = false;
    pulseaudio.enable = false;
    sensor.iio.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = [ pkgs.intel-compute-runtime ];
    };
  };

  networking = {
    hostName = "flex5i";
    networkmanager.enable = true;
    useNetworkd = true;
    useDHCP = false;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "pt_BR.UTF-8";
  console = {
    font = "ter-i24b";
    packages = [ pkgs.terminus_font ];
    earlySetup = true;
    keyMap = "br-abnt2";
  };

  services = {
    openssh.enable = true;
    xserver.libinput.enable = true;
    gnome.gnome-keyring.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    tlp = {
      enable = true;
      settings = { TLP_PERSISTENT_DEFAULT = 0; };
    };
  };

  fonts = {
    fonts = with pkgs; [
      # Regular fonts
      (nerdfonts.override {
        fonts = [ "FiraCode" "DroidSansMono" "FiraMono" ];
      })
      dejavu_fonts
      font-awesome

      # Japanese fonts
      rictydiminished-with-firacode
      hanazono
      ipafont
      kochi-substitute
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "DejaVu Sans Mono" "IPAGothic" ];
        sansSerif = [ "DejaVu Sans" "IPAPGothic" ];
        serif = [ "DejaVu Serif" "IPAPMincho" ];
      };
    };
  };

  security = {
    doas.enable = true;
    doas.extraRules = [{
      groups = [ "doas" "wheel" ];
      keepEnv = true;
      persist = true;
    }];
    sudo.enable = true;
    rtkit.enable = true;
    protectKernelImage = true;
  };

  system.stateVersion = "21.11";
}
