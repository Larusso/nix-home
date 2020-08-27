{ config, pkgs, ... }:
let
  larussopkgsTarball = fetchTarball https://github.com/Larusso/larussopkgs/archive/nixexprs.tar.gz;
in
{
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      larussopkgs = import larussopkgsTarball {
        system = config.nixpkgs.system;
      };
    };
  };
  programs.home-manager.enable = true;
  home.stateVersion = "19.09";
  imports = [
    ./role/darwin
    ./user/larusso
    ./machine/MAC-1439
  ];
}