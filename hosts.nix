{ pkgs, config, ... }:
let
  cfg = config.customize;
in
{
  networking.extraHosts = ''
    192.168.1.147 omikron
  '';
}
