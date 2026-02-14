{ ... }:
{
  imports = [
    ./zsh.nix
    ./packages.nix
    ./cursor.nix
    ./gtk.nix
    ./notification.nix
    ./hypr
    ./waybar
    ./programs
  ];
  home.username = "mrphil2105";
  home.homeDirectory = "/home/mrphil2105";
  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.bat.enable = true;
}
