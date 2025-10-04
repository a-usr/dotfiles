{ lib', inputs, ... }:
{
  nativeModule = (
    { pkgs, ... }:
    {

      users.users.usr = {
        # initialPassword = "a";
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "localhost"
          "scanner"
          "lp"
        ]; # Enable ‘sudo’ for the user.
        shell = pkgs.nushell;
        packages = [ ];
      };
    }
  );
}
