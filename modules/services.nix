{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.services.nuta-nixer;
  nuta-nixer = pkgs.nuta-nixer;

  configuration = {
    # NOTE(SimenLK): create a container for nuta-nixer
    # containers.nuta-nixer = {
    #   autoStart = true;
    #   privateNetwork = true;
    #   hostAddress = "10.1.2.94";
    #   localAddress = "10.1.2.95";
    #   config = { config, ... }: {
    #     services.nuta-nixer = {
    #       enable = cfg.nuta-nixer.enable;
    #       package = pkgs.nuta-nixer;
    #       hostName = "localhost";
    #     };

    #     system.stateVersion = "22.05";

    #     system.firewall = {
    #       enable = true;
    #       allowedTCPPorts = [ 80 ];
    #     };
    #   };
    # };
  };
in
{
  options = {
    services.nuta-nixer = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run nuta-nixer
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.nuta-nixer = {
      isSystemUser = true;
      group = "nuta-nixer";
      description = "Nuta-nixer daemon user";
    };
    users.groups.nuta-nixer = {};

    systemd.services.nuta-nixer = {
      description = "Nuta-nixer Daemon";
      after = [ "network.target" "systemd-resolved.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ nuta-nixer pkgs.rsync pkgs.openssh ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${nuta-nixer}/bin/Server";
        Restart = "on-failure";
	User = "simen";
	Group = "simen";
	WorkingDirectory = "/serit/Innovasjon/nuta-nixer/src/Server";
      };
    };
  };
}
