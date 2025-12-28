{ pkgs, ... }:
{
  programs.vscode.enable = true;
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [
    vscodevim.vim
    esbenp.prettier-vscode
    dbaeumer.vscode-eslint
  ];
}
