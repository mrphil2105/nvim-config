{ ... }:
{
  programs.ghostty.enable = true;
  programs.ghostty.settings = {
    background = "#181818";
    window-padding-x = 0;
    window-padding-y = 0;
    font-family = "JetBrainsMonoNL NF";
    font-family-bold = "JetBrainsMonoNL NF";
    font-family-italic = "JetBrainsMonoNL NF";
    font-family-bold-italic = "JetBrainsMonoNL NF";
    font-size = 12;
    link-previews = false;
    resize-overlay = "never";
    app-notifications = "no-clipboard-copy";
    window-decoration = "none";
  };
}
