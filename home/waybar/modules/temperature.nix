{ ... }:
{
  programs.waybar.settings.main.temperature = {
    format = " {}°C";
    tooltip = false;
    interval = 5;
  };
}
