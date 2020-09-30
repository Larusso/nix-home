{ config, lib, pkgs, ... }:
{
    home.file.".Xcompose".source = ./.Xcompose;
    home.file.".xprofile".source = ./.xprofile;
}