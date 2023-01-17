{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.features.desktop;

  configuration = {
    hardware.bluetooth.enable = true;
    hardware.pulseaudio = {
      enable = true;
    };

    powerManagement = {
      enable = false;
      cpuFreqGovernor = "ondemand";
    };

    programs.dconf.enable = true;

    security.pam.services.login.enableGnomeKeyring = true;

    services.blueman.enable = true;

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.gnome3.gnome-keyring pkgs.gcr ];

    services.gnome.gnome-keyring.enable = true;

    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplip ];

    services.xserver = {
        enable = true;
        desktopManager.xterm.enable = true;
        displayManager.gdm.enable = true;
        displayManager.job.logToFile = true;
        enableCtrlAltBackspace = true;
        layout = "us";
        xkbOptions = "eurosign:e";
        xkbVariant = "altgr-intl";

        videoDrivers = [ "intel" ];
        config = ''
          Section "Device"
              Identifier "Intel Graphics"
              Driver "intel"
              Option "TearFree" "true"
          EndSection
        '';
    };

    hardware.opengl = {
      enable = true;
    };

    services.upower.enable = true;

    services.cron = {
        enable = false;
        systemCronJobs = [
            ''* * * * * root curl https://infoskjerm.simkir.k2.itpartner.no/api/devPresent -d '["Simen", "Present"]' >> /tmp/cron.log''
        ];
    };

    # NOTE(SimenLK): Lorri enables dev environments to activate in dir entry
    services.lorri.enable = true;

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
      open-sans
      jetbrains-mono
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
