{
  inputs,
  ...
}:
{
  nativeModule.home-manager.users.usr = {
    imports = [ ./modules/home.nix ];
  };
}
