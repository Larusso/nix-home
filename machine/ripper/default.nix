{ config, lib, pkgs, ... }:

{
  home.packages = [
    pkgs.git-crypt
  ];
}