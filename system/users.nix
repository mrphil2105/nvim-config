{ pkgs, ... }:
{
  users.users.mrphil2105 = {
    shell = pkgs.zsh;
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "libvirtd"
    ];
  };
}
