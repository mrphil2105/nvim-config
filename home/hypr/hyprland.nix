{ pkgs, ... }:
let
  switchLayoutFile = pkgs.writeShellScript "switch-layout.sh" (builtins.readFile ./switch-layout.sh);
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$terminal" = "alacritty";
      "$fileManager" = "alacritty --class Yazi -e yazi";
      "$audioMixer" = "alacritty --class wiremix -e wiremix --tab output";
      "$menu" = "walker";
      "$browser" = "firefox";
      "$lockScreen" = "hyprlock";
      exec-once = [
        "hyprctl setcursor capitaine-cursors 32"
        "waybar & ferdium & $terminal & firefox &"
      ];
      env = [
        "XCURSOR_SIZE,32"
        "HYPRCURSOR_SIZE,32"
      ];
      general = {
        layout = "master";
        gaps_in = 2;
        gaps_out = 4;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };
      decoration = {
        rounding = 4;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
        blur = {
          enabled = false;
        };
      };
      animations = {
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 2.5, default"
          "windows, 1, 2, easeOutQuint"
          "windowsIn, 1, 1.5, easeOutQuint, popin 80%"
          "windowsOut, 1, 2, linear, popin 80%"
          "fadeIn, 0, 1.5, almostLinear"
          "fadeOut, 1, 2, almostLinear"
          "fade, 1, 2, quick"
          "layers, 1, 2, easeOutQuint"
          "layersIn, 0, 1.5, easeOutQuint, fade"
          "layersOut, 1, 2, linear, fade"
          "fadeLayersIn, 0, 1.5, almostLinear"
          "fadeLayersOut, 1, 2, almostLinear"
          "workspaces, 1, 2, easeOutQuint, slide"
          "workspacesIn, 1, 1.5, easeOutQuint, slide"
          "workspacesOut, 1, 2, easeOutQuint, slide"
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      misc = {
        force_default_wallpaper = 1;
        enable_anr_dialog = false;
      };
      input = {
        kb_layout = "us,dk";
        kb_options = "caps:escape,grp:win_space_toggle";
        accel_profile = "flat";
      };
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, F, fullscreen"
        "$mainMod, V, togglefloating,"

        "$mainMod, Q, exec, $terminal"
        "$mainMod, R, exec, $menu"
        "$mainMod, B, exec, $browser"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, A, exec, $audioMixer"
        "$mainMod, D, exec, ${switchLayoutFile}"
        "$mainMod, Escape, exec, $lockScreen"

        "$mainMod, S, layoutmsg, swapwithmaster # master"
        "$mainMod, N, layoutmsg, cyclenext # master"
        "$mainMod, P, layoutmsg, cycleprev # master"
        "$mainMod SHIFT, N, layoutmsg, swapnext # master"
        "$mainMod SHIFT, P, layoutmsg, swapprev # master"
        "$mainMod, S, layoutmsg, togglesplit # dwindle"

        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod, T, workspace, 11"
        "$mainMod, Y, workspace, 12"
        "$mainMod, U, workspace, 13"
        "$mainMod, I, workspace, 14"
        "$mainMod, O, workspace, 15"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod SHIFT, T, movetoworkspace, 11"
        "$mainMod SHIFT, Y, movetoworkspace, 12"
        "$mainMod SHIFT, U, movetoworkspace, 13"
        "$mainMod SHIFT, I, movetoworkspace, 14"
        "$mainMod SHIFT, O, movetoworkspace, 15"

        "$mainMod, W, togglespecialworkspace, magic"
        "$mainMod SHIFT, W, movetoworkspace, special:magic"

        ", PRINT, exec, hyprshot -m output --clipboard-only"
        "$mainMod, PRINT, exec, hyprshot -m window --clipboard-only"
        "$mainMod SHIFT, PRINT, exec, hyprshot -m region --clipboard-only"
      ];
      binde = [
        "$mainMod CONTROL, H, resizeactive, -50 0"
        "$mainMod CONTROL, L, resizeactive, 50 0"
        "$mainMod CONTROL, K, resizeactive, 0 -30"
        "$mainMod CONTROL, J, resizeactive, 0 30"
      ];
      bindm = [
        "$mainMod, mouse:272, resizewindow"
        "$mainMod, mouse:273, movewindow"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];
      bindl = [
        ", switch:Lid Switch, exec, hyprlock"
        ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
        ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, 1920x1200, 0x0, 1\""
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
      windowrule = [
        "match:class .*, suppress_event maximize"
        # Fix some dragging issues with XWayland
        "match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false, no_focus on"
        # Fix flickering issues when hovering tooltips
        "match:class jetbrains-pycharm, match:title ^win.*, no_initial_focus on"
        "match:class firefox, workspace 3"
        "match:class Yazi, workspace 4"
        "match:class Ferdium, workspace 5"
        "match:class Bitwarden, workspace 7"
      ];
    };
  };
}
