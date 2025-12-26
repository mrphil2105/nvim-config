{ ... }:
{
  imports = [
    ./boot.nix
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
  virtualisation.docker.enable = true;
}
