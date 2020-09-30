{ config, lib, pkgs, ... }:

{
  imports = [
    ../../program/terminal/aws
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.git-crypt

    pkgs.awscli
    pkgs.heroku

    # ssh
    pkgs.sshpass

    # gradle
    pkgs.gradle_4
    pkgs.gradle-completion
    pkgs.larussopkgs.gdub
    pkgs.adoptopenjdk-hotspot-bin-8

    # unity
    pkgs.mono6
  ];

  programs.zsh = {
    sessionVariables = {
      UVM_AUTO_SWITCH_UNITY_EDITOR = "YES";
      UVM_AUTO_INSTALL_UNITY_EDITOR = "YES";
      UVM_UNITY_INSTALL_BASE_DIR= "/Applications/Unity/Hub/Editor";
      ANDROID_SDK_ROOT = "/usr/local/share/android-sdk";
      PATH = "$PATH:$HOME/.local/bin";
    };

    shellAliases = {
      gradle = "gw";
    };
  };
}