{ config, pkgs, ... }:
{
  imports = [
    ./nginx.nix
  ];
  services = {
    power-profiles-daemon.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = false;
      xkb.layout = "us";
      excludePackages = [ pkgs.xterm ];
      windowManager.i3 = {
        # enable = true;
        extraPackages = with pkgs; [
          dmenu # application launcher most people use
          i3status # gives you the default i3 status bar
          i3lock # default i3 screen locker
          i3blocks # if you are planning on using i3blocks over i3status
        ];
      };

    };

    # displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    #   theme = "sddm-theme-astronaut";
    #   package = pkgs.kdePackages.sddm;
    #   extraPackages = [
    #     pkgs.kdePackages.qt5compat
    #   ];
    # };

    upower = {
      enable = true;
    };

    udev.packages = with pkgs; [
      pkgs.yubikey-personalization
      (pkgs.writeTextFile {
        name = "solo2_udev";
        text = ''
          # NXP LPC55 ROM bootloader (unmodified)
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0021", TAG+="uaccess"
          # NXP LPC55 ROM bootloader (with Solo 2 VID:PID)
          SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="b000", TAG+="uaccess"
          # Solo 2
          SUBSYSTEM=="tty", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="beee", TAG+="uaccess"
          # Solo 2
          SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="beee", TAG+="uaccess"
        '';
        destination = "/etc/udev/rules.d/70-solo2.rules";
      })
      (callPackage ../../../../nixpkgs/by-name/wo/wooting-udev-rules/package.nix { })
    ];

    # Configure keymap in X12
    # xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable sound.

  };
}
