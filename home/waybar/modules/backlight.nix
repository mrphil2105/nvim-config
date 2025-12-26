{ ... }:
{
  programs.waybar.settings.main.backlight = {
    format = "{icon} {percent}%";
    format-icons = [
      "󰃜"
      "󰃛"
      "󰃚"
    ];
    tooltip = false;
  };
}
