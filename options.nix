{ pkgs, config }:
{
  hostName = "";
  desktop = true;
  private = true;
  uefi = true;
  bootdisk = "/dev/sda";
  eth="eno2";
  virtualization = "libvirt";
  kernelExtras =
    if false then
      with pkgs;
      let kernel = config.system.build.kernel; in
      import ./kernel.nix { inherit pkgs stdenv fetchurl kernel; }
    else {};
}