{ ... }:
{
  programs.waybar.settings.main.battery = {
    states = {
      good = 80;
      warning = 30;
      critical = 20;
    };
    format = "{icon} {capacity}%";
    format-charging = " {capacity}%";
    format-icons = [
      "󰂎"
      "󰁻"
      "󰁼"
      "󰁽"
      "󰁾"
      "󰁿"
      "󰂀"
      "󰂁"
      "󰂂"
      "󰁹"
    ];
    tooltip-format = "Discharging: {time}";
    tooltip-format-charging = "Charging: {time}";
    interval = 30;
  };
}
