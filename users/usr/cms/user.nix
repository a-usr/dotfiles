{
  userModule =
    { pkgs, ... }:
    {
      isNormalUser = true;
      shell = pkgs.nushell;
      openssh.authorizedKeys.keyFiles = [ ./id_ed25519_sk.pub ];
      subUidRanges = [
        {
          startUid = 100000;
          count = 131072;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 131072;
        }
      ];
    };
}
