{
  pkgs,
  lib,
  config,
  ...
}:
let
  app = "localhost";
  domain = "${app}";
  dataDir = "/srv/http/${domain}";
in
{
  services.phpfpm.pools.${app} = {
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
    user = app;
    enable = true;
    virtualHosts.${domain} = {
      locations."/" = {
        root = dataDir;
        extraConfig = ''
          try_files $uri $uri/ =404;
        '';
      };
      locations."~ \\.php$" = {
        root = dataDir;
        extraConfig = ''
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          fastcgi_pass unix:${config.services.phpfpm.pools.${app}.socket};
          include ${pkgs.nginx}/conf/fastcgi.conf;
        '';
      };

      locations."~ /\\.ht" = {
        root = dataDir;
        extraConfig = "deny all;";
      };
    };
  };
  users.users.${app} = {
    isSystemUser = true;
    createHome = true;
    home = dataDir;
    group = app;
  };
  users.groups.${app} = { };
  systemd.services.nginx.wantedBy = lib.mkForce [ ];
  systemd.services.phpfpm-localhost.wantedBy = lib.mkForce [ ];
  systemd.services."phpfpm.slice".wantedBy = lib.mkForce [ ];
  systemd.services."phpfpm.target".wantedBy = lib.mkForce [ ];
  systemd.services.nginx-config-reload.wantedBy = lib.mkForce [ ];
}
