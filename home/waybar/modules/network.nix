{ ... }:
{
  programs.waybar.settings.main.network = {
    format = "{ifname}";
    format-wifi = "{icon}";
    format-ethernet = "";
    format-disconnected = "";
    format-icons = [
      "󰤯"
      "󰤟"
      "󰤢"
      "󰤥"
      "󰤨"
    ];
    tooltip-format = "{ifname}";
    tooltip-format-wifi = "{essid} ({signalStrength}%)";
    tooltip-format-disconnected = "Disconnected";
  };
}
