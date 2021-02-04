{ pkgs, config, ...}:
{
  networking = {
    hostName = "church";
    domain = "local";
    search = [ "local" ];
  };

  security.pam.services.sshd.googleAuthenticator.enable = true;

  features = {
    desktop.enable = true;
    desktop.keybase.enable = true;
    cachix.enable = true;

    os = {
      boot = {
        uefi = true;
        device = "/dev/nvme0n1p1";
      };

      networkmanager.enable = true;
      externalInterface = "eno2";

      docker.enable = true;
    };

    lan.enable = false;
  };

  imports = [
    ./.
    ./kernel.nix
    ./hardware-configuration.nix
  ];

}

