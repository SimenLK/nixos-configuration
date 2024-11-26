{ config, lib, pkgs, ... }:
let
  cfg = config.features.os;

  configuration = {
    networking = {
      networkmanager = {
        enable = cfg.networkmanager.enable;
        unmanaged = [ "interface-name:veth*" "interface-name:docker*" ];
      };
      firewall.trustedInterfaces = [ "docker0" "cbr0" "veth+" ];
    };

    users.extraUsers.admin.openssh.authorizedKeys.keys =
      cfg.adminAuthorizedKeys;

    users.extraUsers.root.openssh.authorizedKeys.keys =
      cfg.adminAuthorizedKeys;

    programs.vim.defaultEditor = true;
    programs.fish.enable = true;
    programs.tmux.enable = true;

    # Gamesss
    programs.steam.enable = false;

    services.openssh.enable = true;
    services.gvfs.enable = true;
    services.fwupd.enable = true;

    security.sudo.extraConfig = ''
      Defaults env_keep+=SSH_AUTH_SOCK
      Defaults lecture=never
      Defaults shell_noargs
      root   ALL=(ALL) SETENV: ALL
      %wheel ALL=(ALL) NOPASSWD: ALL, SETENV: ALL
    '';

    security.rtkit.enable = true;
    security.pam.services.sshd.googleAuthenticator.enable = true;

    # $ ecryptfs-migrate-home -u <username>
    # security.pam.enableEcryptfs = true;

    # The NixOS release to be compatible with for stateful data such as databases.
    system.stateVersion = "22.11";

    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [
      ];
    };

    boot = {
      tmp = {
        cleanOnBoot = true;
      };
      initrd.checkJournalingFS = false;
    };

    nix = {
      settings = {
        auto-optimise-store = true;
      };
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
  };

  docker = {
    virtualisation.docker.enable = cfg.docker.enable;
    virtualisation.docker.autoPrune.enable = true;
    virtualisation.docker.extraOptions = "--insecure-registry 10.0.0.0/8";
    networking = {
      nat.enable = true;
      nat.internalInterfaces = ["veth+"];
      nat.externalInterface =
        if cfg.externalInterface == null then []
        else cfg.externalInterface;
    };
  };

  mailRelay = {
    programs.msmtp = {
      enable = false;
    };
  };

  nfs = {
    networking = {
      firewall.allowedTCPPorts = [ 111 2049 ];
      firewall.allowedUDPPorts = [ 111 2049 24007 24008 ];
    };

    environment.systemPackages = with pkgs; [
      nfs-utils
    ];

    services.nfs.server = {
      enable = true;
      exports = cfg.nfs.exports;
    };
  };

in
{
  options.features.os = {
    networkmanager.enable = lib.mkEnableOption "Enable NetworkManager";

    docker.enable = lib.mkEnableOption "Enable Docker";

    externalInterface = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "External interface (i.e. for Docker nat)";
    };

    adminAuthorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    mailRelay = {
      enable = lib.mkEnableOption "Enable mail realy using msmtp";
    };

    nfs = {
      enable = lib.mkEnableOption "Enable nfs fileserver";

      exports = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
    };
  };

  config = lib.mkMerge [
    configuration

    (lib.mkIf cfg.docker.enable docker)

    (lib.mkIf cfg.mailRelay.enable mailRelay)

    (lib.mkIf cfg.nfs.enable nfs)
  ];
}
