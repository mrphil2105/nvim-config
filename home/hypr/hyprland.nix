{ ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$terminal" = "alacritty";
      "$fileManager" = "alacritty --class Yazi -e yazi";
      "$menu" = "walker";
      "$browser" = "firefox";
      "$lockScreen" = "hyprlock";
      monitor = [
        "eDP-1, 1920x1200, 0x0, 1"
      ];
      exec-once = [
        "hyprctl setcursor capitaine-cursors 32"
        "waybar & ferdium & $terminal & firefox & discord --start-minimized &"
      ];
      env = [
        "XCURSOR_SIZE,32"
        "HYPRCURSOR_SIZE,32"
      ];
      general = {
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
          "global, 1, 10, default"
          "border, 1, 4, easeOutQuint"
          "windows, 1, 2.5, easeOutQuint"
          "windowsIn, 1, 2.5, easeOutQuint, popin 80%"
          "windowsOut, 1, 2, linear, popin 80%"
          "fadeIn, 1, 1.5, almostLinear"
          "fadeOut, 1, 1.5, almostLinear"
          "fade, 1, 3, quick"
          "layers, 1, 3, easeOutQuint"
          "layersIn, 1, 3, easeOutQuint, fade"
          "layersOut, 1, 2.5, linear, fade"
          "fadeLayersIn, 1, 2, almostLinear"
          "fadeLayersOut, 1, 1.5, almostLinear"
          "workspaces, 1, 2.5, easeOutQuint, slide"
          "workspacesIn, 1, 2, easeOutQuint, slide"
          "workspacesOut, 1, 2.5, easeOutQuint, slide"
        ];
      };
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
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      master = {
        new_status = "master";
      };
      misc = {
        force_default_wallpaper = 1;
      };
      input = {
        kb_layout = "us,dk";
        kb_options = "caps:escape,grp:win_space_toggle";
      };
      "$mainMod" = "SUPER";
      bind = [
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, V, togglefloating,"
        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, S, togglesplit, # dwindle"
        "$mainMod, B, exec, $browser"
        "$mainMod, F, fullscreen"
        "$mainMod, Escape, exec, $lockScreen"

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
      bindm = [
        "$mainMod, mouse:272, resizewindow"
        "$mainMod, mouse:273, movewindow"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
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
        "suppressevent maximize, class:.*"
        # Fix some dragging issues with XWayland
        "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"
        # Fix flickering issues when hovering tooltips
        "noinitialfocus, class:(jetbrains-pycharm), title:^win.*"
        "workspace 3, class:firefox"
        "workspace 4, class:Yazi"
        "workspace 5, class:Ferdium"
        "workspace 6, class:discord"
        "workspace 7, class:Bitwarden"
        "workspace 7, class:Spotify"
      ];
    };
  };
}
