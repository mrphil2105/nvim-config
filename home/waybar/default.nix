{ ... }:
{
  imports = [
    ./modules/clock.nix
    ./modules/cpu.nix
    ./modules/memory.nix
    ./modules/temperature.nix
    ./modules/language.nix
    ./modules/pulseaudio.nix
    ./modules/network.nix
    ./modules/power.nix
    ./modules/battery.nix
    ./modules/backlight.nix
    ./modules/notification.nix
  ];
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings.main = {
      layer = "top";
      modules-left = [
        "tray"
        "clock"
        "cpu"
        "memory"
        "temperature"
        "hyprland/language"
      ];
      modules-center = [
        "hyprland/workspaces"
      ];
      modules-right = [
        "pulseaudio"
        "network"
        "power-profiles-daemon"
        "battery"
        "backlight"
        "custom/notification"
      ];
    };
  };
}
