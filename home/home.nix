{ ... }:
{
  imports = [
    ./packages.nix
    ./hypr/hyprland.nix
    ./hypr/hyprlock.nix
    ./hypr/hypridle.nix
    ./hypr/hyprshot.nix
    ./waybar.nix
    ./walker.nix
    ./cursor.nix
    ./bash.nix
    ./git.nix
    ./alacritty.nix
    ./yazi.nix
    ./neovim.nix
    ./tmux.nix
    ./vscode.nix
  ];
  home.username = "mrphil2105";
  home.homeDirectory = "/home/mrphil2105";
  programs.firefox.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
