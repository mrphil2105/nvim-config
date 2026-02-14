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
    libnotify
    net-tools
    npins
    ouch
    p7zip
    pciutils
    playerctl
    rclone
    ripgrep
    texliveFull
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
    brave
    ferdium
    gimp3
    kdePackages.okular
    krita
    libreoffice-qt-fresh
    megasync
    mpv
    signal-desktop-bin
    slack
    spotify
    tor-browser
    vesktop
    vlc
    yubioath-flutter
    zathura
    zoom-us

    # Development tools
    bruno
    chromium
    dbeaver-bin
    python3
  ];
}
