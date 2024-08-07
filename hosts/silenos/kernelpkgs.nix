{pkgs, ...}: {
  boot.kernelPackages = pkgs.trunk.linuxPackages;
}
