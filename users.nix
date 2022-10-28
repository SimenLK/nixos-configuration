{ pkgs, ... }:
let
  username = "simen";
in
{
  users.groups.admin = {};

  users.extraGroups = {
    ${username} = { gid = 1000; };
  };

  users.users.admin = {
    isSystemUser = true;
    group = "admin";
  };

  users.users.${username} = {
     isNormalUser = true;
     description = "Simen Kirkvik";
     home = "/home/${username}";
     group = "${username}";
     extraGroups = [
       "users"
       "wheel"
       "root"
       "adm"
       "cdrom"
       "docker"
       "fuse"
       "wireshark"
       "libvirtd"
       "networkmanager"
       "tty"
       "keys"
     ];
     createHome = true;
     useDefaultShell = false;
     shell = pkgs.fish;
     openssh.authorizedKeys.keys = [
       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2tox0uyFGfU1zPNU6yAVSoGOUkeU959aiTMrqu1U9MCCOP2o4IhZIlRpZ08XVnUU/AhycCUF4HgGqdcco8oIVX0P0Cn83KJoD/DOqAiz+1VwIUUV1ylrRdNqCgf4wnmLni3sUPHJdQnuq57+pzDDjHMr9CcBL2KzOHD/QanfR+jZmv9K3OS5oDcWquSCziXkpbkWQURPactmtyzGK2FRRxONZgYrB8gRTDstlWQg/t6GHNVelzuJ7SEf+t8pk/S2e/XAvfZyRJhrVJ35iZKpmxkIn5v0g1Z+z0yX/KRSAPRtNg9uM44cmto77MFx7iFs0CuleL3zHvRvZYW1ZnsKAiP07UkEK87luMpkTzFr9CSHJGpgk1RZYA3qidQti44n6NU9YRNhzO4v+KQE6XDqO80gZCJboSXr3fnYn/QHpPXzK5JcZNWmClyMURYj10qv9So3Fh0o3LV5GThA6JgN874vUywUZanPEdn8ePBcAsjLRzA4YBGEuvJCc6FELSuY2s+/pFba8NXQvrOdJKSRC0g5USQFfaWDln4Q4zZ1G5z76p1u6GtRWxvakkUQ0fze9KAW7msxeKaw+B7uMtyvCL8V2zEE8WKFP1sNyYEe7Sgp3RVfym2VPMNTZVhEImfM/3D+WbzfoJztnJvFKXeeMCcne4G8swyef3o1s3b+CvQ== ski027@uit.no"
     ];
  };
}
