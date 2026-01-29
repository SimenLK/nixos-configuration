{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.features.packages;

  configuration = {
    environment.systemPackages = with pkgs; [
      bc
      bind
      binutils
      cifs-utils
      coreutils
      ffmpeg
      file
      findutils
      fuse
      gcc
      gitFull
      gnupg
      google-authenticator
      home-manager
      inetutils
      iotop
      iputils
      keyutils
      lsof
      man-pages
      man-pages-posix
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
      zellij
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
