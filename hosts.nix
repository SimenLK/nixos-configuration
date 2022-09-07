{ pkgs, config, ... }:
let
  cfg = config.customize;
in
{
  networking.extraHosts = ''
    192.168.1.14 omikron

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

    10.255.241.80  nfs0  nfs0.cluster.local↲
    10.255.241.90  beegfs0 beegfs0.cluster.local↲
    10.255.241.100 ekman ekman.cluster.local↲
    10.255.241.100 etcd0 etcd0.cluster.local↲
    10.255.241.101 c0-1  c0-1.cluster.local↲
    10.255.241.102 c0-2  c0-2.cluster.local↲
    10.255.241.103 c0-3  c0-3.cluster.local↲
    10.255.241.104 c0-4  c0-4.cluster.local↲
    10.255.241.105 c0-5  c0-5.cluster.local↲
    10.255.241.106 c0-6  c0-6.cluster.local↲
    10.255.241.107 c0-7  c0-7.cluster.local↲
    10.255.241.108 c0-8  c0-8.cluster.local↲
    10.255.241.109 c0-9  c0-9.cluster.local↲
    10.255.241.110 c0-10 c0-10.cluster.local↲
    10.255.241.111 c0-11 c0-1.cluster.local↲
    10.255.241.112 c0-12 c0-12.cluster.local↲
    10.255.241.113 c0-13 c0-13.cluster.local↲
    10.255.241.114 c0-14 c0-14.cluster.local↲
    10.255.241.115 c0-15 c0-15.cluster.local↲
    10.255.241.116 c0-16 c0-16.cluster.local↲
↲
    10.255.243.80  ibnfs0  ibnfs0.cluster.local↲
    10.255.243.90  ibbeegfs0 ibbeegfs0.cluster.local
    10.255.243.100 ibekman ibekman.cluster.local↲
    10.255.243.100 ibetcd0 ibetcd0.cluster.local↲
    10.255.243.101 ib0-1  ib0-1.cluster.local↲
    10.255.243.102 ib0-2  ib0-2.cluster.local↲
    10.255.243.103 ib0-3  ib0-3.cluster.local↲
    10.255.243.104 ib0-4  ib0-4.cluster.local↲
    10.255.243.105 ib0-5  ib0-5.cluster.local↲
    10.255.243.106 ib0-6  ib0-6.cluster.local↲
    10.255.243.107 ib0-7  ib0-7.cluster.local↲
    10.255.243.108 ib0-8  ib0-8.cluster.local↲
    10.255.243.109 ib0-9  ib0-9.cluster.local↲
    10.255.243.110 ib0-10 ib0-10.cluster.local↲
    10.255.243.111 ib0-11 ib0-1.cluster.local↲
    10.255.243.112 ib0-12 ib0-12.cluster.local↲
    10.255.243.113 ib0-13 ib0-13.cluster.local↲
    10.255.243.114 ib0-14 ib0-14.cluster.local↲
    10.255.243.115 ib0-15 ib0-15.cluster.local↲
    10.255.243.116 ib0-16 ib0-16.cluster.local↲
  '';
}
