{ ... }:
{
  imports = [
    ./bash.nix
    ./packages.nix
    ./cursor.nix
    ./hypr
    ./waybar
    ./programs
  ];
  home.username = "mrphil2105";
  home.homeDirectory = "/home/mrphil2105";
  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.tmux.enable = true;
}
