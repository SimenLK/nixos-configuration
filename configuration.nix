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
    binfmt.emulatedSystems = [ "aarch64-linux" ];
    blacklistedKernelModules = [ "nouveau" "nvidia" ];
    kernelParams = [ "intel_pstate=no_hwp" "i915.enable_guc=2" ];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.luks.devices = {
      luksroot = {
        device = "/dev/disk/by-uuid/d229c613-ca79-407d-ae06-97978f1408c6";
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

