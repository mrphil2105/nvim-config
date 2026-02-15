{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ./hardware.nix
    ./nvidia.nix
    ./gaming.nix
    ../../system
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.lanzaboote.enable = true;
  boot.lanzaboote.pkiBundle = "/var/lib/sbctl";
  services.udev.packages = [ pkgs.wooting-udev-rules ];
  environment.systemPackages = [ pkgs.sbctl ];
  networking.hostName = "mrphil2105-NixDesktop";
  system.stateVersion = "25.05";
}
