{ ... }:
{
  users.users.mrphil2105 = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };
}
