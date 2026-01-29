{ pkgs, ...}:
{
  imports = [
    ./.
    ./kernel.nix
    <nixos-hardware/common/cpu/amd>
    <nixos-hardware/common/cpu/amd/pstate.nix>
    <nixos-hardware/common/cpu/amd/zenpower.nix>
    <nixos-hardware/common/gpu/amd>
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "church";
    domain = "obx";
    search = [ "obx" ];
    firewall.allowedTCPPorts = [];
    firewall.allowedUDPPorts = [];
    firewall.extraCommands = '' '';
  };

  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    initrd.luks.devices = {
      luksroot = {
        device = "/dev/nvme0n1p1";
        preLVM = true;
        allowDiscards = true;
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_CTYPE="en_DK.UTF-8";
      LC_TIME="en_DK.UTF-8";
      LC_PAPER="en_DK.UTF-8";
      LC_NAME="en_DK.UTF-8";
      LC_ADDRESS="en_DK.UTF-8";
      LC_TELEPHONE="en_DK.UTF-8";
      LC_MEASUREMENT="en_DK.UTF-8";
      LC_IDENTIFICATION="en_DK.UTF-8";
    };
  };

  time.timeZone = "Europe/Oslo";

  hardware.enableRedistributableFirmware = true;

  features = {
    desktop.enable = true;
    laptop.enable = false;
    desktop.keybase.enable = true;
    desktop.plasma.enable = true;

    os = {
      externalInterface = "eno2";
      networkmanager.enable = true;

      docker.enable = true;

      adminAuthorizedKeys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDULdlLC8ZLu9qBZUYsjhpr6kv5RH4yPkekXQdD7prkqapyoptUkO1nOTDwy7ZsKDxmp9Zc6OtdhgoJbowhGW3VIZPmooWO8twcaYDpkxEBLUehY/n8SlAwBtiHJ4mTLLcynJMVrjmTQLF3FeWVof0Aqy6UtZceFpLp1eNkiHTCM3anwtb9+gfr91dX1YsAOqxqv7ooRDu5rCRUvOi4OvRowepyuBcCjeWpTkJHkC9WGxuESvDV3CySWkGC2fF2LHkAu6SFsFE39UA5ZHo0b1TK+AFqRFiBAb7ULmtuno1yxhpBxbozf8+Yyc7yLfMNCyBpL1ci7WnjKkghQv7yM1xN2XMJLpF56v0slSKMoAs7ThoIlmkRm/6o3NCChgu0pkpNg/YP6A3HfYiEDgChvA6rAHX6+to50L9xF3ajqk4BUzWd/sCk7Q5Op2lzj31L53Ryg8vMP8hjDjYcgEcCCsGOcjUVgcsmfC9LupwRIEz3aF14AWg66+3zAxVho8ozjes= jonas.juselius@juselius.io"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2tox0uyFGfU1zPNU6yAVSoGOUkeU959aiTMrqu1U9MCCOP2o4IhZIlRpZ08XVnUU/AhycCUF4HgGqdcco8oIVX0P0Cn83KJoD/DOqAiz+1VwIUUV1ylrRdNqCgf4wnmLni3sUPHJdQnuq57+pzDDjHMr9CcBL2KzOHD/QanfR+jZmv9K3OS5oDcWquSCziXkpbkWQURPactmtyzGK2FRRxONZgYrB8gRTDstlWQg/t6GHNVelzuJ7SEf+t8pk/S2e/XAvfZyRJhrVJ35iZKpmxkIn5v0g1Z+z0yX/KRSAPRtNg9uM44cmto77MFx7iFs0CuleL3zHvRvZYW1ZnsKAiP07UkEK87luMpkTzFr9CSHJGpgk1RZYA3qidQti44n6NU9YRNhzO4v+KQE6XDqO80gZCJboSXr3fnYn/QHpPXzK5JcZNWmClyMURYj10qv9So3Fh0o3LV5GThA6JgN874vUywUZanPEdn8ePBcAsjLRzA4YBGEuvJCc6FELSuY2s+/pFba8NXQvrOdJKSRC0g5USQFfaWDln4Q4zZ1G5z76p1u6GtRWxvakkUQ0fze9KAW7msxeKaw+B7uMtyvCL8V2zEE8WKFP1sNyYEe7Sgp3RVfym2VPMNTZVhEImfM/3D+WbzfoJztnJvFKXeeMCcne4G8swyef3o1s3b+CvQ== ski027@uit.no"
      ];
    };
  };

  programs = {
    chromium = {
      enable = true;
    };

    firefox = {
      enable = true;
    };

    # Trying gnu agent
    # ssh.startAgent = true;

    steam.enable = true;

    singularity.enable = true;
  };

  systemd.services = {
    tailscaled = {
      after = [
        "systemd-resolved.service"
      ];
    };

    nix-daemon = {
      serviceConfig.EnvironmentFile = "/to/secrets.txt";
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraUpFlags = [
      "--login-server=https://headscale.svc.oceanbox.io"
      "--accept-routes"
    ];
  };

  services.dnsmasq = {
    enable = false;
    settings = {
      address = [
        "/.local/127.0.0.1"
        "/.local.oceanbox.io/127.0.0.1"
        "/.vtn.local/172.16.239.50"
        "/.tos.local/10.255.241.10"
      ];
    };
  };

  services.lorri.enable = true;

  services.avahi.enable = true;

  services.pcscd.enable = true; # For Yubikey ykman
  security.pam.yubico = {
    enable = false;
    mode = "client"; # "challenge-response";
    id = "34717949";
    control = "sufficient";
  };
  services.udev = {
    packages = with pkgs; [
      yubikey-personalization
    ];
  };

  hardware.keyboard.zsa.enable = true;

  documentation = {
    dev.enable = true;
  };
}
