{ ... }:
{
  networking.hostName = "mrphil2105-NixLaptop";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.openvpn.servers = {
    router = {
      config = ''config /home/mrphil2105/.openvpn/router.ovpn'';
      autoStart = true;
    };
  };
  # https://kisonecat.com/blog/eduroam-openssl-wpa-supplicant/
  nixpkgs.config.packageOverrides = pkgs: {
    wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
      patches = attrs.patches ++ [ ./eduroam.patch ];
    });
  };
}
