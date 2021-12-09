{ pkgs, ... }:
{
  users.extraGroups = {
    simkir = { gid = 1000; };
  };

  users.users.admin = {
    isSystemUser = true;
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
