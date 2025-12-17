{ ... }:
{
  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 180;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
