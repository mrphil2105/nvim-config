{ ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      fit-to-screen = false;
      control-center-height = 420;
    };
    style = ''
      .notification {
        margin-top: 6px;
        margin-bottom: 6px;
        border-radius: 4px;
      }
      .notification-content {
        padding: 6px 8px;
      }
      .notification-default-action {
        border-radius: 0;
      }
      .close-button {
        margin-top: 9px;
        margin-right: 3px;
      }
    '';
  };
}
