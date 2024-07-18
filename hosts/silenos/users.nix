{ ... }:
{
  imports = [
    ../../users/usr
  ];
  users.groups.sysconfig.members = [
    "usr"
  ];
  users.groups.steam.members = [
    "usr"
  ];
}
