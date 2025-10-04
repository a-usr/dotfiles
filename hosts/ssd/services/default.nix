{pkgs, ...}: {
  imports = [
    ./nginx.nix
  ];
  services.power-profiles-daemon.enable = true;
  services.gvfs.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "de";
  };
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-theme-astronaut";
    package = pkgs.kdePackages.sddm;
  };

  services.upower = {
    enable = true;
  };

  # Configure keymap in X12
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.kmscon = with pkgs; {
    enable = true;
    fonts = [
      {
        name = "Hurmit Nerd Font Mono";
        package = nerdfonts.override {fonts = ["Hermit"];};
      }
    ];
    extraConfig = "xkb-layout=de";
  };
}
