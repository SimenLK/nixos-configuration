{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.features.laptop;

  hibernateEnvironment = {
    HIBERNATE_SECONDS = "10800";
    HIBERNATE_LOCK = "/var/run/autohibernate.lock";
  };

  configuration = {
    systemd.services."awake-after-suspend-for-a-time" = {
      description = "Sets up the suspend so that it'll wake for hibernation";
      wantedBy = [ "suspend.target" ];
      before = [ "systemd-suspend.service" ];
      environment = hibernateEnvironment;
      script = ''
        curtime=$(date +%s)
        echo "$curtime $1" >> /tmp/autohibernate.log
        echo "$curtime" > $HIBERNATE_LOCK
        ${pkgs.utillinux}/bin/rtcwake -m no -s $HIBERNATE_SECONDS
      '';
      serviceConfig.Type = "simple";
    };
    systemd.services."hibernate-after-recovery" = {
      description = "Hibernates after a suspend recovery due to timeout";
      wantedBy = [ "suspend.target" ];
      after = [ "systemd-suspend.service" ];
      environment = hibernateEnvironment;
      script = ''
        curtime=$(date +%s)
        sustime=$(cat $HIBERNATE_LOCK)
        rm $HIBERNATE_LOCK
        if [ $(($curtime - $sustime)) -ge $HIBERNATE_SECONDS ] ; then
        systemctl hibernate
        else
        ${pkgs.utillinux}/bin/rtcwake -m no -s 1
        fi
      '';
      serviceConfig.Type = "simple";
    };
  };
in
{
  options.features.laptop = {
      enable = mkEnableOption "Enable laptop configs";
  };

  config = mkMerge [
    (mkIf cfg.enable configuration)
  ];
}
