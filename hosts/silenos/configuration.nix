# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  unstable,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.hyprland.nixosModules.default
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  networking.hostName = "silenos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.registry = {
    nixpkgs.to = {
      type = "path";
      path = pkgs.path;
      narHash =
        builtins.readFile
        (pkgs.runCommandLocal "get-nixpkgs-hash"
          {nativeBuildInputs = [pkgs.nix];}
          "nix-hash --type sha256 --sri ${pkgs.path} > $out");
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    keyMap = "de";
    #   useXkbConfig = true; # use xkb.options in tty.
  };
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Hermit"];})
    (callPackage ../../nixpkgs/fonts/Phosphor.nix {})
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.hyprland = {
    enable = true;
    #package = pkgs.trunk.hyprland;
    #enableNvidiaPatches = true;
  };

  programs.gamemode.enable = true;

  # list packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    fontconfig
    git
    cliphist
    wl-clipboard
    wl-clip-persist
    nix-prefetch-github
    kdePackages.qt5compat
    (qt6.callPackage ../../nixpkgs/sddmThemes/sddm-astronaut-theme.nix {})
    spotify
    pamixer
    inputs.niqspkgs.packages."x86_64-linux".bibata-hyprcursor
    nix-output-monitor
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [1023];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  hardware = {
    nvidia = {
      modesetting.enable = true;

      powerManagement.enable = false;
      powerManagement.finegrained = false;

      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    bluetooth = {
      enable = true;
      settings.General.Experimental = true;
    };

    xone = {
      enable = true;
    };

    xpadneo = {
      enable = true;
    };
    sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan pkgs.utsushi];
    };
  };
  services.udev.packages = [pkgs.utsushi];

  services.xserver.videoDrivers = ["nvidia"];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "spotify"
      "steam"
      "steam-original"
      "steam-run"
      "xow_dongle-firmware"
      "vscode"
    ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
