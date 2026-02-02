{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      clang-tools
      gcc # For Treesitter grammar compilation
      lua-language-server
      netcoredbg
      nixd
      nixfmt
      nodejs_22 # For Copilot
      rust-analyzer
      stylua
      tree-sitter
      typescript-go
      vscode-extensions.vadimcn.vscode-lldb
      vscode-langservers-extracted
      (python3.withPackages (
        ps: with ps; [
          python-lsp-server
          black
          cssbeautifier
        ]
      ))
    ];
    extraLuaPackages = ps: [
      ps.lua-toml
      ps.xml2lua
    ];
  };
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nixos/dotfiles/nvim";
}
