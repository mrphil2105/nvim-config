{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
    ];
  };
}
