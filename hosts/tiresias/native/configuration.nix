{
  environment.etc."resolv.conf" = {
    enable = true;
    text = ''
      	nameserver 2a00:1098:2b::1
      	nameserver 2a01:4f8:c2c:123f::1
      	nameserver 2a00:1098:2c::1
      	'';
  };
  system.stateVersion = "26.05";
}
