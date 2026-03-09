{ ... }:
{
  programs.nushell = {
    enable = true;
    # extraConfig = # nushell
    #   ''
    #     	const file = "~/.config/nushell/cfg.nu"
    #     	const file_conditional = if (file exists $file) { $file } else { null }
    #   	source file_conditional
    # '';
  };
}
