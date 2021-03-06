{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.features.desktop;

  configuration = {
    hardware.bluetooth.enable = true;
    hardware.pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      extraConfig = ''
        load-module module-bluetooth-policy
        load-module module-bluetooth-discover
      '';
    };

    powerManagement = {
      enable = false;
      cpuFreqGovernor = "ondemand";
    };

    programs.dconf.enable = true;

    services.dbus.enable = true;
    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplip ];

    services.xserver = {
      enable = true;
      enableCtrlAltBackspace = true;
      layout = "us";
      xkbVariant = "altgr-intl";
      xkbOptions = "eurosign:e";

      displayManager.gdm.enable = true;
      displayManager.job.logToFile = true;
      desktopManager.xterm.enable = true;

      libinput = {
        enable = true;
        naturalScrolling = true;
        additionalOptions = ''MatchIsTouchpad "on"'';
      };
    };

    services.upower.enable = true;
    services.cron.enable = true;
    services.cron.systemCronJobs = [
      "* * * * * simkir $HOME/.nix-profile/bin/mbsync simen > $HOME/.cronlog 2>&1"
     ];

    fonts.fonts = with pkgs; [
      font-awesome
      caladea
      carlito
      cantarell-fonts
      comic-relief
      liberation_ttf
      fira
      fira-mono
      fira-code
      fira-code-symbols
      dejavu_fonts
      powerline-fonts
      unifont
      siji
      tamsyn
      noto-fonts
      noto-fonts-emoji
      material-icons
    ];
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
    enable = mkEnableOption "Enable desktop configs";
    keybase.enable = mkEnableOption "Enable Keybase";
  };

  config = mkMerge [
    (mkIf cfg.enable configuration)
    (mkIf cfg.keybase.enable keybase)
  ];
}
