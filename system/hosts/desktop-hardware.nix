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
    "ahci"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS-ROOT";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXOS-BOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NIXOS-NIX";
    fsType = "ext4";
  };
  fileSystems."/var/lib/docker" = {
    device = "/dev/disk/by-label/NIXOS-DOCKER";
    fsType = "ext4";
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-label/NIXOS-HOME";
    fsType = "ext4";
  };
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-label/Games";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "rw"
      "user"
      "exec"
      "umask=000"
    ];
  };
  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
