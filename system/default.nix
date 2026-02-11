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
    ./fonts.nix
    ./virtualisation.nix
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.zsh.enable = true;
  programs.zsh.enableGlobalCompInit = false;
  programs.nix-ld.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.envfs.enable = true;
}
