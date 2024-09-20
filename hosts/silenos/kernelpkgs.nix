{pkgs, ...}: {
  boot.kernelPackages = pkgs.master.linuxPackages;
}
