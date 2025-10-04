{
  userModule =
    { pkgs, ... }:
    {
      isNormalUser = true;
      shell = pkgs.nushell;
    };
}
