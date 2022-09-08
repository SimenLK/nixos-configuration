{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.features.packages;

  configuration = {
    nixpkgs.overlays = [
      (import ../overlays/nuta-nixer.nix)
    ];

    environment.systemPackages = with pkgs; [
      bc
      bind
      binutils
      cachix
      cifs-utils
      coreutils
      file
      findutils
      fuse
      gcc
      git
      gnupg
      google-authenticator
      home-manager
      inetutils
      iotop
      iputils
      keyutils
      lsof
      msmtp
      neovim-unwrapped
      netcat
      nettools
      nix-prefetch-git
      nixos-container
      nmap
      patchelf
      psmisc
      rsync
      sshuttle
      stdenv
      unzip
      wget
      zip
    ];
  };
in {
  options.features.packages = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable default system packages";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable configuration)
  ];
}
