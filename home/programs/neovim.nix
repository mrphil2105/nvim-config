{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      tree-sitter
      gcc # For Treesitter grammar compilation
      nodejs_22 # For Copilot
      lua-language-server
      nixd
      stylua
      nixfmt-rfc-style
      clang-tools
      rust-analyzer
      vscode-langservers-extracted
      vscode-extensions.vadimcn.vscode-lldb
      netcoredbg
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
