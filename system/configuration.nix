{ ... }:
{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./display.nix
    ./networking.nix
    ./locale.nix
    ./sound.nix
    ./auth.nix
    ./users.nix
    ./packages.nix
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.nix-ld.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.envfs.enable = true;
  services.power-profiles-daemon.enable = true;
  virtualisation.docker.enable = true;
  system.stateVersion = "25.11";
}
