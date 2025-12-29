{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Core utilities
    brightnessctl
    file
    fzf
    gptfdisk
    jq
    net-tools
    pciutils
    playerctl
    rclone
    ripgrep
    tldr
    tree
    unzip
    usbutils
    wiremix
    wl-clipboard
    zip

    # System monitoring
    btop
    htop
    iftop
    iotop

    # Networking
    openfortivpn

    # Desktop applications
    bitwarden-desktop
    discord
    ferdium
    gimp3
    kdePackages.okular
    krita
    libreoffice-qt-fresh
    megasync
    signal-desktop-bin
    slack
    spotify
    vlc
    yubioath-flutter
    zoom-us

    # Development tools
    bruno
    chromium
    dbeaver-bin
    python3
  ];
}
