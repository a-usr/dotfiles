{
  pkgs,
  hostConfig,
  lib,
  ...
}:

{
  config = lib.mkIf hostConfig.general.sound {
    home.packages = with pkgs; [ playerctl ];
    services.playerctld = {
      enable = true;
    };
  };
}
