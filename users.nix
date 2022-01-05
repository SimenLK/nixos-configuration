{ pkgs, ... }:
{
  users.groups.admin = {};

  users.extraGroups = {
    simkir = { gid = 1000; };
  };

  users.users.admin = {
    isSystemUser = true;
    group = "admin";
  };

  users.users.simkir = {
     isNormalUser = true;
     description = "Simen Kirkvik";
     home = "/home/simkir";
     group = "simkir";
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
  };
}
