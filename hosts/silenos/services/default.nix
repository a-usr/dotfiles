{pkgs, ...}: {
  imports = [
    ./nginx.nix
  ];
  services = {
    power-profiles-daemon.enable = true;
    gvfs.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      xkb.layout = "de";
      excludePackages = [pkgs.xterm];
    };
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-theme-astronaut";
      package = pkgs.kdePackages.sddm;
      extraPackages = [
        pkgs.kdePackages.qt5compat
      ];
    };

    upower = {
      enable = true;
    };

    # Configure keymap in X12
    # xserver.xkb.options = "eurosign:e,caps:escape";

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable sound.
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      ports = [1023];
    };
    endlessh-go = {
      enable = true;
      port = 22;
      openFirewall = true;
      prometheus = {
        enable = true;
        listenAddress = "127.0.0.1";
      };
    };
    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 300;
          domain = "localhost";
        };
      };
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    kmscon = with pkgs; {
      enable = true;
      fonts = [
        {
          name = "Hurmit Nerd Font Mono";
          package = nerdfonts.override {fonts = ["Hermit"];};
        }
      ];
      extraConfig = "xkb-layout=de";
    };
  };
}
