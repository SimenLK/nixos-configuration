{ pkgs, stdenv, fetchurl, config, ...}:
let
in
  {
    nixpkgs.overlays = [];

    boot = {
      extraModulePackages = [
        config.boot.kernelPackages.xone
      ];
      # kernelPackages = pkgs.linuxPackages_5_9;
    };
  }
