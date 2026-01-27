{ pkgs, ... }:
{
  imports = [ ../../home ];
  home.packages = with pkgs; [
    mangohud
    nvtopPackages.nvidia
    prismlauncher
    satisfactorymodmanager
    wootility
  ];
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "DP-6, 2560x1440@144, 0x0, 1"
      "HDMI-A-2, 1920x1080, 2560x360, 1"
    ];
    workspace = [
      "1, monitor:DP-6"
      "2, monitor:DP-6"
      "3, monitor:DP-6"
      "4, monitor:DP-6"
      "5, monitor:DP-6"
      "6, monitor:DP-6"
      "7, monitor:DP-6"
      "8, monitor:DP-6"
      "9, monitor:DP-6"
      "10, monitor:DP-6"
      "11, monitor:HDMI-A-2"
      "12, monitor:HDMI-A-2"
      "13, monitor:HDMI-A-2"
      "14, monitor:HDMI-A-2"
      "15, monitor:HDMI-A-2"
    ];
    exec-once = [
      "vesktop --ozone-platform=wayland & spotify & steam -silent &"
    ];
    windowrule = [
      "match:class steam, workspace 6"
      "match:class vesktop, workspace 14"
      "match:class Spotify, workspace 15"
      "match:class ^(steam_app_\\d+|gamescope|cs2)$, monitor DP-6"
      "match:class ^(steam_app_\\d+|gamescope|cs2)$, fullscreen on"
      "match:class ^(steam_app_\\d+|gamescope|cs2)$, workspace 10"
      "match:class ^(steam_app_\\d+|gamescope|cs2)$, content game"
    ];
    env = [
      "LIBVA_DRIVER_NAME,nvidia"
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    ];
    general.allow_tearing = true;
    misc.vrr = 3;
  };
  home.stateVersion = "25.05";
}
