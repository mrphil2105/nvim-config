{ ... }:
{
  programs.waybar.settings.main.power-profiles-daemon = {
    format = "{icon}";
    format-icons = {
      default = "";
      performance = "";
      balanced = "";
      power-saver = "󰌪";
    };
    tooltip = false;
  };
}
