{ ... }:
let
  browser = [ "firefox.desktop" ];
  imageViewer = [ "imv.desktop" ];
  videoPlayer = [ "mpv.desktop" ];
in
{
  xdg = {
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "text/html" = browser;
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "image/jpeg" = imageViewer;
      "image/png" = imageViewer;
      "image/gif" = imageViewer;
      "image/webp" = imageViewer;
      "image/bmp" = imageViewer;
      "video/mp4" = videoPlayer;
      "video/mpeg" = videoPlayer;
      "video/x-matroska" = videoPlayer;
      "video/webm" = videoPlayer;
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "inode/directory" = [ "yazi-open.desktop" ];
    };
    desktopEntries.yazi-open = {
      name = "Yazi Opener";
      exec = "ghostty --title=Yazi -e yazi %u";
      mimeType = [ "inode/directory" ];
    };
  };
}
