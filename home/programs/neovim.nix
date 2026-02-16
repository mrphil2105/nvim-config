{ config, pkgs, ... }:
let
  nvimFiles = [
    "lua/config"
    "lua/plugins"
    "lua/utils"
    "init.lua"
    "lazy-lock.json"
    "stylua.toml"
  ];
  dotfilesDir = "${config.home.homeDirectory}/.nixos/dotfiles/nvim";
in
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
      pyright
      rust-analyzer
      stylua
      tex-fmt
      texlab
      tree-sitter
      typescript-go
      vscode-extensions.vadimcn.vscode-lldb
      vscode-langservers-extracted
      (python3.withPackages (
        ps: with ps; [
          black
          cssbeautifier
          debugpy
        ]
      ))
    ];
    extraLuaPackages = ps: [
      ps.lua-toml
      ps.xml2lua
    ];
  };
  xdg.configFile =
    (builtins.listToAttrs (
      map (fileName: {
        name = "nvim/${fileName}";
        value = {
          source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${fileName}";
        };
      }) nvimFiles
    ))
    // {
      "nvim/lua/hm-generated.lua".text = config.programs.neovim.initLua;
    };
}
