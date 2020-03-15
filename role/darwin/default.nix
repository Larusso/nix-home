{ config, lib, pkgs, attrsets, ... }:
{
    nixpkgs.config.allowUnfree = true;

    programs.gpg = {
        enable = true;
        settings = {
            auto-key-locate = "keyserver";
            auto-key-retrieve = true;
            no-emit-version = true;
        };
    };

    home.file.".gnupg/gpg-agent.conf".text = ''
        enable-ssh-support
        default-cache-ttl 600
        max-cache-ttl 7200
        pinentry-program ${pkgs.pinentry_mac}/${pkgs.pinentry_mac.binaryPath}
    '';
}
