{ pkgs, ... }:
{
  users.extraGroups = {
    simkir = { gid = 1000; };
  };

  users.extraUsers.simkir = {
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
     uid = 1000;
     isNormalUser = true;
     createHome = true;
     useDefaultShell = false;
     shell = pkgs.fish;
  };
}
