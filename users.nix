{ pkgs, ... }:
{
  users.extraGroups = {
    admin = { gid = 10000; };
    simen = { gid = 1000; };
  };

  users.extraUsers.admin = {
     description = "Administrator";
     home = "/home/admin";
     group = "admin";
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
     uid = 10000;
     isNormalUser = true;
     createHome = true;
     useDefaultShell = false;
     shell = pkgs.fish;
     openssh.authorizedKeys.keys = [
       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKiAS30ZO+wgfAqDE9Y7VhRunn2QszPHA5voUwo+fGOf jonas-3"
       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDULdlLC8ZLu9qBZUYsjhpr6kv5RH4yPkekXQdD7prkqapyoptUkO1nOTDwy7ZsKDxmp9Zc6OtdhgoJbowhGW3VIZPmooWO8twcaYDpkxEBLUehY/n8SlAwBtiHJ4mTLLcynJMVrjmTQLF3FeWVof0Aqy6UtZceFpLp1eNkiHTCM3anwtb9+gfr91dX1YsAOqxqv7ooRDu5rCRUvOi4OvRowepyuBcCjeWpTkJHkC9WGxuESvDV3CySWkGC2fF2LHkAu6SFsFE39UA5ZHo0b1TK+AFqRFiBAb7ULmtuno1yxhpBxbozf8+Yyc7yLfMNCyBpL1ci7WnjKkghQv7yM1xN2XMJLpF56v0slSKMoAs7ThoIlmkRm/6o3NCChgu0pkpNg/YP6A3HfYiEDgChvA6rAHX6+to50L9xF3ajqk4BUzWd/sCk7Q5Op2lzj31L53Ryg8vMP8hjDjYcgEcCCsGOcjUVgcsmfC9LupwRIEz3aF14AWg66+3zAxVho8ozjes= jonas.juselius@juselius.io"
     ];
  };

  users.extraUsers.simen = {
     description = "Simen Kirkvik";
     home = "/home/simen";
     group = "simen";
     extraGroups = [
       "users"
       "wheel"
       "root"
       "adm"
       "cdrom"
       "docker"
       "containerd"
       "fuse"
       "wireshark"
       "libvirtd"
       "networkmanager"
       "video"
       "render"
       "tty"
     ];
     uid = 1000;
     isNormalUser = true;
     createHome = true;
     useDefaultShell = false;
     shell = pkgs.fish;
     openssh.authorizedKeys.keys = [
       "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2tox0uyFGfU1zPNU6yAVSoGOUkeU959aiTMrqu1U9MCCOP2o4IhZIlRpZ08XVnUU/AhycCUF4HgGqdcco8oIVX0P0Cn83KJoD/DOqAiz+1VwIUUV1ylrRdNqCgf4wnmLni3sUPHJdQnuq57+pzDDjHMr9CcBL2KzOHD/QanfR+jZmv9K3OS5oDcWquSCziXkpbkWQURPactmtyzGK2FRRxONZgYrB8gRTDstlWQg/t6GHNVelzuJ7SEf+t8pk/S2e/XAvfZyRJhrVJ35iZKpmxkIn5v0g1Z+z0yX/KRSAPRtNg9uM44cmto77MFx7iFs0CuleL3zHvRvZYW1ZnsKAiP07UkEK87luMpkTzFr9CSHJGpgk1RZYA3qidQti44n6NU9YRNhzO4v+KQE6XDqO80gZCJboSXr3fnYn/QHpPXzK5JcZNWmClyMURYj10qv9So3Fh0o3LV5GThA6JgN874vUywUZanPEdn8ePBcAsjLRzA4YBGEuvJCc6FELSuY2s+/pFba8NXQvrOdJKSRC0g5USQFfaWDln4Q4zZ1G5z76p1u6GtRWxvakkUQ0fze9KAW7msxeKaw+B7uMtyvCL8V2zEE8WKFP1sNyYEe7Sgp3RVfym2VPMNTZVhEImfM/3D+WbzfoJztnJvFKXeeMCcne4G8swyef3o1s3b+CvQ== ski027@uit.no"
     ];
  };
}
