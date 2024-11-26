{ config, lib, ... }:
let
  cfg = config.features.cachix;

  configuration = {
    nix.settings.substituters = ["https://cache.nixos.org/"];
  };
in {
  options.features.cachix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable cachix";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable configuration)
  ];
}
