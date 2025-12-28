{ ... }:
{
  imports = [ ../../home ];
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "eDP-1, 1920x1200, 0x0, 1"
    ];
    workspace = [
      "1, monitor:eDP-1"
      "2, monitor:eDP-1"
      "3, monitor:eDP-1"
      "4, monitor:eDP-1"
      "5, monitor:eDP-1"
      "6, monitor:eDP-1"
      "7, monitor:eDP-1"
      "8, monitor:eDP-1"
      "9, monitor:eDP-1"
      "10, monitor:eDP-1"
    ];
    exec-once = [
      "discord --start-minimized &"
    ];
    windowrule = [
      "workspace 6, class:discord"
      "workspace 7, class:Spotify"
    ];
  };
  programs.zsh.shellAliases = {
    startvpn = "sudo systemctl start openvpn-router.service";
    stopvpn = "sudo systemctl stop openvpn-router.service";
  };
  home.stateVersion = "25.11";
}
