{ ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = # nushell
      ''
        export use ~/.config/nushell/cfg.nu *
      '';
  };
}
