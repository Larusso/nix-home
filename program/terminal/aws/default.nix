{ config, lib, pkgs, ... }:
{
    home.file.".aws/credentials".source = ./credentials;
    home.file.".aws/config".source = ./config;
}