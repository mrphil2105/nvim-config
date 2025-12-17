{ ... }:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      background = [
        {
          path = "screenshot";
          blur_passes = 4;
          blur_size = 8;
        }
      ];
      input-field = [
        {
          size = "400, 50";
          position = "0, 0";
          fade_on_empty = false;
          dots_center = false;
          outline_thickness = 3;
          shadow_passes = 3;
          outer_color = "rgb(24, 30, 38)";
          placeholder_text = "<i>Password</i>";
        }
      ];
    };
  };
}
