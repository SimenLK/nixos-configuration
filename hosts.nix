{ pkgs, config, ... }:
let
  cfg = config.customize;
in
{
  networking.extraHosts = ''
    10.1.30.10 fs0-0 fs0-0.itpartner.intern
    10.1.30.10 fs1-0 fs1-0.itpartner.intern
    10.1.8.10  fs2-0 fs2-0.itpartner.intern

    10.1.30.80 psql1-0 psql1-0.itpartner.intern
    10.1.8.80 psql2-0 psql2-0.itpartner.intern

    10.1.8.50 k0-0 k0-0.itpartner.intern
    10.1.8.51 k0-1 k0-1.itpartner.intern
    10.1.8.52 k0-2 k0-2.itpartner.intern

    10.1.30.100 k1-0 k1-0.itpartner.intern
    10.1.30.101 k1-1 k1-1.itpartner.intern
    10.1.30.102 k1-2 k1-2.itpartner.intern
    10.1.30.103 k1-3 k1-3.itpartner.intern

    10.1.8.60 k2-0 k2-0.itpartner.intern
    10.1.8.61 k2-1 k2-1.itpartner.intern
    10.1.8.62 k2-2 k2-2.itpartner.intern
    10.1.8.63 k2-3 k2-3.itpartner.intern
    10.1.8.64 k2-4 k2-4.itpartner.intern

    192.168.38.113 omikron omikron.lynx.local

    10.0.0.154 ads-mysql
    10.0.0.90 ads-mysql01

    10.255.168.106 ads-mysql02
    10.255.168.107 ads-mysql03

    10.255.168.161 ads-postgres01

    10.255.168.199 ads1-master-0
  '';
}
