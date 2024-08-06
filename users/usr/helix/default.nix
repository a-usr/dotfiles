{
  pkgs,
  inputs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.x86_64-linux.helix;
    extraPackages = [pkgs.nixd];
    settings = {};
    languages = {
      language = [
        {
          name = "nix";
          language-servers = ["nixd"];
        }
      ];
      language-server.nixd = {command = "nixd";};
    };
  };
}
