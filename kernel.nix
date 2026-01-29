{ pkgs, ...}:
let
in
  {
    nixpkgs.overlays = [];

    boot = {
      extraModulePackages = [];
    };
  }
