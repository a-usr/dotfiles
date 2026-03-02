{
  networking.nameservers = [
    "2a00:1098:2b::1"
    "2a01:4f8:c2c:123f::1"
    "2a00:1098:2c::1"
  ];

  nix.settings.trusted-users = [ "usr" ];
  system.stateVersion = "26.05";
}
