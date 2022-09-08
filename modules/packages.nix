{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.features.packages;

  nixpkgs.overlays = [
    (import ./overlays/nuta-nixer.nix)
  ];

  configuration = {
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
      libinput
      lshw
      lsof
      mesa_drivers
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
      ssmtp
      stdenv
      unzip
      wget
      xorg.xf86inputevdev
      xorg.xf86inputlibinput
      xorg.xf86inputmouse
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
