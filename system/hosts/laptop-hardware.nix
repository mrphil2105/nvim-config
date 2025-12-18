{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [
    "dm-snapshot"
    "cryptd"
  ];
  boot.initrd.luks.devices."cryptlvm".device = "/dev/disk/by-label/NIXOS_LUKS";
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_ROOT";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXOS_BOOT";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NIXOS_NIX";
    fsType = "ext4";
  };
  fileSystems."/var/lib/docker" = {
    device = "/dev/disk/by-label/NIXOS_DOCKER";
    fsType = "ext4";
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-label/NIXOS_HOME";
    fsType = "ext4";
  };
  swapDevices = [
    { device = "/dev/disk/by-label/NIXOS_SWAP"; }
  ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
