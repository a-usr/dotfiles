{
  lib',
  ...
}:
{
  nativeModule = {
    hjem.users.usr = {
      enable = true;
      imports = lib'.getModulesFromDir ./modules;
    };
  };
}
