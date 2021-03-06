{ config, lib, pkgs, ... }:

{
  imports = [
    ../../program/terminal/aws
  ];

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.awscli
    pkgs.heroku
    pkgs.fastlane
    pkgs.graphviz

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

  programs.ssh = {
    matchBlocks = {
      "10.41.110.*" = {
        extraOptions = {
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
      };

      "10.103.36.*" = {
        extraOptions = {
          UserKnownHostsFile = "/dev/null";
          StrictHostKeyChecking = "no";
        };
      };
    };
  };

  programs.zsh = {
    sessionVariables = {
      UVM_AUTO_SWITCH_UNITY_EDITOR = "YES";
      UVM_AUTO_INSTALL_UNITY_EDITOR = "YES";
      UVM_UNITY_INSTALL_BASE_DIR= "/Applications/Unity/Hub/Editor";
      ANDROID_SDK_ROOT = "/usr/local/share/android-sdk";
    };

    shellAliases = {
      gradle = "gw";
    };
  };
}
