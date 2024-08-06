{
  pkgs,
  inputs,
  ...
}: {
  programs.helix = {
    enabled = true;
    package = inputs.helix.packages.helix;
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
