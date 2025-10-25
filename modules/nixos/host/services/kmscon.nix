{
  config,
  global,
  lib,
  ...
}:
{
  options = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = !global.headless;
    };
  };

  config.nativeModule = (
    { pkgs, ... }@args:
    let
      nativeConfig = args.config;
      getty'tty4 = {
        inherit (nativeConfig.systemd.services."getty@") serviceConfig;
        environment.TTY = "tty4";
        restartIfChanged = false;
      }
      # // {
      #      environment.TTY = "tty4";
      #    }
      ;

    in
    {

      services.kmscon = {
        enable = config.enable;
        fonts = [
          {
            name = "Hurmit Nerd Font Mono";
            package = pkgs.nerd-fonts.hurmit;

          }
        ];
        extraConfig = "xkb-layout=${global.general.kbLayout}";
      };
      systemd.services."kmsconvt@tty4".enable = false;
      systemd.services."getty@tty4" = getty'tty4;
      systemd.services."autovt@tty4" = getty'tty4;
    }
  );

}
