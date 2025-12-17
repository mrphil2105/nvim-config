{ ... }:
{
  imports = [
    ./waybar/clock.nix
    ./waybar/cpu.nix
    ./waybar/memory.nix
    ./waybar/temperature.nix
    ./waybar/language.nix
    ./waybar/pulseaudio.nix
    ./waybar/network.nix
    ./waybar/power.nix
    ./waybar/battery.nix
    ./waybar/backlight.nix
  ];
  programs.waybar = {
    enable = true;
    style = ./waybar.css;
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
      ];
    };
  };
}
