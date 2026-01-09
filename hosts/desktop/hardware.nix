{
  lib,
  config,
  pkgs,
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
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.systemd-boot.extraInstallCommands = ''
    if [ -d /mnt/windows-esp/EFI/Microsoft ]; then
      ${pkgs.coreutils}/bin/rm -rf /boot/EFI/Microsoft
      ${pkgs.coreutils}/bin/cp -r /mnt/windows-esp/EFI/Microsoft /boot/EFI/
    fi
  '';
  boot.loader.systemd-boot.extraEntries."windows.conf" = ''
    title   Windows 11
    efi     /EFI/Microsoft/Boot/bootmgfw.efi
    sort-key 00-windows
  '';
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
  fileSystems."/mnt/windows-esp" = {
    device = "/dev/disk/by-partuuid/1b1ae122-13f6-4e45-b207-577448758e16";
    fsType = "vfat";
    options = [
      "nofail"
      "x-systemd.automount"
      "umask=0077"
    ];
  };
  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
