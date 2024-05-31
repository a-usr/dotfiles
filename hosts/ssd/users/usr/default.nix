{ home-manager, ... }:
{
  imports = [ 
   
  ];
  users.users.usr = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
  home-manager.users.usr = import ./home.nix;
}
