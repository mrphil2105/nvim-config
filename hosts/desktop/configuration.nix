{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
    ./nvidia.nix
    ../../system
  ];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  networking.hostName = "mrphil2105-NixDesktop";
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = [ pkgs.proton-ge-bin ];
  programs.gamescope.enable = true;
  programs.gamescope.package = pkgs.gamescope.overrideAttrs (old: {
    # Fix blurry output
    NIX_CFLAGS_COMPILE = [ "-fno-fast-math" ];
    # Disable explicit sync because it does not work with Nvidia
    patches = old.patches ++ [ ./gamescope.patch ];
  });
  system.stateVersion = "25.05";
}
