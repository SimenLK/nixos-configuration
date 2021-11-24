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
    hostName = "zelda";
    domain = "itpartner.no";
    search = [ "itpartner.intern" "itpartner.no" ];
    firewall.allowedTCPPorts = [];
    firewall.extraCommands = ''
      iptables -I INPUT -s 10.1.2.40 -j DROP
    '';
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  boot = {
    kernelParams = [ "intel_pstate=no_hwp" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices = {
      luksroot = {
        device = "/dev/disk/by-uuid/ad562ade-57c8-45a0-851a-4576ee4e6aa9";
        preLVM = true;
        allowDiscards = true;
      };
    };
    loader.grub = {
      enable = false;
      version = 2;
      device = "nodev";
      efiSupport = true;
      enableCryptodisk = true;
      gfxmodeEfi = "1024x768";
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
      certmgr.enable = true;
      certs = {
        foo = { hosts = [ "localhost" ]; };
      };
    };

    os = {
      networkmanager.enable = true;
      externalInterface = "eno2";

      docker.enable = true;

      adminAuthorizedKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiAS30ZO+wgfAqDE9Y7VhRunn2QszPHA5voUwo+fGOf jonas-3"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDULdlLC8ZLu9qBZUYsjhpr6kv5RH4yPkekXQdD7prkqapyoptUkO1nOTDwy7ZsKDxmp9Zc6OtdhgoJbowhGW3VIZPmooWO8twcaYDpkxEBLUehY/n8SlAwBtiHJ4mTLLcynJMVrjmTQLF3FeWVof0Aqy6UtZceFpLp1eNkiHTCM3anwtb9+gfr91dX1YsAOqxqv7ooRDu5rCRUvOi4OvRowepyuBcCjeWpTkJHkC9WGxuESvDV3CySWkGC2fF2LHkAu6SFsFE39UA5ZHo0b1TK+AFqRFiBAb7ULmtuno1yxhpBxbozf8+Yyc7yLfMNCyBpL1ci7WnjKkghQv7yM1xN2XMJLpF56v0slSKMoAs7ThoIlmkRm/6o3NCChgu0pkpNg/YP6A3HfYiEDgChvA6rAHX6+to50L9xF3ajqk4BUzWd/sCk7Q5Op2lzj31L53Ryg8vMP8hjDjYcgEcCCsGOcjUVgcsmfC9LupwRIEz3aF14AWg66+3zAxVho8ozjes= jonas.juselius@juselius.io"
      ];
    };

    lan = {
      enable = true;

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
    address=/.cluster.local/10.101.0.1
  '';

  programs.singularity.enable = true;

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

