{ config, pkgs, ... }:
{
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  services.lact.enable = true;
  programs.obs-studio.package = pkgs.obs-studio.override { cudaSupport = true; };
}
