{ config, ... }:
{
  imports = [
    ./hardware.nix
    ../../system
  ];
  networking.hostName = "mrphil2105-NixDesktop";
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
  system.stateVersion = "25.05";
}
