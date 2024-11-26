{ pkgs, config, lib, ... }:
let
  cfg = config.features.desktop;

  configuration = {
    hardware.bluetooth.enable = true;
    hardware.pulseaudio = {
      enable = true;
      extraConfig = ''
        load-module module-bluetooth-policy
        load-module module-bluetooth-discover
      '';
    };
    hardware.opengl.enable = true;

    powerManagement = {
      enable = false;
      cpuFreqGovernor = "ondemand";
    };

    programs.dconf.enable = true;

    security.pam.services.login.enableGnomeKeyring = true;

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.gnome3.gnome-keyring pkgs.gcr ];

    services.blueman.enable = true;

    services.gnome.gnome-keyring.enable = true;

    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplip ];

    services.xserver.displayManager = {
      gdm = {
        enable = true;
      };
    };

    services.displayManager = {
      enable = true;
      logToFile = true;
      sddm = {
        enable = false;
        wayland = {
          enable = true;
        };
      };
    };

    services.libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
      };
      touchpad = {
        naturalScrolling = true;
      };
    };

    services.upower.enable = true;

    fonts.packages = with pkgs; [
      caladea
      carlito
      cantarell-fonts
      comic-relief
      liberation_ttf
      font-awesome
      fira
      fira-mono
      fira-code
      fira-code-symbols
      dejavu_fonts
      powerline-fonts
      unifont
      siji
      tamsyn
      nerdfonts
      noto-fonts
      noto-fonts-emoji
      material-icons
      open-sans
      jetbrains-mono
    ];
  };

  x11 = {
    services.xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      xkb = {
        layout = "us";
        variant = "altgr-intl";
        options = "eurosign:e";
      };

      videoDrivers = [ "intel" ];
      config = ''
        Section "Device"
          Identifier "Intel Graphics"
          Driver "intel"
          Option "TearFree" "true"
        EndSection
      '';

      desktopManager.xterm.enable = true;
    };
  };

  hyprland = {
    programs = {
      hyprland = {
        enable = true;
      };

      hyprlock = {
        enable = true;
      };

      nm-applet = {
        enable = true;
      };

      waybar = {
        enable = true;
      };
    };

    services.pipewire = {
      enable = true;
    };

    xdg.portal.wlr.enable = true;
  };

  keybase = {
    services.keybase.enable = true;
    services.kbfs = {
      enable = true;
      extraFlags = [ "-label kbfs" ];
      mountPoint = "%h/keybase";
    };
  };
in
{
  options.features.desktop = {
    enable = lib.mkEnableOption "Enable desktop configs";
    keybase.enable = lib.mkEnableOption "Enable Keybase";
    x11.enable = lib.mkEnableOption "Enable x11";
    hyprland.enable = lib.mkEnableOption "Enable hyprland";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable configuration)
    (lib.mkIf cfg.keybase.enable keybase)
    (lib.mkIf cfg.hyprland.enable hyprland)
    (lib.mkIf cfg.x11.enable x11)
  ];
}
