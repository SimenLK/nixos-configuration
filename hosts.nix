{ pkgs, config, ... }:
let
  cfg = config.customize;
in
{
  networking.extraHosts = ''
    192.168.38.113 omikron omikron.lynx.local
  '';
}
