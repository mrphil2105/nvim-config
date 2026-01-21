{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      _0xpropo
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
    fontconfig.useEmbeddedBitmaps = true;
    fontconfig.defaultFonts = {
      monospace = [ "JetBrainsMono Nerd Font" ];
    };
  };
}
