{ pkgs, config, ...}:
{
  networking = {
    hostName = "church";
    domain = "local";
    search = [ "local" ];
  };

  security.pam.services.sshd.googleAuthenticator.enable = true;

  features = {
    desktop.enable = false;
    desktop.keybase.enable = false;
    cachix.enable = true;

    os = {
      boot = {
        uefi = true;
        device = "/dev/nvme0n1p1";
      };

      networkmanager.enable = true;
      externalInterface = "eno2";

      docker.enable = true;

      adminAuthorizedKeys = [
      ];
    };

    lan.enable = false;
  };

  imports = [
    ./.
    ./kernel.nix
    ./hardware-configuration.nix
  ];

}

