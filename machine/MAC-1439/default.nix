{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.heroku
    pkgs.fastlane
    # gradle
    pkgs.gradle_4
    pkgs.gradle-completion
    # pkgs.gdub
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

  programs.zsh.shellAliases = { 
    gradle = "gw"; 
  };
}
