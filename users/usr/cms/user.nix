{
  userModule =
    { pkgs, ... }:
    {
      isNormalUser = true;
      shell = pkgs.nushell;
      openssh.authorizedKeys.keyFiles = [ ./id_ed25519_sk.pub ];
    };
}
