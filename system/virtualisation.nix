{ pkgs, ... }:
{
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];
  programs.virt-manager.enable = true;
  environment.systemPackages = [ pkgs.dnsmasq ];
}
