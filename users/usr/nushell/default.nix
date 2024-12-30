{ ... }:
{
  programs.nushell = {
    enable = true;
    extraConfig = ''
      if (ls ~/.config/nushell | get "name" | any {|val | ($val == "cfg.nu")}) {
        use ~/.config/nushell/cfg.nu *
      }
    '';
  };
}
