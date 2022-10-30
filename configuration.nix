{ pkgs, config, ...}:
let
    yubikey = {
      slot = 2;
      twoFactor = false;
      storage = {
        device = "/dev/nvme0n1p2";
      };
    };
in
{
  networking = {
    hostName = "church";
    domain = "local";
    search = [ "local" ];
  };

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.grub = {
      enable = false;
      version = 2;
      device = "/dev/nvme0n1p1";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  i18n = {
    defaultLocale = "en_DK.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_DK.UTF-8";
    };
  };

  time.timeZone = "Europe/Oslo";

  features = {
    desktop.enable = true;
    desktop.keybase.enable = true;
    cachix.enable = true;

    pki = {
      enable = false;
      certmgr.enable = false;
      certs = {
        foo = { hosts = [ "localhost" ]; };
      };
    };

    os = {
      networkmanager.enable = true;
      externalInterface = "eno2";

      docker.enable = true;
    };

    lan = {
      enable = false;

      samba.extraConfig = ''
        netbios name = ${config.networking.hostName}
        workgroup = ITPARTNER
        # add machine script = /run/current-system/sw/bin/useradd -d /var/empty -g 65534 -s /run/current-system/sw/bin/false -M %u
      '';

      krb5 = {
        enable = true;
        default_realm = "ITPARTNER.INTERN";

        domain_realm = {
          "itpartner.no" = "ITPARTNER.INTERN";
          ".itpartner.no" = "ITPARTNER.INTERN";
        };

        realms = {
          "ITPARTNER.INTERN" = {
            admin_server = "itp-dc3.itpartner.intern";
            kdc = "itp-dc3.itpartner.intern";
          };
        };
      };
    };
  };

  services.dnsmasq.enable = false;
  services.dnsmasq.extraConfig = ''
    interface=enp0s31f6
    port=0
    listen-address=::1,127.0.0.1,192.168.66.1
    dhcp-range=192.168.66.10,192.168.66.50,12h
    server=8.8.8.8
  '';

  services.nuta-nixer.enable = false;

  programs.singularity.enable = false;

  hardware.bluetooth.settings = {
    General = {
      AutoConnct = true;
      MultiProfile = "multiple";
    };
  };

  services.pcscd.enable = false; # For Yubikey ykman

  security.pam.yubico = {
    enable = false;
    mode = "client"; # "challenge-response";
    id = "";
    control = "sufficient";
  };

  imports = [
    ./.
    ./kernel.nix
    ./hardware-configuration.nix
  ];

}
