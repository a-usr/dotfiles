{ ... }:
{
  imports = [
    ../../users/usr
  ];
  users.groups.sysconfig.members = [
    "usr"
  ];
}
