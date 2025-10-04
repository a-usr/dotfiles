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
    { pkgs, ... }:
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
    }
  );

}
