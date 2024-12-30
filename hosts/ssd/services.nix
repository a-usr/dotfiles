{
  pkgs,
  lib,
  config,
  ...
}:
{
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
    extraPackages = [
      pkgs.kdePackages.qt5compat
    ];
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
        package = nerd-fonts.hurmit;
      }
    ];
    extraConfig = "xkb-layout=de";
  };
  services.phpfpm.pools."local" = {
    user = app;
    settings = {
      "listen.owner" = config.services.nginx.user;
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 2;
      "pm.max_spare_servers" = 5;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
    phpEnv."PATH" = lib.makeBinPath [ pkgs.php ];
  };

  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      root = "/home/usr/src/websites";
      extraConfig = ''
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:${config.services.phpfpm.pools."local".socket};
        include ${pkgs.nginx}/conf/fastcgi.conf;
      '';
    };
  };
  systemd.services.nginx.wantedBy = lib.mkForce [ ];
  systemd.services.nginx-config-reload.wantedBy = lib.mkForce [ ];
}
