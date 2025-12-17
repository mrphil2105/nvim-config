{ ... }:
{
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.options = "eurosign:e,caps:escape";
  };
  programs.hyprland.enable = true;
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    autoLogin.enable = true;
    autoLogin.user = "mrphil2105";
    defaultSession = "hyprland";
  };
  hardware.graphics.enable = true;
  console.useXkbConfig = true;
}
