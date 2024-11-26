{ pkgs, config, lib, ... }:
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
      nix-search-cli
      nixos-container
      nmap
      patchelf
      psmisc
      rsync
      sshuttle
      stdenv
      unzip
      wget
      xorg.xf86inputevdev
      xorg.xf86inputlibinput
      xorg.xf86inputmouse
      zip
    ];
  };

  devel = {
    environment.systemPackages = with pkgs; [
      man-pages
      man-pages-posix
    ];

    documentation.dev.enable = true;
  };
in {
  options.features.packages = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable default system packages";
    };
    devel.enable = lib.mkEnableOption "Enable Linux API development man pages";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable configuration)
    (lib.mkIf cfg.devel.enable devel)
  ];
}
