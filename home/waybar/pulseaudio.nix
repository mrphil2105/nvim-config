{ ... }:
{
  programs.waybar.settings.main.pulseaudio = {
    format = "{icon} {volume}%";
    format-bluetooth = "{icon} {volume}%";
    format-muted = "󰝟";
    format-icons = {
      default = [
        "󰕿"
        "󰖀"
        "󰕾"
      ];
      headphone = "󰋋";
      headset = "󰋋";
    };
  };
}
