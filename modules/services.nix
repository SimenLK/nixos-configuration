{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.features.services;

  configuration = {
    nixpkgs.overlays = [
      (import ./overlays/nuta-nixer.nix)
    ];

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
  options.features.services = {
    enable = mkEnableOption "Enable custom systemd services";
    nuta-nixer.enable = mkEnableOption "Enable nuta-nixer";
  };

  config = mkMerge [
    (mkIf cfg.enable configuration)
  ];
}
